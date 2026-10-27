import 'dart:async';
import 'dart:io' as io;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

import 'pdf_view.dart';

/// Non-web implementation. Reachable only through the conditional export in
/// pdf_view.dart, because flutter_pdfview and dart:io have no web build.
class PdfViewerPlatform extends PdfViewerPlatformView {
  const PdfViewerPlatform({
    super.key,
    required super.controller,
    required super.title,
    super.localFilePath,
    super.remoteUrl,
    required super.canDownload,
  });

  @override
  Widget build(BuildContext context) => _NativePdfView(
    controller: controller,
    title: title,
    localFilePath: localFilePath,
    remoteUrl: remoteUrl,
    canDownload: canDownload,
  );
}

enum _Phase { checking, showing, noFile, wrongPlatform, failed }

class _NativePdfView extends StatefulWidget {
  const _NativePdfView({
    required this.controller,
    required this.title,
    required this.localFilePath,
    required this.remoteUrl,
    required this.canDownload,
  });

  final PdfViewerController controller;
  final String title;
  final String? localFilePath;
  final String? remoteUrl;
  final bool canDownload;

  @override
  State<_NativePdfView> createState() => _NativePdfViewState();
}

class _NativePdfViewState extends State<_NativePdfView> {
  PDFViewController? _pdfController;
  int _page = 0;
  int _pageCount = 0;
  _Phase _phase = _Phase.checking;
  String _message = '';

  @override
  void initState() {
    super.initState();
    // initState runs inside the build phase, so the first status has to wait
    // for the frame to end before it may notify listening ancestors.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _inspect();
    });
  }

  void _inspect() {
    final path = widget.localFilePath;
    if (path == null || path.isEmpty) {
      _finish(_Phase.noFile, 'This file is not saved on this device yet.');
      return;
    }

    final io.File file;
    try {
      file = io.File(path);
    } on Object catch (_) {
      _finish(_Phase.failed, 'The saved file could not be read.');
      return;
    }

    final bool exists;
    final int length;
    try {
      exists = file.existsSync();
      length = exists ? file.lengthSync() : 0;
    } on Object catch (_) {
      _finish(
        _Phase.failed,
        'The saved file is missing or damaged. Download it again.',
      );
      return;
    }

    if (!exists || length == 0) {
      _finish(
        _Phase.failed,
        'The saved file is missing or empty. Download it again.',
      );
      return;
    }

    // flutter_pdfview only draws on Android and iOS. Desktop hosts are not a
    // build target here, so say so plainly instead of spinning forever.
    if (kIsWeb || !(io.Platform.isAndroid || io.Platform.isIOS)) {
      _finish(
        _Phase.wrongPlatform,
        'The file is saved, but page-by-page reading inside the app needs '
        'Android or iOS.',
      );
      return;
    }

    _finish(_Phase.showing, '');
  }

  void _finish(_Phase phase, String message) {
    if (!mounted) return;
    setState(() {
      _phase = phase;
      _message = message;
    });
    // Only a genuinely broken file is a failure with a retry. The other
    // placeholders are honest, settled states, so they report ready.
    if (phase == _Phase.failed) {
      widget.controller.reportFailed(message);
    } else {
      widget.controller.reportReady();
    }
  }

  void _setPage(int target) {
    final controller = _pdfController;
    if (controller == null || _pageCount == 0) return;
    final clamped = target.clamp(0, _pageCount - 1);
    unawaited(controller.setPage(clamped));
  }

  Future<void> _jumpToPage() async {
    final max = _pageCount;
    if (max == 0) return;
    final field = TextEditingController(text: '${_page + 1}');
    final chosen = await showDialog<int>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Go to page 1-$max'),
        content: TextField(
          controller: field,
          autofocus: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Page number'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              final value = int.tryParse(field.text.trim());
              Navigator.of(dialogContext).pop(value);
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
    field.dispose();
    if (chosen == null) return;
    _setPage(chosen - 1);
  }

  @override
  Widget build(BuildContext context) {
    switch (_phase) {
      case _Phase.checking:
        // The shared PdfViewer chrome already shows a spinner while the
        // controller is loading; render nothing extra here.
        return const SizedBox.expand();
      case _Phase.failed:
        // The overlay in PdfViewer covers this; keep the surface blank.
        return const SizedBox.expand();
      case _Phase.noFile:
      case _Phase.wrongPlatform:
        return _Placeholder(message: _message);
      case _Phase.showing:
        return _buildDocument();
    }
  }

  Widget _buildDocument() {
    final path = widget.localFilePath!;
    return Column(
      children: [
        Expanded(
          child: PDFView(
            filePath: path,
            autoSpacing: true,
            useBestQuality: true,
            enableSwipe: true,
            swipeHorizontal: false,
            nightMode: false,
            onViewCreated: (PDFViewController controller) {
              _pdfController = controller;
              unawaited(
                controller.getPageCount().then((count) {
                  if (!mounted) return;
                  setState(() => _pageCount = count ?? 0);
                }),
              );
            },
            onPageChanged: (int? page, int? total) {
              if (!mounted) return;
              setState(() {
                _page = page ?? 0;
                _pageCount = total ?? _pageCount;
              });
            },
            onError: (Object? error) {
              _finish(
                _Phase.failed,
                'This PDF could not be opened. It may be corrupt.',
              );
            },
          ),
        ),
        _PageBar(
          page: _page,
          pageCount: _pageCount,
          onPrevious: () => _setPage(_page - 1),
          onNext: () => _setPage(_page + 1),
          onJump: _jumpToPage,
        ),
      ],
    );
  }
}

class _PageBar extends StatelessWidget {
  const _PageBar({
    required this.page,
    required this.pageCount,
    required this.onPrevious,
    required this.onNext,
    required this.onJump,
  });

  final int page;
  final int pageCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onJump;

  @override
  Widget build(BuildContext context) {
    final hasDoc = pageCount > 0;
    return Material(
      elevation: 2,
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              tooltip: 'Previous page',
              onPressed: hasDoc && page > 0 ? onPrevious : null,
              icon: const Icon(Icons.chevron_left_rounded),
            ),
            TextButton(
              onPressed: hasDoc ? onJump : null,
              child: Text(hasDoc ? 'Page ${page + 1} of $pageCount' : 'Page -'),
            ),
            IconButton(
              tooltip: 'Next page',
              onPressed: hasDoc && page < pageCount - 1 ? onNext : null,
              icon: const Icon(Icons.chevron_right_rounded),
            ),
          ],
        ),
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  const _Placeholder({required this.message});

  final String message;

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
              Icons.folder_open_rounded,
              size: 34,
              color: theme.colorScheme.primary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
