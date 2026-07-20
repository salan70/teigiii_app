/// アバター未設定（avatarUrl が null）のユーザーに表示するデフォルトアイコン。
///
/// 旧実装は登録時にランダムな URL を保存していたが、
/// 新 API はアバター未設定を null で表現するため、表示時に決定的に選択する。
const defaultAvatarAssetPaths = [
  'assets/images/default_icon/ghost_writer.png',
  'assets/images/default_icon/animal_chara_radio_penguin.png',
  'assets/images/default_icon/animal_chara_mogura_hakase.png',
];

/// [userId] から決定的にデフォルトアイコンの asset パスを返す。
///
/// 同じユーザーには常に同じアイコンが表示される。
String defaultAvatarAssetPath(String userId) {
  final hash = userId.codeUnits.fold<int>(0, (sum, unit) => sum + unit);
  return defaultAvatarAssetPaths[hash % defaultAvatarAssetPaths.length];
}
