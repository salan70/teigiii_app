import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:teigi_app/core/api/auth_interceptor.dart';

void main() {
  Future<RequestOptions> runInterceptor(AuthInterceptor interceptor) async {
    final options = RequestOptions(path: '/v1/app-config');
    final handler = RequestInterceptorHandler();
    await interceptor.onRequest(options, handler);
    return options;
  }

  test('ID トークンと App Check トークンをヘッダーに付与する', () async {
    final interceptor = AuthInterceptor(
      getIdToken: () async => 'id-token',
      getAppCheckToken: () async => 'app-check-token',
    );

    final options = await runInterceptor(interceptor);

    expect(options.headers['Authorization'], 'Bearer id-token');
    expect(options.headers['X-Firebase-AppCheck'], 'app-check-token');
  });

  test('未サインイン時は Authorization ヘッダーを付与しない', () async {
    final interceptor = AuthInterceptor(
      getIdToken: () async => null,
      getAppCheckToken: () async => 'app-check-token',
    );

    final options = await runInterceptor(interceptor);

    expect(options.headers.containsKey('Authorization'), isFalse);
    expect(options.headers['X-Firebase-AppCheck'], 'app-check-token');
  });

  test('App Check トークンが取得できない場合はヘッダーを付与しない', () async {
    final interceptor = AuthInterceptor(
      getIdToken: () async => 'id-token',
      getAppCheckToken: () async => null,
    );

    final options = await runInterceptor(interceptor);

    expect(options.headers.containsKey('X-Firebase-AppCheck'), isFalse);
  });
}
