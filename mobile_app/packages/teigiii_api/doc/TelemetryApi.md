# teigiii_api.api.TelemetryApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1TelemetryFramesPost**](TelemetryApi.md#v1telemetryframespost) | **POST** /v1/telemetry/frames | フレーム計測の集計を送信


# **v1TelemetryFramesPost**
> FrameStatsAcceptedResponse v1TelemetryFramesPost(frameStatsRequest)

フレーム計測の集計を送信

セッション単位で画面ごとに集計したフレーム統計を受け取る。Firebase ID トークン不要（App Check は必須）。app_config.perfTelemetryEnabled が false のときは 1 行も保存せず accepted=0 / disabled=true を返す。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getTelemetryApi();
final FrameStatsRequest frameStatsRequest = ; // FrameStatsRequest | セッション単位のフレーム計測集計

try {
    final response = api.v1TelemetryFramesPost(frameStatsRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TelemetryApi->v1TelemetryFramesPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **frameStatsRequest** | [**FrameStatsRequest**](FrameStatsRequest.md)| セッション単位のフレーム計測集計 | [optional] 

### Return type

[**FrameStatsAcceptedResponse**](FrameStatsAcceptedResponse.md)

### Authorization

[appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

