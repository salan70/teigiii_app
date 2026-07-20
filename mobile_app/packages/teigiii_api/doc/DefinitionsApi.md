# teigiii_api.api.DefinitionsApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1DefinitionsIdDelete**](DefinitionsApi.md#v1definitionsiddelete) | **DELETE** /v1/definitions/{id} | 定義を削除（論理削除・30 日保持）
[**v1DefinitionsIdGet**](DefinitionsApi.md#v1definitionsidget) | **GET** /v1/definitions/{id} | 定義詳細を取得
[**v1DefinitionsIdLikeDelete**](DefinitionsApi.md#v1definitionsidlikedelete) | **DELETE** /v1/definitions/{id}/like | いいね解除
[**v1DefinitionsIdLikePut**](DefinitionsApi.md#v1definitionsidlikeput) | **PUT** /v1/definitions/{id}/like | いいね
[**v1DefinitionsIdLikesGet**](DefinitionsApi.md#v1definitionsidlikesget) | **GET** /v1/definitions/{id}/likes | いいねしたユーザー一覧
[**v1DefinitionsIdPatch**](DefinitionsApi.md#v1definitionsidpatch) | **PATCH** /v1/definitions/{id} | 本文編集・状態遷移・（下書きのみ）言葉の変更
[**v1DefinitionsPost**](DefinitionsApi.md#v1definitionspost) | **POST** /v1/definitions | 定義を作成（draft / public / private のいずれでも）


# **v1DefinitionsIdDelete**
> v1DefinitionsIdDelete(id)

定義を削除（論理削除・30 日保持）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionsApi();
final String id = id_example; // String | 

try {
    api.v1DefinitionsIdDelete(id);
} on DioException catch (e) {
    print('Exception when calling DefinitionsApi->v1DefinitionsIdDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1DefinitionsIdGet**
> DefinitionResponse v1DefinitionsIdGet(id)

定義詳細を取得

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionsApi();
final String id = id_example; // String | 

try {
    final response = api.v1DefinitionsIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefinitionsApi->v1DefinitionsIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**DefinitionResponse**](DefinitionResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1DefinitionsIdLikeDelete**
> v1DefinitionsIdLikeDelete(id)

いいね解除

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionsApi();
final String id = id_example; // String | 

try {
    api.v1DefinitionsIdLikeDelete(id);
} on DioException catch (e) {
    print('Exception when calling DefinitionsApi->v1DefinitionsIdLikeDelete: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1DefinitionsIdLikePut**
> v1DefinitionsIdLikePut(id)

いいね

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionsApi();
final String id = id_example; // String | 

try {
    api.v1DefinitionsIdLikePut(id);
} on DioException catch (e) {
    print('Exception when calling DefinitionsApi->v1DefinitionsIdLikePut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1DefinitionsIdLikesGet**
> V1UsersIdFollowersGet200Response v1DefinitionsIdLikesGet(id, cursor, limit)

いいねしたユーザー一覧

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionsApi();
final String id = id_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1DefinitionsIdLikesGet(id, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefinitionsApi->v1DefinitionsIdLikesGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
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

# **v1DefinitionsIdPatch**
> DefinitionResponse v1DefinitionsIdPatch(id, updateDefinitionRequest)

本文編集・状態遷移・（下書きのみ）言葉の変更

許可される遷移: draft→public/private、public↔private。確定時に finalized_at を設定し、本文編集は finalized_at + 1 時間まで。確定後の wordId 変更・下書きへの巻き戻しは拒否する。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionsApi();
final String id = id_example; // String | 
final UpdateDefinitionRequest updateDefinitionRequest = ; // UpdateDefinitionRequest | 更新内容

try {
    final response = api.v1DefinitionsIdPatch(id, updateDefinitionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefinitionsApi->v1DefinitionsIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **updateDefinitionRequest** | [**UpdateDefinitionRequest**](UpdateDefinitionRequest.md)| 更新内容 | [optional] 

### Return type

[**DefinitionResponse**](DefinitionResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1DefinitionsPost**
> DefinitionResponse v1DefinitionsPost(createDefinitionRequest)

定義を作成（draft / public / private のいずれでも）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionsApi();
final CreateDefinitionRequest createDefinitionRequest = ; // CreateDefinitionRequest | 作成内容

try {
    final response = api.v1DefinitionsPost(createDefinitionRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefinitionsApi->v1DefinitionsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createDefinitionRequest** | [**CreateDefinitionRequest**](CreateDefinitionRequest.md)| 作成内容 | [optional] 

### Return type

[**DefinitionResponse**](DefinitionResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

