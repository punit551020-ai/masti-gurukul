import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../local/database.dart';

class StudentRepository {
  StudentRepository(this._db);

  final AppDatabase _db;
  static const _currentStudentKey = 'current_student_id';
  static const _uuid = Uuid();

  StudentsCompanion _companion({
    required String name,
    String? classId,
    String avatarEmoji = '🎓',
  }) {
    final now = DateTime.now();
    return StudentsCompanion.insert(
      id: _uuid.v4(),
      displayName: name,
      classId: Value(classId),
      avatarEmoji: Value(avatarEmoji),
      createdAt: Value(now),
      lastSeenAt: Value(now),
    );
  }

  Future<Student> createStudent({required String name, String? classId}) async {
    final row = _companion(name: name, classId: classId);
    await _db.into(_db.students).insert(row);
    await setCurrentStudentId(row.id.value);
    final created = _db.select(_db.students)
      ..where((t) => t.id.equals(row.id.value));
    return created.getSingle();
  }

  Future<void> setCurrentStudentId(String id) => _db
      .into(_db.appSettings)
      .insertOnConflictUpdate(
        AppSettingsCompanion.insert(key: _currentStudentKey, value: id),
      );

  /// Forgets who is signed in. Only this row goes: the student's lessons,
  /// bookmarks and downloads stay in the database for the next sign-in.
  Future<void> clearCurrentStudentId() => (_db.delete(
    _db.appSettings,
  )..where((t) => t.key.equals(_currentStudentKey))).go();

  Future<String?> currentStudentId() async {
    final row =
        await (_db.select(_db.appSettings)
              ..where((t) => t.key.equals(_currentStudentKey))
              ..limit(1))
            .getSingleOrNull();
    return row?.value;
  }

  Future<Student?> currentStudent() async {
    final id = await currentStudentId();
    if (id == null) return null;
    return (_db.select(
      _db.students,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Future<void> updateProfile({
    required String studentId,
    String? displayName,
    String? classId,
    String? avatarEmoji,
  }) {
    return _db
        .update(_db.students)
        .replace(
          StudentsCompanion(
            id: Value(studentId),
            displayName: displayName == null
                ? const Value.absent()
                : Value(displayName),
            classId: classId == null ? const Value.absent() : Value(classId),
            avatarEmoji: avatarEmoji == null
                ? const Value.absent()
                : Value(avatarEmoji),
          ),
        );
  }

  Future<Student?> studentById(String id) => (_db.select(
    _db.students,
  )..where((t) => t.id.equals(id))).getSingleOrNull();
}
