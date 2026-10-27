import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../state/app_state.dart';

/// Reloads a screen's data when the backend pushes new content.
///
/// A sync that lands while the student is reading this screen must not force
/// them to close and reopen it, so each content screen re-runs its queries when
/// [AppState.contentVersion] changes.
///
/// [onContentChanged] must only reassign the futures the build reads:
/// `didChangeDependencies` already schedules the rebuild, so calling
/// `setState()` from here is unnecessary.
mixin ContentRefresh<T extends StatefulWidget> on State<T> {
  int? _seenContentVersion;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Watching here registers the dependency, so this method runs again on the
    // next notification.
    final version = context.watch<AppState>().contentVersion;
    if (_seenContentVersion == version) return;
    final previous = _seenContentVersion;
    _seenContentVersion = version;
    if (previous != null) onContentChanged();
  }

  void onContentChanged();
}
