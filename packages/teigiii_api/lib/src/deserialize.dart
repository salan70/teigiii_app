import 'package:teigiii_api/src/model/app_config_response.dart';
import 'package:teigiii_api/src/model/create_definition_request.dart';
import 'package:teigiii_api/src/model/create_user_request.dart';
import 'package:teigiii_api/src/model/create_word_request.dart';
import 'package:teigiii_api/src/model/defined_word_item.dart';
import 'package:teigiii_api/src/model/definition_activity.dart';
import 'package:teigiii_api/src/model/definition_response.dart';
import 'package:teigiii_api/src/model/discover_feed_item.dart';
import 'package:teigiii_api/src/model/error_response.dart';
import 'package:teigiii_api/src/model/error_response_error.dart';
import 'package:teigiii_api/src/model/me_response.dart';
import 'package:teigiii_api/src/model/my_dictionary_overview.dart';
import 'package:teigiii_api/src/model/saved_word_item.dart';
import 'package:teigiii_api/src/model/update_definition_request.dart';
import 'package:teigiii_api/src/model/update_me_request.dart';
import 'package:teigiii_api/src/model/update_word_request.dart';
import 'package:teigiii_api/src/model/user_dictionary_item.dart';
import 'package:teigiii_api/src/model/user_list_item.dart';
import 'package:teigiii_api/src/model/user_response.dart';
import 'package:teigiii_api/src/model/user_summary.dart';
import 'package:teigiii_api/src/model/v1_me_defined_words_get200_response.dart';
import 'package:teigiii_api/src/model/v1_me_saved_words_get200_response.dart';
import 'package:teigiii_api/src/model/v1_timeline_discover_get200_response.dart';
import 'package:teigiii_api/src/model/v1_users_id_definitions_get200_response.dart';
import 'package:teigiii_api/src/model/v1_users_id_dictionary_get200_response.dart';
import 'package:teigiii_api/src/model/v1_users_id_followers_get200_response.dart';
import 'package:teigiii_api/src/model/v1_users_me_avatar_put200_response.dart';
import 'package:teigiii_api/src/model/v1_words_get200_response.dart';
import 'package:teigiii_api/src/model/word_conflict_response.dart';
import 'package:teigiii_api/src/model/word_list_item.dart';
import 'package:teigiii_api/src/model/word_registered_activity.dart';
import 'package:teigiii_api/src/model/word_response.dart';
import 'package:teigiii_api/src/model/word_summary.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

ReturnType deserialize<ReturnType, BaseType>(
  dynamic value,
  String targetType, {
  bool growable = true,
}) {
  switch (targetType) {
    case 'String':
      return '$value' as ReturnType;
    case 'int':
      return (value is int ? value : int.parse('$value')) as ReturnType;
    case 'bool':
      if (value is bool) {
        return value as ReturnType;
      }
      final valueString = '$value'.toLowerCase();
      return (valueString == 'true' || valueString == '1') as ReturnType;
    case 'double':
      return (value is double ? value : double.parse('$value')) as ReturnType;
    case 'AppConfigResponse':
      return AppConfigResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CreateDefinitionRequest':
      return CreateDefinitionRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CreateUserRequest':
      return CreateUserRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CreateWordRequest':
      return CreateWordRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'DefinedWordItem':
      return DefinedWordItem.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'DefinitionActivity':
      return DefinitionActivity.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'DefinitionResponse':
      return DefinitionResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'DefinitionStatus':
    case 'DiscoverFeedItem':
      return DiscoverFeedItem.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ErrorResponse':
      return ErrorResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ErrorResponseError':
      return ErrorResponseError.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'MeResponse':
      return MeResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MyDictionaryOverview':
      return MyDictionaryOverview.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SavedWordItem':
      return SavedWordItem.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UpdateDefinitionRequest':
      return UpdateDefinitionRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UpdateMeRequest':
      return UpdateMeRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UpdateWordRequest':
      return UpdateWordRequest.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UserDictionaryItem':
      return UserDictionaryItem.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UserListItem':
      return UserListItem.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'UserResponse':
      return UserResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'UserSummary':
      return UserSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'V1MeDefinedWordsGet200Response':
      return V1MeDefinedWordsGet200Response.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'V1MeSavedWordsGet200Response':
      return V1MeSavedWordsGet200Response.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'V1TimelineDiscoverGet200Response':
      return V1TimelineDiscoverGet200Response.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'V1UsersIdDefinitionsGet200Response':
      return V1UsersIdDefinitionsGet200Response.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'V1UsersIdDictionaryGet200Response':
      return V1UsersIdDictionaryGet200Response.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'V1UsersIdFollowersGet200Response':
      return V1UsersIdFollowersGet200Response.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'V1UsersMeAvatarPut200Response':
      return V1UsersMeAvatarPut200Response.fromJson(
            value as Map<String, dynamic>,
          )
          as ReturnType;
    case 'V1WordsGet200Response':
      return V1WordsGet200Response.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WordConflictResponse':
      return WordConflictResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WordListItem':
      return WordListItem.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'WordRegisteredActivity':
      return WordRegisteredActivity.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'WordResponse':
      return WordResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'WordSummary':
      return WordSummary.fromJson(value as Map<String, dynamic>) as ReturnType;
    default:
      RegExpMatch? match;

      if (value is List && (match = _regList.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
                .map<BaseType>(
                  (dynamic v) => deserialize<BaseType, BaseType>(
                    v,
                    targetType,
                    growable: growable,
                  ),
                )
                .toList(growable: growable)
            as ReturnType;
      }
      if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
                .map<BaseType>(
                  (dynamic v) => deserialize<BaseType, BaseType>(
                    v,
                    targetType,
                    growable: growable,
                  ),
                )
                .toSet()
            as ReturnType;
      }
      if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
        targetType = match![1]!.trim(); // ignore: parameter_assignments
        return Map<String, BaseType>.fromIterables(
              value.keys as Iterable<String>,
              value.values.map(
                (dynamic v) => deserialize<BaseType, BaseType>(
                  v,
                  targetType,
                  growable: growable,
                ),
              ),
            )
            as ReturnType;
      }
      break;
  }
  throw Exception('Cannot deserialize');
}
