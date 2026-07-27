import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:teigi_app/core/api/api_exception.dart';
import 'package:teigi_app/feature/force_event/repository/app_config_repository.dart';
import 'package:teigiii_api/teigiii_api.dart';

import 'app_config_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AppConfigApi>()])
void main() {
  final mockAppConfigApi = MockAppConfigApi();
  final repository = AppConfigRepository(mockAppConfigApi);

  tearDown(() => reset(mockAppConfigApi));

  group('fetchAppConfig', () {
    test('AppConfigResponse を AppConfig に変換して返す', () async {
      // * Arrange
      final scheduledEndTime = DateTime.utc(2026, 7, 20, 12, 30);
      final updatedAt = DateTime.utc(2026, 7, 19, 5);
      when(mockAppConfigApi.v1AppConfigGet()).thenAnswer(
        (_) async => Response(
          data: AppConfigResponse(
            minAppVersionIos: '2.0.0',
            minAppVersionAndroid: '2.1.0',
            inMaintenance: true,
            maintenanceScheduledEndTime: scheduledEndTime,
            perfTelemetryEnabled: false,
            updatedAt: updatedAt,
          ),
          requestOptions: RequestOptions(path: '/v1/app-config'),
        ),
      );

      // * Act
      final appConfig = await repository.fetchAppConfig();

      // * Assert
      expect(appConfig.minAppVersionIos, '2.0.0');
      expect(appConfig.perfTelemetryEnabled, isFalse);
      expect(appConfig.minAppVersionAndroid, '2.1.0');
      expect(appConfig.inMaintenance, isTrue);
      expect(appConfig.maintenanceScheduledEndTime, scheduledEndTime);
      verify(mockAppConfigApi.v1AppConfigGet()).called(1);
    });

    test('API が失敗した場合 ApiException を投げる', () async {
      // * Arrange
      final requestOptions = RequestOptions(path: '/v1/app-config');
      when(mockAppConfigApi.v1AppConfigGet()).thenThrow(
        DioException(
          requestOptions: requestOptions,
          response: Response(
            statusCode: 500,
            data: {
              'error': {
                'code': 'app_config_unavailable',
                'message': 'App config unavailable',
              },
            },
            requestOptions: requestOptions,
          ),
        ),
      );

      // * Act & Assert
      expect(repository.fetchAppConfig, throwsA(isA<ApiException>()));
    });
  });
}
