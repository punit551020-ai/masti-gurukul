import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';
import 'package:web/web.dart' as web;

import 'pdf_view.dart';

/// Web implementation of the PDF viewer, reachable only through the conditional
/// export in pdf_view.dart: it pulls in dart:ui_web and package:web, which do
/// not exist on Android. flutter_pdfview has no web build, so the document is
/// shown by embedding the admin's remote https link in an <iframe> and letting
/// the browser's own PDF viewer render it.
///
/// This is deliberately honest about what the web build can and cannot do:
/// there is no in-app page turning here (the browser viewer owns that), and the
/// local file saved by the Android app cannot be read back in the browser.
class PdfViewerPlatform extends PdfViewerPlatformView {
  const PdfViewerPlatform({
    super.key,
    required super.controller,
    required super.title,
    required super.localFilePath,
    required super.remoteUrl,
    required super.canDownload,
  });

  @override
  Widget build(BuildContext context) => _WebPdfView(
    controller: controller,
    title: title,
    remoteUrl: remoteUrl,
    canDownload: canDownload,
  );
}

class _WebPdfView extends StatefulWidget {
  const _WebPdfView({
    required this.controller,
    required this.title,
    required this.remoteUrl,
    required this.canDownload,
  });

  final PdfViewerController controller;
  final String title;
  final String? remoteUrl;
  final bool canDownload;

  @override
  State<_WebPdfView> createState() => _WebPdfViewState();
}

class _WebPdfViewState extends State<_WebPdfView> {
  /// A fresh id per instance: two viewers alive at the same time must not
  /// share one registered html element.
  static int _serial = 0;

  late final String _viewTypeId;
  late final web.HTMLIFrameElement _frame;

  /// The admin typed this URL; only embed it if it is a plain https link.
  Uri? get _remote => widget.remoteUrl == null
      ? null
      : _parseHttps(Uri.tryParse(widget.remoteUrl!));

  static Uri? _parseHttps(Uri? uri) {
    if (uri == null) return null;
    if (uri.scheme != 'https') return null;
    if (uri.host.isEmpty) return null;
    if (uri.userInfo.isNotEmpty) return null;
    return uri;
  }

  @override
  void initState() {
    super.initState();
    _serial++;
    _viewTypeId = 'masti-gurukul-pdf-$_serial';
    final remote = _remote;
    _frame = _buildFrame(remote);
    ui_web.platformViewRegistry.registerViewFactory(
      _viewTypeId,
      (int viewId) => _frame,
    );

    // initState runs inside the build phase, so the first status has to wait
    // for the frame to end before notifying listening ancestors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _reportState();
    });
  }

  /// The frame points at the remote https document, or at about:blank when
  /// there is nothing safe to embed (buildFrame(null) path).
  web.HTMLIFrameElement _buildFrame(Uri? remote) {
    final frame = web.document.createElement('iframe') as web.HTMLIFrameElement
      ..title = widget.title
      ..allowFullscreen = true
      ..style.cssText =
          'width:100%;height:100%;border:0;display:block;background:#e9e9e9;';
    // The browser's PDF viewer also needs to be able to save the file itself.
    frame.setAttribute('allow', 'autoplay; fullscreen');
    if (remote != null) {
      frame.src = remote.toString();
    } else {
      frame.src = 'about:blank';
    }
    return frame;
  }

  void _reportState() {
    if (_remote != null) {
      widget.controller.reportReady();
    } else {
      widget.controller.reportReady();
    }
  }

  /// Hands the file to the browser's own download manager. The web build cannot
  /// write into the app folder (that is dart:io / Android only), so this is the
  /// only truthful way to "save the bytes locally" here.
  void _downloadWithBrowser() {
    final remote = _remote;
    if (remote == null) return;
    final anchor = web.document.createElement('a') as web.HTMLAnchorElement
      ..href = remote.toString()
      ..setAttribute('download', _fileName(remote))
      ..target = '_blank';
    web.document.body!.appendChild(anchor);
    anchor.click();
    anchor.remove();
  }

  String _fileName(Uri uri) {
    final segments = uri.pathSegments
        .where((s) => s.isNotEmpty)
        .toList(growable: false);
    return segments.isEmpty ? widget.title : segments.last;
  }

  @override
  Widget build(BuildContext context) {
    if (_remote == null) {
      return _NoSourcePane(
        title: widget.title,
        onDownload: widget.canDownload ? _downloadWithBrowser : null,
      );
    }
    return Column(
      children: [
        Expanded(child: HtmlElementView(viewType: _viewTypeId)),
        _WebNoteBar(
          fileName: _fileName(_remote!),
          onDownload: _downloadWithBrowser,
        ),
      ],
    );
  }
}

/// Footer under the embedded browser viewer. It states plainly that page
/// turning is the browser's job, not the app's, and offers a real download.
class _WebNoteBar extends StatelessWidget {
  const _WebNoteBar({required this.fileName, required this.onDownload});

  final String fileName;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHighest,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  'Showing "$fileName" with your browser\'s PDF viewer. The '
                  'app cannot turn pages one at a time on the web.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shown when there is no safe remote link to embed. Never pretends a file is
/// open: explains the situation and, when bytes are available, hands them to
/// the browser to save.
class _NoSourcePane extends StatelessWidget {
  const _NoSourcePane({required this.title, this.onDownload});

  final String title;
  final VoidCallback? onDownload;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.picture_as_pdf_rounded,
              size: 40,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 14),
            Text(
              '"$title" has no https web link, so the browser cannot show it '
              'here. The file can only be read on the Android app, after it is '
              'downloaded.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            if (onDownload != null)
              FilledButton.icon(
                onPressed: onDownload,
                icon: const Icon(Icons.download_rounded),
                label: const Text('Download'),
              )
            else
              Text(
                'There is nothing for the browser to download for this file.',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
