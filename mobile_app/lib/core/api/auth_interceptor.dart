import 'package:dio/dio.dart';

typedef TokenProvider = Future<String?> Function();

class AuthInterceptor extends Interceptor {
  AuthInterceptor({required this.getIdToken, required this.getAppCheckToken});

  final TokenProvider getIdToken;
  final TokenProvider getAppCheckToken;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final appCheckToken = await getAppCheckToken();
    if (appCheckToken != null) {
      options.headers['X-Firebase-AppCheck'] = appCheckToken;
    }

    final idToken = await getIdToken();
    if (idToken != null) {
      options.headers['Authorization'] = 'Bearer $idToken';
    }

    handler.next(options);
  }
}
