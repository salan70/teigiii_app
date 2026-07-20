# teigiii_api.api.DefinitionDraftsApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1DefinitionDraftsIdDelete**](DefinitionDraftsApi.md#v1definitiondraftsiddelete) | **DELETE** /v1/definition-drafts/{id} | 本人の Draft を冪等に削除
[**v1DefinitionDraftsIdFinalizePost**](DefinitionDraftsApi.md#v1definitiondraftsidfinalizepost) | **POST** /v1/definition-drafts/{id}/finalize | Draft を定義として冪等に確定
[**v1DefinitionDraftsIdGet**](DefinitionDraftsApi.md#v1definitiondraftsidget) | **GET** /v1/definition-drafts/{id} | 本人の定義 Draft を取得
[**v1DefinitionDraftsIdPut**](DefinitionDraftsApi.md#v1definitiondraftsidput) | **PUT** /v1/definition-drafts/{id} | 定義 Draft を冪等に保存
[**v1MeDefinitionDraftsGet**](DefinitionDraftsApi.md#v1medefinitiondraftsget) | **GET** /v1/me/definition-drafts | 本人の未確定 Draft 一覧（更新日時降順）


# **v1DefinitionDraftsIdDelete**
> v1DefinitionDraftsIdDelete(id)

本人の Draft を冪等に削除

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionDraftsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    api.v1DefinitionDraftsIdDelete(id);
} on DioException catch (e) {
    print('Exception when calling DefinitionDraftsApi->v1DefinitionDraftsIdDelete: $e\n');
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

# **v1DefinitionDraftsIdFinalizePost**
> DefinitionResponse v1DefinitionDraftsIdFinalizePost(id, finalizeDefinitionDraftRequest)

Draft を定義として冪等に確定

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionDraftsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final FinalizeDefinitionDraftRequest finalizeDefinitionDraftRequest = ; // FinalizeDefinitionDraftRequest | 既存語のよみ不一致確認

try {
    final response = api.v1DefinitionDraftsIdFinalizePost(id, finalizeDefinitionDraftRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefinitionDraftsApi->v1DefinitionDraftsIdFinalizePost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **finalizeDefinitionDraftRequest** | [**FinalizeDefinitionDraftRequest**](FinalizeDefinitionDraftRequest.md)| 既存語のよみ不一致確認 | [optional]

### Return type

[**DefinitionResponse**](DefinitionResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1DefinitionDraftsIdGet**
> DefinitionDraftResponse v1DefinitionDraftsIdGet(id)

本人の定義 Draft を取得

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionDraftsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |

try {
    final response = api.v1DefinitionDraftsIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefinitionDraftsApi->v1DefinitionDraftsIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**DefinitionDraftResponse**](DefinitionDraftResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1DefinitionDraftsIdPut**
> DefinitionDraftResponse v1DefinitionDraftsIdPut(id, putDefinitionDraftRequest)

定義 Draft を冪等に保存

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionDraftsApi();
final String id = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String |
final PutDefinitionDraftRequest putDefinitionDraftRequest = ; // PutDefinitionDraftRequest | Draft の入力内容

try {
    final response = api.v1DefinitionDraftsIdPut(id, putDefinitionDraftRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefinitionDraftsApi->v1DefinitionDraftsIdPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **putDefinitionDraftRequest** | [**PutDefinitionDraftRequest**](PutDefinitionDraftRequest.md)| Draft の入力内容 | [optional]

### Return type

[**DefinitionDraftResponse**](DefinitionDraftResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1MeDefinitionDraftsGet**
> V1MeDefinitionDraftsGet200Response v1MeDefinitionDraftsGet(cursor, limit)

本人の未確定 Draft 一覧（更新日時降順）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getDefinitionDraftsApi();
final String cursor = cursor_example; // String |
final int limit = 56; // int |

try {
    final response = api.v1MeDefinitionDraftsGet(cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling DefinitionDraftsApi->v1MeDefinitionDraftsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1MeDefinitionDraftsGet200Response**](V1MeDefinitionDraftsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)
