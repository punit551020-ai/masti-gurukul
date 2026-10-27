import 'dart:async';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'content_gateway.dart';
import 'remote_content.dart';

/// Supabase implementation of [ContentGateway].
///
/// This class holds no privileges of its own. Everything it does is permitted
/// or refused by Row Level Security on the server: an anonymous student build
/// can read published rows and nothing else, and only a signed-in admin session
/// can write. Turning the panel off in Dart would change nothing about that —
/// which is exactly why the panel is not the security boundary.
class SupabaseContentGateway implements ContentGateway {
  SupabaseContentGateway(this._client) {
    _subscribe();
  }

  final SupabaseClient _client;
  final _changes = StreamController<String>.broadcast();
  RealtimeChannel? _channel;

  /// Set only when the server's `is_admin()` says this session is on the
  /// `public.admins` list; see [signInAdmin].
  bool _allowListed = false;

  static const _tables = <String>[
    RemoteTables.schoolClasses,
    RemoteTables.boards,
    RemoteTables.subjects,
    RemoteTables.chapters,
    RemoteTables.lessons,
    RemoteTables.resources,
    RemoteTables.tests,
    RemoteTables.testQuestions,
    RemoteTables.liveClasses,
    RemoteTables.announcements,
  ];

  static const _contentBucket = 'library';

  /// Object keys are built from whatever the admin's file picker reported, so
  /// they are reduced to a safe slug: no `..`, no separators, no query text that
  /// could escape the bucket or overwrite an unrelated object.
  static String _objectKey(String fileName) {
    final name = fileName.split(RegExp(r'[/\\]')).last.toLowerCase();
    final slug = name
        .replaceAll(RegExp(r'[^a-z0-9._-]+'), '-')
        .replaceAll(RegExp(r'-{2,}'), '-')
        .replaceAll(RegExp(r'^[.-]+|[.-]+$'), '');
    final safe = slug.isEmpty ? 'file' : slug;
    final stamp = DateTime.now().millisecondsSinceEpoch;
    return '$stamp-$safe';
  }

  static String? _visibilityColumn(String table) => switch (table) {
    RemoteTables.announcements => 'is_active',
    RemoteTables.lessons ||
    RemoteTables.resources ||
    RemoteTables.tests ||
    RemoteTables.liveClasses => 'is_published',
    _ => null,
  };

  @override
  Future<List<ContentRow>> fetchPublished(String table) async {
    var query = _client.from(table).select();
    final column = _visibilityColumn(table);
    if (column != null) query = query.eq(column, true);
    return _rows(await query);
  }

  @override
  Future<List<ContentRow>> fetchAllForAdmin(String table) async {
    _requireSession();
    return _rows(await _client.from(table).select());
  }

  @override
  Future<void> upsert(String table, ContentRow row) async {
    _requireSession();
    await _guard(() => _client.from(table).upsert(row), 'save changes to');
  }

  @override
  Future<void> delete(String table, String id) async {
    _requireSession();
    await _guard(
      () => _client.from(table).delete().eq('id', id),
      'remove rows from',
    );
  }

  @override
  Future<String> uploadFile({
    required String fileName,
    required List<int> bytes,
    required String contentType,
  }) async {
    _requireSession();
    final key = _objectKey(fileName);
    try {
      await _client.storage
          .from(_contentBucket)
          .uploadBinary(
            key,
            Uint8List.fromList(bytes),
            fileOptions: FileOptions(contentType: contentType, upsert: true),
          );
      return _client.storage.from(_contentBucket).getPublicUrl(key);
    } on StorageException catch (error) {
      throw RemoteFailure(
        'The file could not be stored on the server: ${error.message}. '
        'Check that the "$_contentBucket" bucket exists and allows admin uploads.',
      );
    }
  }

  @override
  Stream<String> get changedTables => _changes.stream;

  @override
  Future<void> signInAdmin({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email.trim(),
        password: password,
      );
      if (response.session == null) {
        throw AdminSignInFailure(
          'Sign in did not complete. Check the network and try again.',
        );
      }
    } on AuthException catch (error) {
      throw AdminSignInFailure(
        'That email and password were not accepted. ${error.message}',
      );
    }

    // A correct password is not the finish line. Supabase accepts sign-ups for
    // any account in this project, and `isAdminSignedIn` used to mean "any
    // session at all", so a student could open the whole panel with an account
    // of their own. The server's `public.admins` list is the only thing that
    // makes someone an admin, and `is_admin()` is the only way to ask about it
    // without exposing that table — so the answer is asked for here, and a "no"
    // ends the session again.
    if (!await _serverListsThisAccountAsAdmin()) {
      await signOutAdmin();
      throw AdminSignInFailure(
        'This account is not the admin of this school, so the server keeps the '
        'panel closed for it. Being able to sign in is not the same as being '
        'allowed to edit content.',
      );
    }
    _allowListed = true;
  }

  /// False on any doubt: an unreachable server, a rejected call, or a plain "no".
  Future<bool> _serverListsThisAccountAsAdmin() async {
    try {
      return await _client.rpc<bool>('is_admin') == true;
    } on PostgrestException {
      return false;
    } on AuthException {
      return false;
    }
  }

  @override
  Future<void> signOutAdmin() async {
    _allowListed = false;
    await _client.auth.signOut();
  }

  /// A session alone is not authority — see [signInAdmin]. `_allowListed` is set
  /// only by the server's own answer, so it starts false after every app launch,
  /// which is why a returning admin is asked for the password again.
  @override
  bool get isAdminSignedIn =>
      _allowListed && _client.auth.currentSession != null;

  @override
  String? get adminEmail => _client.auth.currentSession?.user.email;

  @override
  Future<void> dispose() async {
    final channel = _channel;
    if (channel != null) await _client.realtime.removeChannel(channel);
    _channel = null;
    await _changes.close();
  }

  void _subscribe() {
    final channel = _client.realtime.channel('masti-gurukul-content');
    for (final table in _tables) {
      channel.onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: table,
        callback: (_) {
          if (!_changes.isClosed) _changes.add(table);
        },
      );
    }
    _channel = channel.subscribe();
  }

  void _requireSession() {
    if (!isAdminSignedIn) {
      throw AdminSignInFailure(
        'Your admin session ended. Please sign in again.',
      );
    }
  }

  Future<void> _guard(Future<Object?> Function() operation, String verb) async {
    try {
      await operation();
    } on PostgrestException catch (error) {
      throw RemoteFailure(_describe(error, verb));
    } on Object catch (error) {
      // A dead network does not raise PostgrestException — the HTTP layer's own
      // exception does. AdminRepository's rollback watches only for
      // [RemoteFailure], so an unwrapped socket error would leave the owner's
      // device holding a row the server never accepted.
      throw RemoteFailure(
        'The server could not be reached to $verb the content '
        '(${error.runtimeType}). Nothing on this device was changed — check the '
        'internet and try again.',
      );
    }
  }

  String _describe(PostgrestException error, String verb) {
    final code = error.code;
    // An expired JWT is not a permissions story. Saying "Row Level Security
    // allows only the admin" here would send the owner to check the wrong thing.
    if (code == '401' || code == 'PGRST301') {
      _allowListed = false;
      return 'The server no longer recognises this admin session, so it refused '
          'to $verb the content. Close the panel, sign in again, and retry — '
          'nothing on this device was changed.';
    }
    if (code == '42501') {
      return 'The server refused to $verb the content tables. Row Level '
          'Security allows only the admin account, so this device is not '
          'authorised for that change.';
    }
    if (code == '23503') {
      return 'The server refused that change because another row still points '
          'at it. Remove the children first.';
    }
    if (code == '23505') {
      return 'That row already exists on the server with a different value. '
          'Refresh and try again.';
    }
    return 'The server refused to $verb the content tables'
        '${code == null ? '' : ' (code $code)'}. ${error.message}';
  }

  List<ContentRow> _rows(dynamic result) {
    if (result is! List) return const [];
    return result
        .whereType<Map<String, dynamic>>()
        .map(Map<String, dynamic>.from)
        .toList();
  }
}
