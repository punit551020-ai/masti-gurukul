/// Backend connection settings, supplied at build time and never stored in
/// source control.
///
/// Both values come from `--dart-define-from-file=.env`, so the same code runs
/// offline-only with no file present, and connects as soon as the owner creates
/// a Supabase project and fills in `.env`:
///
///   flutter run --dart-define-from-file=.env
///   flutter build apk --release --dart-define-from-file=.env
///
/// The key here is the *publishable* (anon) key. It is safe to ship inside the
/// app because Row Level Security decides what that key may read and write: it
/// can read published content and nothing else. The `service_role` secret key
/// must never appear anywhere in this project.
class BackendConfig {
  const BackendConfig._();

  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');

  static bool get isConfigured =>
      supabaseUrl.isNotEmpty && supabaseAnonKey.isNotEmpty;

  /// False for a mistyped or non-HTTPS value, which would otherwise send content
  /// (and the admin's session token) over a plain connection.
  static bool get isUsable {
    if (!isConfigured) return false;
    final uri = Uri.tryParse(supabaseUrl);
    return uri != null &&
        uri.scheme == 'https' &&
        uri.hasAuthority &&
        uri.pathSegments.every((s) => s.isNotEmpty) &&
        !uri.hasPort;
  }

  /// Shown wherever the app needs to explain why live content is unavailable.
  static String get notConfiguredMessage =>
      'No backend is configured. Content stays on this device only, and the '
      'admin panel is closed. Create a Supabase project and follow '
      'docs/SUPABASE_SETUP.md to turn live updates on.';
}
