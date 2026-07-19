import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'image_repository.g.dart';

@riverpod
ImageRepository imageRepository(ImageRepositoryRef ref) => ImageRepository();

class ImageRepository {
  ImageRepository();

  /// [imageSource] から画像を取得する（カメラ or アルバム）
  ///
  /// 画像が選択されなかった場合はnullを返す
  Future<XFile?> pickImage(ImageSource imageSource) async {
    return ImagePicker().pickImage(source: imageSource);
  }

  /// 画像を切り抜き、512 x 512 JPEG quality 85 へ正規化する
  ///
  /// 512px 未満の元画像は拡大せず、そのままのサイズで返す
  /// （サーバーは寸法検証を行わない）
  Future<CroppedFile?> cropImage(String imagePath) async {
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: imagePath,
      maxWidth: 512,
      maxHeight: 512,
      // 既定値と一致するが、512 x 512 JPEG quality 85 という仕様の
      // 明示のため指定する。
      // ignore: avoid_redundant_argument_values
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 85,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: '',
          showCropGrid: false,
          hideBottomControls: true,
          // 動作確認した漢字、Androidでは [cropStyle] が動作してない。
          // [CropAspectRatioPreset] に丸がないため、一番差が少ない正方形を指定
          initAspectRatio: CropAspectRatioPreset.square,
        ),
        IOSUiSettings(
          hidesNavigationBar: true,
          aspectRatioPickerButtonHidden: true,
          doneButtonTitle: '次へ',
          cancelButtonTitle: 'キャンセル',
        ),
      ],
      cropStyle: CropStyle.circle,
    );
    return croppedFile;
  }
}
