//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'dart:async';

// ignore: unused_import
import 'dart:convert';
import 'package:teigiii_api/src/deserialize.dart';
import 'package:dio/dio.dart';

import 'package:teigiii_api/src/model/create_word_request.dart';
import 'package:teigiii_api/src/model/create_word_response.dart';
import 'package:teigiii_api/src/model/error_response.dart';
import 'package:teigiii_api/src/model/update_word_request.dart';
import 'package:teigiii_api/src/model/v1_users_id_definitions_get200_response.dart';
import 'package:teigiii_api/src/model/v1_words_get200_response.dart';
import 'package:teigiii_api/src/model/word_conflict_response.dart';
import 'package:teigiii_api/src/model/word_lookup_response.dart';
import 'package:teigiii_api/src/model/word_response.dart';

class WordsApi {
  final Dio _dio;

  const WordsApi(this._dio);

  /// みんなの辞書の言葉一覧（読み順）
  ///
  ///
  /// Parameters:
  /// * [cursor]
  /// * [limit]
  /// * [subGroup]
  /// * [filter]
  /// * [q]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [V1WordsGet200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<V1WordsGet200Response>> v1WordsGet({
    String? cursor,
    int? limit = 20,
    String? subGroup,
    String? filter = 'all',
    String? q,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/words';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'firebaseIdToken'},
          {
            'type': 'apiKey',
            'name': 'appCheck',
            'keyName': 'X-Firebase-AppCheck',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (cursor != null) r'cursor': cursor,
      if (limit != null) r'limit': limit,
      if (subGroup != null) r'subGroup': subGroup,
      if (filter != null) r'filter': filter,
      if (q != null) r'q': q,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    V1WordsGet200Response? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<V1WordsGet200Response, V1WordsGet200Response>(
              rawData,
              'V1WordsGet200Response',
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

    return Response<V1WordsGet200Response>(
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

  /// 言葉ページの定義一覧
  /// scope&#x3D;mine は自分の定義、scope&#x3D;others は他者の公開定義のみ、scope&#x3D;all は自分 + 他者の公開定義の混在（旧 UI の言葉トップのパリティ）。sort&#x3D;reactions はいいね数順。
  ///
  /// Parameters:
  /// * [id]
  /// * [cursor]
  /// * [limit]
  /// * [scope]
  /// * [sort]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [V1UsersIdDefinitionsGet200Response] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<V1UsersIdDefinitionsGet200Response>> v1WordsIdDefinitionsGet({
    required String id,
    String? cursor,
    int? limit = 20,
    String? scope = 'all',
    String? sort = 'newest',
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/words/{id}/definitions'.replaceAll(
      '{'
      r'id'
      '}',
      id.toString(),
    );
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'firebaseIdToken'},
          {
            'type': 'apiKey',
            'name': 'appCheck',
            'keyName': 'X-Firebase-AppCheck',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      if (cursor != null) r'cursor': cursor,
      if (limit != null) r'limit': limit,
      if (scope != null) r'scope': scope,
      if (sort != null) r'sort': sort,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    V1UsersIdDefinitionsGet200Response? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<
              V1UsersIdDefinitionsGet200Response,
              V1UsersIdDefinitionsGet200Response
            >(rawData, 'V1UsersIdDefinitionsGet200Response', growable: true);
    } catch (error, stackTrace) {
      throw DioException(
        requestOptions: _response.requestOptions,
        response: _response,
        type: DioExceptionType.unknown,
        error: error,
        stackTrace: stackTrace,
      );
    }

    return Response<V1UsersIdDefinitionsGet200Response>(
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

  /// 言葉ページのヘッダ情報を取得
  ///
  ///
  /// Parameters:
  /// * [id]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [WordResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<WordResponse>> v1WordsIdGet({
    required String id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/words/{id}'.replaceAll(
      '{'
      r'id'
      '}',
      id.toString(),
    );
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'firebaseIdToken'},
          {
            'type': 'apiKey',
            'name': 'appCheck',
            'keyName': 'X-Firebase-AppCheck',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    WordResponse? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<WordResponse, WordResponse>(
              rawData,
              'WordResponse',
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

    return Response<WordResponse>(
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

  /// 作成者修正（表記・よみ）
  /// 作成後 1 時間以内かつ他ユーザーによる操作（定義投稿・保存）がない場合のみ、登録者本人が修正できる。条件はサーバーで検証する。
  ///
  /// Parameters:
  /// * [id]
  /// * [updateWordRequest] - 修正内容
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [WordResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<WordResponse>> v1WordsIdPatch({
    required String id,
    UpdateWordRequest? updateWordRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/words/{id}'.replaceAll(
      '{'
      r'id'
      '}',
      id.toString(),
    );
    final _options = Options(
      method: r'PATCH',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'firebaseIdToken'},
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
      _bodyData = jsonEncode(updateWordRequest);
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

    WordResponse? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<WordResponse, WordResponse>(
              rawData,
              'WordResponse',
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

    return Response<WordResponse>(
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

  /// 言葉の保存を解除
  ///
  ///
  /// Parameters:
  /// * [id]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> v1WordsIdSaveDelete({
    required String id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/words/{id}/save'.replaceAll(
      '{'
      r'id'
      '}',
      id.toString(),
    );
    final _options = Options(
      method: r'DELETE',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'firebaseIdToken'},
          {
            'type': 'apiKey',
            'name': 'appCheck',
            'keyName': 'X-Firebase-AppCheck',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// 言葉を保存
  ///
  ///
  /// Parameters:
  /// * [id]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future]
  /// Throws [DioException] if API call or serialization fails
  Future<Response<void>> v1WordsIdSavePut({
    required String id,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/words/{id}/save'.replaceAll(
      '{'
      r'id'
      '}',
      id.toString(),
    );
    final _options = Options(
      method: r'PUT',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'firebaseIdToken'},
          {
            'type': 'apiKey',
            'name': 'appCheck',
            'keyName': 'X-Firebase-AppCheck',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    return _response;
  }

  /// 登録前の既存語チェック
  /// 表記とよみをサーバーで前後トリム + NFC 正規化し、(表記, よみ) の完全一致で解決する。閲覧者にとって公開されている言葉だけを返し、非公開の言葉は存在を秘匿して null を返す。よみの文字種は検証しない（一致しなければ null になる）。
  ///
  /// Parameters:
  /// * [word]
  /// * [reading]
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [WordLookupResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<WordLookupResponse>> v1WordsLookupGet({
    required String word,
    required String reading,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/words/lookup';
    final _options = Options(
      method: r'GET',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'firebaseIdToken'},
          {
            'type': 'apiKey',
            'name': 'appCheck',
            'keyName': 'X-Firebase-AppCheck',
            'where': 'header',
          },
        ],
        ...?extra,
      },
      validateStatus: validateStatus,
    );

    final _queryParameters = <String, dynamic>{
      r'word': word,
      r'reading': reading,
    };

    final _response = await _dio.request<Object>(
      _path,
      options: _options,
      queryParameters: _queryParameters,
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );

    WordLookupResponse? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<WordLookupResponse, WordLookupResponse>(
              rawData,
              'WordLookupResponse',
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

    return Response<WordLookupResponse>(
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

  /// 言葉を明示登録する
  /// 表記とよみはサーバーで前後トリム + NFC 正規化してから (表記, よみ) の完全一致で解決する。新規作成は 201、既存言葉への明示登録・公開昇格は 200。表記が同じでもよみが異なれば別の言葉として新規作成する。
  ///
  /// Parameters:
  /// * [createWordRequest] - 登録内容
  /// * [cancelToken] - A [CancelToken] that can be used to cancel the operation
  /// * [headers] - Can be used to add additional headers to the request
  /// * [extras] - Can be used to add flags to the request
  /// * [validateStatus] - A [ValidateStatus] callback that can be used to determine request success based on the HTTP status of the response
  /// * [onSendProgress] - A [ProgressCallback] that can be used to get the send progress
  /// * [onReceiveProgress] - A [ProgressCallback] that can be used to get the receive progress
  ///
  /// Returns a [Future] containing a [Response] with a [CreateWordResponse] as data
  /// Throws [DioException] if API call or serialization fails
  Future<Response<CreateWordResponse>> v1WordsPost({
    CreateWordRequest? createWordRequest,
    CancelToken? cancelToken,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? extra,
    ValidateStatus? validateStatus,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    final _path = r'/v1/words';
    final _options = Options(
      method: r'POST',
      headers: <String, dynamic>{...?headers},
      extra: <String, dynamic>{
        'secure': <Map<String, String>>[
          {'type': 'http', 'scheme': 'bearer', 'name': 'firebaseIdToken'},
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
      _bodyData = jsonEncode(createWordRequest);
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

    CreateWordResponse? _responseData;

    try {
      final rawData = _response.data;
      _responseData = rawData == null
          ? null
          : deserialize<CreateWordResponse, CreateWordResponse>(
              rawData,
              'CreateWordResponse',
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

    return Response<CreateWordResponse>(
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
