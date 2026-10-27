import 'dart:async';
import 'dart:io' as io;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'asset_downloader.dart';

/// Native (Android, and any `dart:io` platform) implementation of the tiny set
/// of primitives [AssetDownloader] needs. Reachable only through the
/// conditional import in asset_downloader.dart: it uses dart:io and
/// path_provider, neither of which compile for the web.

/// App-owned folder every offline file lands in. Created if missing.
Future<String> resolveBaseDir() async {
  final documents = await getApplicationDocumentsDirectory();
  final dir = io.Directory(p.join(documents.path, 'masti_resources'));
  await dir.create(recursive: true);
  return dir.path;
}

bool get canStoreFiles => true;

Future<ByteResponse> openUrlStream(String url) async {
  final client = io.HttpClient();
  io.HttpClientResponse response;
  try {
    final request = await client.getUrl(Uri.parse(url));
    response = await request.close();
  } on Object catch (error) {
    client.close(force: true);
    throw DownloadFailure('The file could not be reached: $error');
  }

  if (response.statusCode != io.HttpStatus.ok) {
    client.close(force: true);
    throw DownloadFailure(
      'The server replied with status code ${response.statusCode}.',
    );
  }

  final advertised = response.contentLength;
  final controller = StreamController<List<int>>();
  response.listen(
    controller.add,
    onError: (Object error, StackTrace stack) {
      controller.addError(error, stack);
      client.close(force: true);
    },
    onDone: () {
      controller.close();
      client.close();
    },
    cancelOnError: true,
  );
  return ByteResponse(
    contentLength: advertised >= 0 ? advertised : null,
    bytes: controller.stream,
  );
}

class _IoSink implements LocalSink {
  _IoSink(this._sink);

  final io.IOSink _sink;

  @override
  void add(List<int> chunk) => _sink.add(chunk);

  @override
  Future<void> close() async {
    await _sink.flush();
    await _sink.close();
  }
}

Future<LocalSink> openSink(String absolutePath) async {
  final file = io.File(absolutePath);
  await file.parent.create(recursive: true);
  // Write (truncate), not append: a fresh attempt restarts the file.
  return _IoSink(file.openWrite());
}

Future<void> deleteFile(String absolutePath) async {
  final file = io.File(absolutePath);
  if (await file.exists()) {
    await file.delete();
  }
}

Future<List<int>> readHead(String absolutePath, int count) async {
  final file = io.File(absolutePath);
  if (!await file.exists()) return const <int>[];
  final length = await file.length();
  if (length == 0) return const <int>[];
  final random = await file.open();
  try {
    return await random.read(length < count ? length : count);
  } finally {
    await random.close();
  }
}
