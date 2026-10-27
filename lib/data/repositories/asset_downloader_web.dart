import 'asset_downloader.dart';

/// Web implementation of the primitives [AssetDownloader] needs, reachable only
/// through the conditional import in asset_downloader.dart. The browser is the
/// one that saves files on the web, so there is no app-owned folder to write
/// into and none of these paths are ever taken in a web build. Each one is
/// honest about that instead of faking progress.

bool get canStoreFiles => false;

Future<String> resolveBaseDir() async {
  throw const DownloadFailure(
    'The web build cannot store files inside the app. Your browser will '
    'download the file instead.',
  );
}

Future<ByteResponse> openUrlStream(String url) async {
  throw const DownloadFailure(
    'Downloads on the web go through the browser, not the app.',
  );
}

Future<LocalSink> openSink(String absolutePath) async {
  throw const DownloadFailure(
    'The web build cannot write files into the app folder.',
  );
}

Future<void> deleteFile(String absolutePath) async {
  // Nothing was ever written here on the web, so there is nothing to delete.
}

Future<List<int>> readHead(String absolutePath, int count) async =>
    const <int>[];
