# teigiii_api.api.MeApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1MeDefinedWordsGet**](MeApi.md#v1medefinedwordsget) | **GET** /v1/me/defined-words | 定義済みの言葉一覧（言葉単位 + 状態別件数）
[**v1MeDefinitionsGet**](MeApi.md#v1medefinitionsget) | **GET** /v1/me/definitions | 自分の定義一覧（状態で絞り込み）
[**v1MeDictionaryOverviewGet**](MeApi.md#v1medictionaryoverviewget) | **GET** /v1/me/dictionary/overview | あなたの辞書の概要（各件数 + 最近の定義）
[**v1MeMutesGet**](MeApi.md#v1memutesget) | **GET** /v1/me/mutes | ミュート中のユーザー一覧
[**v1MeSavedWordsGet**](MeApi.md#v1mesavedwordsget) | **GET** /v1/me/saved-words | 保存した言葉の一覧


# **v1MeDefinedWordsGet**
> V1MeDefinedWordsGet200Response v1MeDefinedWordsGet(cursor, limit)

定義済みの言葉一覧（言葉単位 + 状態別件数）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getMeApi();
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1MeDefinedWordsGet(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->v1MeDefinedWordsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1MeDefinedWordsGet200Response**](V1MeDefinedWordsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MeDefinitionsGet**
> V1UsersIdDefinitionsGet200Response v1MeDefinitionsGet(cursor, limit, status)

自分の定義一覧（状態で絞り込み）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getMeApi();
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 
final String status = status_example; // String | 

try {
    final response = api.v1MeDefinitionsGet(cursor, limit, status);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->v1MeDefinitionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]
 **status** | **String**|  | [optional] 

### Return type

[**V1UsersIdDefinitionsGet200Response**](V1UsersIdDefinitionsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MeDictionaryOverviewGet**
> MyDictionaryOverview v1MeDictionaryOverviewGet()

あなたの辞書の概要（各件数 + 最近の定義）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getMeApi();

try {
    final response = api.v1MeDictionaryOverviewGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->v1MeDictionaryOverviewGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MyDictionaryOverview**](MyDictionaryOverview.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MeMutesGet**
> V1UsersIdFollowersGet200Response v1MeMutesGet(cursor, limit)

ミュート中のユーザー一覧

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getMeApi();
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1MeMutesGet(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->v1MeMutesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1UsersIdFollowersGet200Response**](V1UsersIdFollowersGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MeSavedWordsGet**
> V1MeSavedWordsGet200Response v1MeSavedWordsGet(cursor, limit)

保存した言葉の一覧

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getMeApi();
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1MeSavedWordsGet(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling MeApi->v1MeSavedWordsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1MeSavedWordsGet200Response**](V1MeSavedWordsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

