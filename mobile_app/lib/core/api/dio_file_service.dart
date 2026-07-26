import 'package:dio/dio.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// 認証ヘッダー付きで画像を取得する [FileService]。
///
/// `GET /v1/avatars/{id}` は Firebase ID トークンと App Check トークンが
/// 必須のため、AuthInterceptor を積んだ dio を経由して取得する。
class DioFileService extends FileService {
  DioFileService(this._dio);

  final Dio _dio;

  @override
  Future<FileServiceResponse> get(
    String url, {
    Map<String, String>? headers,
  }) async {
    final response = await _dio.get<ResponseBody>(
      url,
      options: Options(
        responseType: ResponseType.stream,
        headers: headers,
        // flutter_cache_manager は 304（条件付きリクエストの再検証）や
        // 4xx/5xx を FileServiceResponse として受け取り statusCode で判断する。
        // Dio 既定の 2xx 以外で throw する挙動を無効化する。
        validateStatus: (_) => true,
      ),
    );
    return DioGetResponse(response);
  }
}

/// dio のストリームレスポンスを [FileServiceResponse] に適合させる。
class DioGetResponse implements FileServiceResponse {
  DioGetResponse(this._response);

  final Response<ResponseBody> _response;
  final DateTime _receivedTime = DateTime.now();

  String? _header(String name) => _response.data?.headers[name]?.firstOrNull;

  @override
  Stream<List<int>> get content => _response.data!.stream;

  @override
  int? get contentLength => int.tryParse(_header('content-length') ?? '');

  @override
  int get statusCode => _response.statusCode!;

  @override
  DateTime get validTill {
    // cache-control ヘッダーがない場合は 7 日間キャッシュを有効とする
    var ageDuration = const Duration(days: 7);
    final controlHeader = _header('cache-control');
    if (controlHeader != null) {
      for (final setting in controlHeader.split(',')) {
        final sanitizedSetting = setting.trim().toLowerCase();
        if (sanitizedSetting == 'no-cache') {
          ageDuration = Duration.zero;
        }
        if (sanitizedSetting.startsWith('max-age=')) {
          final validSeconds = int.tryParse(sanitizedSetting.split('=')[1]);
          // max-age=0 は即時失効（Duration.zero）として扱う。
          if (validSeconds != null && validSeconds >= 0) {
            ageDuration = Duration(seconds: validSeconds);
          }
        }
      }
    }
    return _receivedTime.add(ageDuration);
  }

  @override
  String? get eTag => _header('etag');

  @override
  String get fileExtension {
    final contentTypeHeader = _header('content-type');
    if (contentTypeHeader == null) {
      return '';
    }
    final mime = contentTypeHeader.split(';').first.trim().toLowerCase();
    switch (mime) {
      case 'image/jpeg':
        return '.jpg';
      case 'image/png':
        return '.png';
      default:
        return '';
    }
  }
}
