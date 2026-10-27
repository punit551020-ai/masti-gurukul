import 'package:flutter/material.dart';

import 'admin_gate.dart';

/// Wraps a widget (the brand logo) so three quick taps open the admin gate.
///
/// This only hides the entrance; it authorises nothing. Access is decided by the
/// server: [AdminGate] signs in against Supabase Auth and Row Level Security on
/// `public.admins` decides whether that account may write any content at all.
class HiddenAdminTrigger extends StatefulWidget {
  const HiddenAdminTrigger({super.key, required this.child});

  final Widget child;

  @override
  State<HiddenAdminTrigger> createState() => _HiddenAdminTriggerState();
}

class _HiddenAdminTriggerState extends State<HiddenAdminTrigger> {
  static const _window = Duration(milliseconds: 1200);
  final List<DateTime> _taps = <DateTime>[];

  void _onTap() {
    final now = DateTime.now();
    _taps.removeWhere((t) => now.difference(t) > _window);
    _taps.add(now);
    if (_taps.length < 3) return;
    _taps.clear();
    AdminGate.request(context);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _onTap,
      child: widget.child,
    );
  }
}
