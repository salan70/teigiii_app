# teigiii_api.api.SearchApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1SearchUsersGet**](SearchApi.md#v1searchusersget) | **GET** /v1/search/users | ユーザーを検索（表示名・ユーザー ID の部分一致）
[**v1SearchWordsGet**](SearchApi.md#v1searchwordsget) | **GET** /v1/search/words | 言葉を検索（表記・よみの部分一致）


# **v1SearchUsersGet**
> V1UsersIdFollowersGet200Response v1SearchUsersGet(q, cursor, limit)

ユーザーを検索（表示名・ユーザー ID の部分一致）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getSearchApi();
final String q = q_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1SearchUsersGet(q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->v1SearchUsersGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | 
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

# **v1SearchWordsGet**
> V1WordsGet200Response v1SearchWordsGet(q, cursor, limit)

言葉を検索（表記・よみの部分一致）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getSearchApi();
final String q = q_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1SearchWordsGet(q, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling SearchApi->v1SearchWordsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **q** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1WordsGet200Response**](V1WordsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

