import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../common_provider/firebase_providers.dart';
import 'auth_interceptor.dart';

part 'api_providers.g.dart';

/// Workers API の base URL。dart_defines/{dev,prod}.json から注入される。
const apiBaseUrl = String.fromEnvironment('apiBaseUrl');

@Riverpod(keepAlive: true)
Dio apiDio(ApiDioRef ref) {
  final dio = Dio(
    BaseOptions(
      // dart-define 未指定時の既定値 '' が BaseOptions の既定値と一致するため
      // analyzer は冗長と判定するが、実行時は dart_defines の値が入る。
      // ignore: avoid_redundant_argument_values
      baseUrl: apiBaseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );
  dio.interceptors.add(
    AuthInterceptor(
      getIdToken: () async =>
          ref.read(firebaseAuthProvider).currentUser?.getIdToken(),
      getAppCheckToken: () => ref.read(firebaseAppCheckProvider).getToken(),
    ),
  );
  return dio;
}

@Riverpod(keepAlive: true)
TeigiiiApi teigiiiApi(TeigiiiApiRef ref) =>
    TeigiiiApi(dio: ref.watch(apiDioProvider), interceptors: const []);
