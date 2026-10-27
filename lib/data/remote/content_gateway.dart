import 'remote_content.dart';

/// A readable failure the admin panel can show as-is. Backend errors are
/// translated here so no raw PostgREST payload reaches the UI.
class RemoteFailure implements Exception {
  RemoteFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Raised when a sign-in is rejected. Deliberately vague in the message: the
/// panel must not tell a guesser whether the account exists.
class AdminSignInFailure extends RemoteFailure {
  AdminSignInFailure(super.message);
}

/// The remote content store. The Flutter app only ever talks to content through
/// this interface, so the sync engine and the admin panel can be tested with a
/// fake and swapped for another backend without touching a screen.
abstract class ContentGateway {
  /// Rows the student app may show. Implementations must ask for the published
  /// subset only; unpublished drafts must never reach a student device, even as
  /// a stray row.
  Future<List<ContentRow>> fetchPublished(String table);

  /// Every row, including drafts. Requires an admin session; the backend
  /// rejects it otherwise, which is the point of the check.
  Future<List<ContentRow>> fetchAllForAdmin(String table);

  /// Insert or replace one row. Throws [RemoteFailure] if the backend refuses.
  Future<void> upsert(String table, ContentRow row);

  Future<void> delete(String table, String id);

  /// Stores a file (a PDF or notes sheet) so every student device can fetch it.
  /// Returns the public URL to save on the resource row. Without this step an
  /// attached PDF would exist only on the admin's own phone.
  Future<String> uploadFile({
    required String fileName,
    required List<int> bytes,
    required String contentType,
  });

  /// Emits the name of a table whenever its content changes remotely, so the
  /// app can re-pull and a student sees new material without reopening the app.
  Stream<String> get changedTables;

  Future<void> signInAdmin({required String email, required String password});

  Future<void> signOutAdmin();

  bool get isAdminSignedIn;

  String? get adminEmail;

  Future<void> dispose();
}
