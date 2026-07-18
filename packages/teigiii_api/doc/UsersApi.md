# teigiii_api.api.UsersApi

## Load the API package
```dart
import 'package:teigiii_api/api.dart';
```

All URIs are relative to *http://localhost*

Method | HTTP request | Description
------------- | ------------- | -------------
[**v1AvatarsIdGet**](UsersApi.md#v1avatarsidget) | **GET** /v1/avatars/{id} | 認証付きアバター画像を取得
[**v1UsersIdDefinitionsGet**](UsersApi.md#v1usersiddefinitionsget) | **GET** /v1/users/{id}/definitions | ユーザーの定義一覧
[**v1UsersIdDictionaryGet**](UsersApi.md#v1usersiddictionaryget) | **GET** /v1/users/{id}/dictionary | 公開辞書を取得（言葉単位）
[**v1UsersIdFollowDelete**](UsersApi.md#v1usersidfollowdelete) | **DELETE** /v1/users/{id}/follow | フォロー解除
[**v1UsersIdFollowPut**](UsersApi.md#v1usersidfollowput) | **PUT** /v1/users/{id}/follow | フォロー
[**v1UsersIdFollowersGet**](UsersApi.md#v1usersidfollowersget) | **GET** /v1/users/{id}/followers | フォロワー一覧
[**v1UsersIdFollowingGet**](UsersApi.md#v1usersidfollowingget) | **GET** /v1/users/{id}/following | フォロー中一覧
[**v1UsersIdGet**](UsersApi.md#v1usersidget) | **GET** /v1/users/{id} | 公開プロフィールを取得
[**v1UsersIdLikedDefinitionsGet**](UsersApi.md#v1usersidlikeddefinitionsget) | **GET** /v1/users/{id}/liked-definitions | ユーザーがいいねした定義の一覧（いいね日時の降順）
[**v1UsersIdMuteDelete**](UsersApi.md#v1usersidmutedelete) | **DELETE** /v1/users/{id}/mute | ミュート解除
[**v1UsersIdMutePut**](UsersApi.md#v1usersidmuteput) | **PUT** /v1/users/{id}/mute | ミュート
[**v1UsersMeAvatarDelete**](UsersApi.md#v1usersmeavatardelete) | **DELETE** /v1/users/me/avatar | アバター画像を削除
[**v1UsersMeAvatarPut**](UsersApi.md#v1usersmeavatarput) | **PUT** /v1/users/me/avatar | アバター画像をアップロード
[**v1UsersMeDelete**](UsersApi.md#v1usersmedelete) | **DELETE** /v1/users/me | アカウント削除（論理削除・30 日保持）
[**v1UsersMeGet**](UsersApi.md#v1usersmeget) | **GET** /v1/users/me | 自分の情報を取得
[**v1UsersMePatch**](UsersApi.md#v1usersmepatch) | **PATCH** /v1/users/me | プロフィール編集・バージョン情報更新
[**v1UsersPost**](UsersApi.md#v1userspost) | **POST** /v1/users | 初回登録


# **v1AvatarsIdGet**
> Uint8List v1AvatarsIdGet(id)

認証付きアバター画像を取得

非公開 R2 bucket の画像を認証済み利用者へ配信する。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 

try {
    final response = api.v1AvatarsIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1AvatarsIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**Uint8List**](Uint8List.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: image/jpeg, image/png, application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersIdDefinitionsGet**
> V1UsersIdDefinitionsGet200Response v1UsersIdDefinitionsGet(id, cursor, limit, wordId, subGroup, sort)

ユーザーの定義一覧

対象が本人の場合は非公開定義を含む（下書きは /me/definitions）。他者の場合は公開定義のみ。wordId・subGroup で絞り込み可能。sort=reading は言葉のよみ昇順（旧 UI の頭文字別辞書のパリティ）。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 
final String wordId = wordId_example; // String | 
final String subGroup = subGroup_example; // String | 
final String sort = sort_example; // String | 

try {
    final response = api.v1UsersIdDefinitionsGet(id, cursor, limit, wordId, subGroup, sort);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdDefinitionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]
 **wordId** | **String**|  | [optional] 
 **subGroup** | **String**|  | [optional] 
 **sort** | **String**|  | [optional] [default to 'newest']

### Return type

[**V1UsersIdDefinitionsGet200Response**](V1UsersIdDefinitionsGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersIdDictionaryGet**
> V1UsersIdDictionaryGet200Response v1UsersIdDictionaryGet(id, cursor, limit)

公開辞書を取得（言葉単位）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1UsersIdDictionaryGet(id, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdDictionaryGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
 **cursor** | **String**|  | [optional] 
 **limit** | **int**|  | [optional] [default to 20]

### Return type

[**V1UsersIdDictionaryGet200Response**](V1UsersIdDictionaryGet200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersIdFollowDelete**
> v1UsersIdFollowDelete(id)

フォロー解除

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 

try {
    api.v1UsersIdFollowDelete(id);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdFollowDelete: $e\n');
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

# **v1UsersIdFollowPut**
> v1UsersIdFollowPut(id)

フォロー

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 

try {
    api.v1UsersIdFollowPut(id);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdFollowPut: $e\n');
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

# **v1UsersIdFollowersGet**
> V1UsersIdFollowersGet200Response v1UsersIdFollowersGet(id, cursor, limit)

フォロワー一覧

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1UsersIdFollowersGet(id, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdFollowersGet: $e\n');
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

# **v1UsersIdFollowingGet**
> V1UsersIdFollowersGet200Response v1UsersIdFollowingGet(id, cursor, limit)

フォロー中一覧

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1UsersIdFollowingGet(id, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdFollowingGet: $e\n');
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

# **v1UsersIdGet**
> UserResponse v1UsersIdGet(id)

公開プロフィールを取得

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 

try {
    final response = api.v1UsersIdGet(id);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**UserResponse**](UserResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersIdLikedDefinitionsGet**
> V1UsersIdDefinitionsGet200Response v1UsersIdLikedDefinitionsGet(id, cursor, limit)

ユーザーがいいねした定義の一覧（いいね日時の降順）

旧 UI のプロフィール「いいね」タブのパリティ用。他者の公開定義に加え、閲覧者自身の定義は非公開でも含める（旧実装と同じ可視性）。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 
final String cursor = cursor_example; // String | 
final int limit = 56; // int | 

try {
    final response = api.v1UsersIdLikedDefinitionsGet(id, cursor, limit);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdLikedDefinitionsGet: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 
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

# **v1UsersIdMuteDelete**
> v1UsersIdMuteDelete(id)

ミュート解除

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 

try {
    api.v1UsersIdMuteDelete(id);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdMuteDelete: $e\n');
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

# **v1UsersIdMutePut**
> v1UsersIdMutePut(id)

ミュート

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final String id = id_example; // String | 

try {
    api.v1UsersIdMutePut(id);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersIdMutePut: $e\n');
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

# **v1UsersMeAvatarDelete**
> v1UsersMeAvatarDelete()

アバター画像を削除

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();

try {
    api.v1UsersMeAvatarDelete();
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersMeAvatarDelete: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersMeAvatarPut**
> V1UsersMeAvatarPut200Response v1UsersMeAvatarPut(body)

アバター画像をアップロード

バイナリを直接送信し、Workers 経由で R2 に保存する。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final MultipartFile body = BINARY_DATA_HERE; // MultipartFile | 画像バイナリ

try {
    final response = api.v1UsersMeAvatarPut(body);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersMeAvatarPut: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **body** | **MultipartFile**| 画像バイナリ | [optional] 

### Return type

[**V1UsersMeAvatarPut200Response**](V1UsersMeAvatarPut200Response.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: image/jpeg, image/png
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersMeDelete**
> v1UsersMeDelete()

アカウント削除（論理削除・30 日保持）

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();

try {
    api.v1UsersMeDelete();
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersMeDelete: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersMeGet**
> MeResponse v1UsersMeGet()

自分の情報を取得

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();

try {
    final response = api.v1UsersMeGet();
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersMeGet: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MeResponse**](MeResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersMePatch**
> MeResponse v1UsersMePatch(updateMeRequest)

プロフィール編集・バージョン情報更新

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final UpdateMeRequest updateMeRequest = ; // UpdateMeRequest | 更新内容

try {
    final response = api.v1UsersMePatch(updateMeRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersMePatch: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **updateMeRequest** | [**UpdateMeRequest**](UpdateMeRequest.md)| 更新内容 | [optional] 

### Return type

[**MeResponse**](MeResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **v1UsersPost**
> MeResponse v1UsersPost(createUserRequest)

初回登録

匿名認証直後に呼び出す。publicId はサーバーで採番する。

### Example
```dart
import 'package:teigiii_api/api.dart';
// TODO Configure API key authorization: appCheck
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKey = 'YOUR_API_KEY';
// uncomment below to setup prefix (e.g. Bearer) for API key, if needed
//defaultApiClient.getAuthentication<ApiKeyAuth>('appCheck').apiKeyPrefix = 'Bearer';

final api = TeigiiiApi().getUsersApi();
final CreateUserRequest createUserRequest = ; // CreateUserRequest | 登録内容

try {
    final response = api.v1UsersPost(createUserRequest);
    print(response);
} on DioException catch (e) {
    print('Exception when calling UsersApi->v1UsersPost: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **createUserRequest** | [**CreateUserRequest**](CreateUserRequest.md)| 登録内容 | [optional] 

### Return type

[**MeResponse**](MeResponse.md)

### Authorization

[firebaseIdToken](../README.md#firebaseIdToken), [appCheck](../README.md#appCheck)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

