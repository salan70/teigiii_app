# teigiii_api.api.TimelineApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1TimelineDiscoverGet**](TimelineApi.md#v1timelinediscoverget) | **GET** /v1/timeline/discover | 見つける（公開定義 + 言葉登録の混在フィード・完全な新着順）
[**v1TimelineFollowingGet**](TimelineApi.md#v1timelinefollowingget) | **GET** /v1/timeline/following | フォロー中（公開定義のみ・完全な新着順）


# **v1TimelineDiscoverGet**
> V1TimelineDiscoverGet200Response v1TimelineDiscoverGet(cursor, limit)

見つける（公開定義 + 言葉登録の混在フィード・完全な新着順）

ミュート中ユーザーの活動は除外する。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getTimelineApi();
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1TimelineDiscoverGet(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TimelineApi->v1TimelineDiscoverGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1TimelineDiscoverGet200Response**](V1TimelineDiscoverGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1TimelineFollowingGet**
> V1UsersIdDefinitionsGet200Response v1TimelineFollowingGet(cursor, limit)

フォロー中（公開定義のみ・完全な新着順）

ミュート中ユーザーの活動は除外する。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getTimelineApi();
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1TimelineFollowingGet(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling TimelineApi->v1TimelineFollowingGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1UsersIdDefinitionsGet200Response**](V1UsersIdDefinitionsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

