# teigiii_api.api.WordsApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1WordsGet**](WordsApi.md#v1wordsget) | **GET** /v1/words | みんなの辞書の言葉一覧（読み順）
[**v1WordsIdDefinitionsGet**](WordsApi.md#v1wordsiddefinitionsget) | **GET** /v1/words/{id}/definitions | 言葉ページの定義一覧
[**v1WordsIdGet**](WordsApi.md#v1wordsidget) | **GET** /v1/words/{id} | 言葉ページのヘッダ情報を取得
[**v1WordsIdPatch**](WordsApi.md#v1wordsidpatch) | **PATCH** /v1/words/{id} | 作成者修正（表記・よみ）
[**v1WordsIdSaveDelete**](WordsApi.md#v1wordsidsavedelete) | **DELETE** /v1/words/{id}/save | 言葉の保存を解除
[**v1WordsIdSavePut**](WordsApi.md#v1wordsidsaveput) | **PUT** /v1/words/{id}/save | 言葉を保存
[**v1WordsPost**](WordsApi.md#v1wordspost) | **POST** /v1/words | 言葉を明示登録する


# **v1WordsGet**
> V1WordsGet200Response v1WordsGet(cursor, limit, subGroup, filter, q)

みんなの辞書の言葉一覧（読み順）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getWordsApi();
final String cursor = cursor_example; // String |
final int limit = 56; // int |
final String subGroup = subGroup_example; // String |
final String filter = filter_example; // String |
final String q = q_example; // String |

try {
    final response = api.v1WordsGet(cursor, limit, subGroup, filter, q);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WordsApi->v1WordsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 20]
 **subGroup** | **String**|  | [optional]
 **filter** | **String**|  | [optional] [default to 'all']
 **q** | **String**|  | [optional]

### Return type

[**V1WordsGet200Response**](V1WordsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1WordsIdDefinitionsGet**
> V1UsersIdDefinitionsGet200Response v1WordsIdDefinitionsGet(id, cursor, limit, scope, sort)

言葉ページの定義一覧

scope=mine は自分の定義（下書き含む）、scope=others は他者の公開定義のみ、scope=all は自分 + 他者の公開定義の混在（旧 UI の言葉トップのパリティ）。sort=reactions はいいね数順。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getWordsApi();
final String id = id_example; // String |
final String cursor = cursor_example; // String |
final int limit = 56; // int |
final String scope = scope_example; // String |
final String sort = sort_example; // String |

try {
    final response = api.v1WordsIdDefinitionsGet(id, cursor, limit, scope, sort);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WordsApi->v1WordsIdDefinitionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **cursor** | **String**|  | [optional]
 **limit** | **int**|  | [optional] [default to 20]
 **scope** | **String**|  | [optional] [default to 'all']
 **sort** | **String**|  | [optional] [default to 'newest']

### Return type

[**V1UsersIdDefinitionsGet200Response**](V1UsersIdDefinitionsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1WordsIdGet**
> WordResponse v1WordsIdGet(id)

言葉ページのヘッダ情報を取得

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getWordsApi();
final String id = id_example; // String |

try {
    final response = api.v1WordsIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WordsApi->v1WordsIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |

### Return type

[**WordResponse**](WordResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1WordsIdPatch**
> WordResponse v1WordsIdPatch(id, updateWordRequest)

作成者修正（表記・よみ）

作成後 1 時間以内かつ他ユーザーによる操作（定義投稿・保存）がない場合のみ、登録者本人が修正できる。条件はサーバーで検証する。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getWordsApi();
final String id = id_example; // String |
final UpdateWordRequest updateWordRequest = ; // UpdateWordRequest | 修正内容

try {
    final response = api.v1WordsIdPatch(id, updateWordRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WordsApi->v1WordsIdPatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  |
 **updateWordRequest** | [**UpdateWordRequest**](UpdateWordRequest.md)| 修正内容 | [optional]

### Return type

[**WordResponse**](WordResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1WordsIdSaveDelete**
> v1WordsIdSaveDelete(id)

言葉の保存を解除

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getWordsApi();
final String id = id_example; // String |

try {
    api.v1WordsIdSaveDelete(id);
} on DioException catch (e) {
    print('Exception when calling WordsApi->v1WordsIdSaveDelete: $e\n');
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

# **v1WordsIdSavePut**
> v1WordsIdSavePut(id)

言葉を保存

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getWordsApi();
final String id = id_example; // String |

try {
    api.v1WordsIdSavePut(id);
} on DioException catch (e) {
    print('Exception when calling WordsApi->v1WordsIdSavePut: $e\n');
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

# **v1WordsPost**
> WordResponse v1WordsPost(createWordRequest)

言葉を明示登録する

表記はサーバーで前後トリム + NFC 正規化してから完全一致で解決する。新規作成は 201、既存言葉への明示登録・公開昇格は 200。読みが異なっても既存の読みを採用し、重複する言葉は作らない。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getWordsApi();
final CreateWordRequest createWordRequest = ; // CreateWordRequest | 登録内容

try {
    final response = api.v1WordsPost(createWordRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling WordsApi->v1WordsPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createWordRequest** | [**CreateWordRequest**](CreateWordRequest.md)| 登録内容 | [optional]

### Return type

[**WordResponse**](WordResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

