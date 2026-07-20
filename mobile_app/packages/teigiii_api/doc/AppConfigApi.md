# teigiii_api.api.AppConfigApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1AppConfigGet**](AppConfigApi.md#v1appconfigget) | **GET** /v1/app-config | アプリ設定（強制アップデート・メンテナンス）を取得


# **v1AppConfigGet**
> AppConfigResponse v1AppConfigGet()

アプリ設定（強制アップデート・メンテナンス）を取得

起動時ポーリングで呼び出す。Firebase ID トークン不要（App Check は必須）。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getAppConfigApi();

try {
    final response = api.v1AppConfigGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling AppConfigApi->v1AppConfigGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AppConfigResponse**](AppConfigResponse.md)

### Authorization

[appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

