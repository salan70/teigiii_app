import 'package:flutter_dotenv/flutter_dotenv.dart';

/// CI の空 `.env` プレースホルダでも起動を継続する。
///
/// flutter_dotenv は空ファイルで [EmptyEnvFileError] を投げる。
/// Web preview / analyze 用では AdMob ID は不要なため、空 map で初期化して先へ進む。
Future<void> loadAppDotEnv({
  Future<void> Function()? load,
  void Function()? initializeEmpty,
}) async {
  try {
    await (load ?? () => dotenv.load())();
  } catch (error) {
    // EmptyEnvFileError は Error サブクラス。パッケージの空ファイル信号だけ握りつぶす。
    if (error is! EmptyEnvFileError) {
      rethrow;
    }
    (initializeEmpty ?? () => dotenv.testLoad())();
  }
}
