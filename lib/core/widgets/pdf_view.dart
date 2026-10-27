import 'package:flutter/material.dart';

// flutter_pdfview (and dart:io) must never be referenced from a file compiled
// for the web, so the real viewer lives in two sibling files chosen at compile
// time by this conditional export - exactly the technique video_embed.dart
// uses for webview_flutter vs package:web.
import 'pdf_view_native.dart'
    if (dart.library.js_interop) 'pdf_view_web.dart'
    as platform_view;

export 'pdf_view_native.dart'
    if (dart.library.js_interop) 'pdf_view_web.dart'
    show PdfViewerPlatform;

enum PdfViewStatus { loading, ready, failed }

/// Owns the state of one open document: whether it is loading, ready or failed,
/// plus the reload token a retry bumps so the platform view is thrown away and
/// rebuilt instead of reusing a dead one.
class PdfViewerController extends ChangeNotifier {
  PdfViewStatus _status = PdfViewStatus.loading;
  String? _failureMessage;
  int _reloadToken = 0;

  PdfViewStatus get status => _status;

  String? get failureMessage => _failureMessage;

  int get reloadToken => _reloadToken;

  void reportReady({String? failureMessage}) {
    if (_status == PdfViewStatus.ready && _failureMessage == failureMessage) {
      return;
    }
    _status = PdfViewStatus.ready;
    _failureMessage = failureMessage;
    notifyListeners();
  }

  void reportFailed(String message) {
    if (_status == PdfViewStatus.failed && _failureMessage == message) {
      return;
    }
    _status = PdfViewStatus.failed;
    _failureMessage = message;
    notifyListeners();
  }

  /// Silent on purpose: it runs from initState / didUpdateWidget, and notifying
  /// a listening ancestor mid-build would corrupt its element.
  void beginSource() {
    _status = PdfViewStatus.loading;
    _failureMessage = null;
  }

  void reload() {
    _reloadToken++;
    _status = PdfViewStatus.loading;
    _failureMessage = null;
    notifyListeners();
  }
}

/// The platform-specific piece of [PdfViewer]. Each implementation extends this
/// in its own file; the conditional export above picks which one is compiled.
abstract class PdfViewerPlatformView extends StatelessWidget {
  const PdfViewerPlatformView({
    super.key,
    required this.controller,
    required this.title,
    required this.localFilePath,
    required this.remoteUrl,
    required this.canDownload,
  });

  final PdfViewerController controller;
  final String title;

  /// A file already saved inside the app, if there is one.
  final String? localFilePath;

  /// The admin-typed https link, if there is one.
  final String? remoteUrl;

  /// True when the app can fetch bytes for this document right now. The web
  /// build uses it to show a real browser-download action.
  final bool canDownload;

  factory PdfViewerPlatformView.build({
    Key? key,
    required PdfViewerController controller,
    required String title,
    String? localFilePath,
    String? remoteUrl,
    bool canDownload = false,
  }) => platform_view.PdfViewerPlatform(
    key: key,
    controller: controller,
    title: title,
    localFilePath: localFilePath,
    remoteUrl: remoteUrl,
    canDownload: canDownload,
  );
}

/// Opens a PDF/notes document. On Android it renders the real file with
/// flutter_pdfview; on the web it embeds the remote https link in an iframe.
/// The shared chrome here only covers loading and a failed load with a retry,
/// so a missing or corrupt file never spins forever.
class PdfViewer extends StatefulWidget {
  const PdfViewer({
    super.key,
    required this.controller,
    required this.title,
    this.localFilePath,
    this.remoteUrl,
    this.canDownload = false,
  });

  final PdfViewerController controller;
  final String title;
  final String? localFilePath;
  final String? remoteUrl;
  final bool canDownload;

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  @override
  void initState() {
    super.initState();
    widget.controller.beginSource();
  }

  @override
  void didUpdateWidget(PdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.localFilePath != widget.localFilePath ||
        oldWidget.remoteUrl != widget.remoteUrl ||
        oldWidget.controller != widget.controller) {
      widget.controller.beginSource();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, _) {
        final status = widget.controller.status;
        return Stack(
          fit: StackFit.expand,
          children: [
            PdfViewerPlatformView.build(
              key: ValueKey(
                '${widget.localFilePath ?? ''}|${widget.remoteUrl ?? ''}:'
                '${widget.controller.reloadToken}',
              ),
              controller: widget.controller,
              title: widget.title,
              localFilePath: widget.localFilePath,
              remoteUrl: widget.remoteUrl,
              canDownload: widget.canDownload,
            ),
            if (status == PdfViewStatus.loading)
              const Center(child: CircularProgressIndicator()),
            if (status == PdfViewStatus.failed)
              _FailureOverlay(
                message:
                    widget.controller.failureMessage ??
                    'The document could not be opened.',
                onRetry: widget.controller.reload,
              ),
          ],
        );
      },
    );
  }
}

class _FailureOverlay extends StatelessWidget {
  const _FailureOverlay({required this.message, required this.onRetry});

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ColoredBox(
      color: theme.colorScheme.surfaceContainerHighest,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.broken_image_rounded, color: theme.colorScheme.error),
              const SizedBox(height: 10),
              Text(
                message,
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 14),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh_rounded),
                label: const Text('Try again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
