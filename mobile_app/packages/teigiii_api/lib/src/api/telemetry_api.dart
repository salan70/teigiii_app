//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:teigiii_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:teigiii_api/src/model/error_response.dart';
import 'package:teigiii_api/src/model/frame_stats_accepted_response.dart';
import 'package:teigiii_api/src/model/frame_stats_request.dart';

class TelemetryApi {
  final Dio _dio;

  const TelemetryApi(this._dio);

  /// フレーム計測の集計を送信
  /// セッション単位で画面ごとに集計したフレーム統計を受け取る。Firebase ID トークン不要（App Check は必須）。app_config.perfTelemetryEnabled が false のときは 1 行も保存せず accepted&#x3D;0 / disabled&#x3D;true を返す。
  ///
  /// Parameters:
  /// * [frameStatsRequest] - セッション単位のフレーム計測集計
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [FrameStatsAcceptedResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<FrameStatsAcceptedResponse>> v1TelemetryFramesPost({
    FrameStatsRequest? frameStatsRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/telemetry/frames';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {
            'type': 'apiKey',
            'name': 'appCheck',
            'keyName': 'X-Firebase-AppCheck',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      contentType: 'application/json',
      validateStatus: validateStatus,
    );

    dynamic _bodyData;

    try {
      _bodyData = jsonEncode(frameStatsRequest);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _options.compose(_dio.options, _path),
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    final _response = await _dio.request<Object>(
      _path,
      data: _bodyData,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    FrameStatsAcceptedResponse? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<FrameStatsAcceptedResponse, FrameStatsAcceptedResponse>(
              rawData,
              'FrameStatsAcceptedResponse',
              growable: true,
            );
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<FrameStatsAcceptedResponse>(
      data: _responseData,
      headers: _response.headers,
      isRedirect: _response.isRedirect,
      requestOptions: _response.requestOptions,
      redirects: _response.redirects,
      statusCode: _response.statusCode,
      statusMessage: _response.statusMessage,
      extra: _response.extra,
    );
  }
}
