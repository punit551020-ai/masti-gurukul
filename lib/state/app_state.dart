import 'dart:async';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/config/backend_config.dart';
import '../data/local/database.dart';
import '../data/repositories/admin_repository.dart';
import '../data/repositories/catalog_repository.dart';
import '../data/repositories/download_repository.dart';
import '../data/repositories/student_repository.dart';
import '../data/repositories/sync_repository.dart';
import '../data/remote/content_gateway.dart';
import '../data/remote/supabase_content_gateway.dart';

class AppState extends ChangeNotifier {
  AppState._(
    this.database,
    this.students,
    this.catalog,
    this.downloads,
    this.admin, {
    this.gateway,
    this.sync,
  });

  /// Offline-only state, used by widget tests and by any build with no backend
  /// configured. Nothing here can reach another device.
  AppState.forTesting(AppDatabase db)
    : database = db,
      students = StudentRepository(db),
      catalog = CatalogRepository(db),
      downloads = DownloadRepository(db),
      admin = AdminRepository(db),
      gateway = null,
      sync = null,
      // An in-memory database has nothing to load, so the app must not sit on
      // the boot screen forever.
      _ready = true;

  /// The same state with a backend wired in, over an injected gateway.
  ///
  /// This exists so the admin sign-in flow - the part that decides whether the
  /// edit buttons ever appear - can be tested without a live Supabase project
  /// and without ever sending a password anywhere.
  @visibleForTesting
  AppState.withGateway(AppDatabase db, ContentGateway gateway)
    : database = db,
      students = StudentRepository(db),
      catalog = CatalogRepository(db),
      downloads = DownloadRepository(db),
      admin = AdminRepository(db, gateway),
      gateway = gateway,
      sync = SyncRepository(db, gateway),
      _ready = true;

  final AppDatabase database;
  final StudentRepository students;
  final CatalogRepository catalog;
  final DownloadRepository downloads;
  final AdminRepository admin;
  final ContentGateway? gateway;
  final SyncRepository? sync;

  /// True when this build is wired to the shared backend.
  bool get isLive => gateway != null;

  Student? _currentStudent;
  ThemeMode _themeMode = ThemeMode.system;
  String? _selectedClassId;
  bool _ready = false;
  StreamSubscription<void>? _syncSubscription;
  StreamSubscription<void>? _statusSubscription;

  Student? get currentStudent => _currentStudent;
  ThemeMode get themeMode => _themeMode;
  bool get ready => _ready;
  String? get selectedClassId => _selectedClassId;
  SyncPhase get syncPhase => sync?.phase ?? SyncPhase.idle;
  DateTime? get lastSyncedAt => sync?.lastSyncedAt;
  String? get syncError => sync?.lastError;

  static Future<AppState> bootstrap() async {
    final db = AppDatabase.open();
    ContentGateway? gateway;
    SyncRepository? sync;
    if (BackendConfig.isUsable) {
      await Supabase.initialize(
        url: BackendConfig.supabaseUrl,
        publishableKey: BackendConfig.supabaseAnonKey,
      );
      gateway = SupabaseContentGateway(Supabase.instance.client);
      sync = SyncRepository(db, gateway);
    }
    final state = AppState._(
      db,
      StudentRepository(db),
      CatalogRepository(db),
      DownloadRepository(db),
      AdminRepository(db, gateway),
      gateway: gateway,
      sync: sync,
    );
    await state._start();
    return state;
  }

  Future<void> _start() async {
    // Only seed the structure locally when there is no backend to ask. With a
    // backend configured, ids must come from the server or every device drifts
    // apart and a student's bookmarks point at rows that exist nowhere else.
    if (gateway == null) {
      await catalog.seedStructureIfEmpty();
    }
    _currentStudent = await students.currentStudent();
    final storedTheme =
        await (database.select(database.appSettings)
              ..where((t) => t.key.equals('theme_mode'))
              ..limit(1))
            .getSingleOrNull();
    _themeMode = _parseTheme(storedTheme?.value);
    final storedClass =
        await (database.select(database.appSettings)
              ..where((t) => t.key.equals('selected_class_id'))
              ..limit(1))
            .getSingleOrNull();
    _selectedClassId = storedClass?.value ?? _currentStudent?.classId;
    _ready = true;
    notifyListeners();
    unawaited(_startSync());
  }

  /// Bumped every time new content lands in the local database. Screens are keyed
  /// on it, so a lesson the admin just added appears without the student
  /// reopening the app.
  int get contentVersion => _contentVersion;
  int _contentVersion = 0;

  /// Pulls the published catalogue in the background, then keeps listening. A
  /// student who opens the app offline simply sees whatever was last synced.
  Future<void> _startSync() async {
    final engine = sync;
    if (engine == null) return;
    _statusSubscription = engine.statusChanged.listen((_) => notifyListeners());
    _syncSubscription = engine.contentChanged.listen((_) {
      _contentVersion++;
      notifyListeners();
    });
    await engine.pullAll();
  }

  /// Called by pull-to-refresh and by the admin panel after it saves.
  Future<void> refreshContent() async {
    await sync?.pullAll();
    notifyListeners();
  }

  Future<void> setSelectedClassId(String classId) async {
    _selectedClassId = classId;
    notifyListeners();
    await database
        .into(database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: 'selected_class_id', value: classId),
        );
  }

  ThemeMode _parseTheme(String? value) => switch (value) {
    'light' => ThemeMode.light,
    'dark' => ThemeMode.dark,
    _ => ThemeMode.system,
  };

  Future<void> startStudent({required String name, String? classId}) async {
    _currentStudent = await students.createStudent(
      name: name,
      classId: classId,
    );
    if (classId != null) await setSelectedClassId(classId);
    notifyListeners();
  }

  Future<void> switchStudent(Student student) async {
    await students.setCurrentStudentId(student.id);
    _currentStudent = student;
    notifyListeners();
  }

  /// Sends the app back to the Welcome screen. The signed-in student's row
  /// stays in the local database, so their name reappears under "Other
  /// profiles on this device" once the next sign-in happens.
  Future<void> signOut() async {
    await students.clearCurrentStudentId();
    _currentStudent = null;
    notifyListeners();
  }

  Future<void> updateProfile({String? displayName, String? classId}) async {
    final student = _currentStudent;
    if (student == null) return;
    await students.updateProfile(
      studentId: student.id,
      displayName: displayName,
      classId: classId,
    );
    _currentStudent = await students.studentById(student.id);
    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    notifyListeners();
    await database
        .into(database.appSettings)
        .insertOnConflictUpdate(
          AppSettingsCompanion.insert(key: 'theme_mode', value: mode.name),
        );
  }

  @override
  void dispose() {
    _syncSubscription?.cancel();
    _statusSubscription?.cancel();
    // Otherwise the realtime channel, its stream controllers and the debounce
    // timer outlive the state object, and a second AppState in the same process
    // stacks a duplicate listener on top of the first.
    sync?.dispose();
    gateway?.dispose();
    super.dispose();
  }
}
