import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/backend_config.dart';
import '../../data/remote/content_gateway.dart';
import '../../state/app_state.dart';
import 'admin_home_screen.dart';

/// Sign-in prompt for the hidden admin panel.
///
/// The triple-tap that reaches this dialog only hides the door; it authorises
/// nothing. What actually protects the content is Supabase Row Level Security:
/// a write is accepted only when the session belongs to a user id listed in the
/// `public.admins` table on the server. So a student who decompiles the APK,
/// finds this screen and types the right-looking password still cannot change a
/// single row, because the server never heard of them.
///
/// With no backend configured the panel does not open at all. An offline
/// device-side password would be the only thing standing between a student and
/// the edit buttons, and that is not a password — it is a speed bump.
class AdminGate {
  const AdminGate._();

  static const _maxAttempts = 5;
  static const _lockDuration = Duration(seconds: 60);

  static int _failures = 0;
  static DateTime? _lockedUntil;

  static Future<void> request(BuildContext context) async {
    final state = context.read<AppState>();
    final gateway = state.gateway;

    if (gateway == null) {
      _explain(context, BackendConfig.notConfiguredMessage);
      return;
    }
    if (!BackendConfig.isUsable) {
      _explain(
        context,
        'SUPABASE_URL must start with https:// and SUPABASE_ANON_KEY must both '
        'be set in the .env file. See docs/SUPABASE_SETUP.md.',
      );
      return;
    }
    if (gateway.isAdminSignedIn) {
      await _open(context);
      return;
    }

    final lockedUntil = _lockedUntil;
    if (lockedUntil != null && lockedUntil.isAfter(DateTime.now())) {
      _explain(
        context,
        'Too many failed attempts. Try again in '
        '${lockedUntil.difference(DateTime.now()).inSeconds + 1} seconds.',
      );
      return;
    }

    final signedIn = await showDialog<bool>(
      context: context,
      builder: (_) => _AdminSignInDialog(gateway: gateway),
    );
    if (signedIn != true || !context.mounted) return;
    await _open(context);
  }

  static Future<void> _open(BuildContext context) =>
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => const AdminHomeScreen()));

  static void _noteFailure() {
    _failures++;
    if (_failures >= _maxAttempts) {
      _failures = 0;
      _lockedUntil = DateTime.now().add(_lockDuration);
    }
  }

  static void _reset() {
    _failures = 0;
    _lockedUntil = null;
  }

  /// Forgets the failed-attempt count and any running cool-down.
  ///
  /// Widget tests need this because the counters above live for the whole
  /// process, and one test's rejected password must not eat another test's
  /// attempts.
  @visibleForTesting
  static void resetForTesting() => _reset();

  static void _explain(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 6)),
    );
  }
}

class _AdminSignInDialog extends StatefulWidget {
  const _AdminSignInDialog({required this.gateway});

  final ContentGateway gateway;

  @override
  State<_AdminSignInDialog> createState() => _AdminSignInDialogState();
}

class _AdminSignInDialogState extends State<_AdminSignInDialog> {
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  bool _showPassword = false;
  String? _error;

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_busy) return;
    final email = _email.text.trim();
    final password = _password.text;
    if (email.isEmpty || password.isEmpty) {
      setState(() => _error = 'Enter both the admin email and password.');
      return;
    }
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await widget.gateway.signInAdmin(email: email, password: password);
      AdminGate._reset();
      if (mounted) Navigator.of(context).pop(true);
    } on AdminSignInFailure catch (failure) {
      AdminGate._noteFailure();
      if (mounted) setState(() => _error = failure.message);
    } on RemoteFailure catch (failure) {
      if (mounted) setState(() => _error = failure.message);
    } on Object catch (_) {
      // Anything else — a dead network mid-call, an unexpected reply shape —
      // used to escape the dialog and paint an exception screen over the owner's
      // sign-in form. It is not a rejected password, so it is not counted.
      if (mounted) {
        setState(
          () => _error =
              'The sign-in could not be completed. Check the internet '
              'connection and try again.',
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Admin sign in'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            controller: _email,
            autofocus: true,
            enabled: !_busy,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Admin email'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _password,
            enabled: !_busy,
            obscureText: !_showPassword,
            decoration: InputDecoration(
              labelText: 'Password',
              errorText: _error,
              suffixIcon: IconButton(
                tooltip: _showPassword ? 'Hide password' : 'Show password',
                icon: Icon(
                  _showPassword
                      ? Icons.visibility_off_rounded
                      : Icons.visibility_rounded,
                ),
                onPressed: () => setState(() => _showPassword = !_showPassword),
              ),
            ),
            onSubmitted: (_) => _submit(),
          ),
          const SizedBox(height: 12),
          Text(
            'Only the account listed as admin on the server can sign in, and '
            'only that account may change content. Signing in here does not '
            'grant access by itself — the database decides.',
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _busy ? null : _submit,
          child: _busy
              ? const SizedBox(
                  height: 18,
                  width: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Sign in'),
        ),
      ],
    );
  }
}
