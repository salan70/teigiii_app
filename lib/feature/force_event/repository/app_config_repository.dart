import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../domain/app_config.dart';

part 'app_config_repository.g.dart';

@Riverpod(keepAlive: true)
AppConfigRepository appConfigRepository(AppConfigRepositoryRef ref) =>
    AppConfigRepository(ref.watch(teigiiiApiProvider).getAppConfigApi());

class AppConfigRepository {
  AppConfigRepository(this._appConfigApi);

  final AppConfigApi _appConfigApi;

  Future<AppConfig> fetchAppConfig() async {
    try {
      final response = await _appConfigApi.v1AppConfigGet();
      final appConfig = response.data!;
      return AppConfig(
        minAppVersionIos: appConfig.minAppVersionIos,
        minAppVersionAndroid: appConfig.minAppVersionAndroid,
        inMaintenance: appConfig.inMaintenance,
        maintenanceScheduledEndTime: appConfig.maintenanceScheduledEndTime,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
