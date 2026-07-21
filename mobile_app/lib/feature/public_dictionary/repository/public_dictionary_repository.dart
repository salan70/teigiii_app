import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:teigiii_api/teigiii_api.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_providers.dart';
import '../../word/domain/word.dart';
import '../domain/public_dictionary.dart';
import '../domain/public_dictionary_state.dart';

part 'public_dictionary_repository.g.dart';

@riverpod
PublicDictionaryRepository publicDictionaryRepository(
  PublicDictionaryRepositoryRef ref,
) => PublicDictionaryRepository(ref.watch(teigiiiApiProvider).getUsersApi());

class PublicDictionaryRepository {
  PublicDictionaryRepository(this._usersApi);

  final UsersApi _usersApi;

  Future<PublicDictionaryState> fetch(String userId, String? cursor) async {
    try {
      final response = await _usersApi.v1UsersIdDictionaryGet(
        id: userId,
        cursor: cursor,
      );
      final page = response.data!;
      return PublicDictionaryState(
        list: page.items
            .map(
              (item) => PublicDictionaryItem(
                word: Word(
                  id: item.word.id,
                  word: item.word.word,
                  reading: item.word.reading,
                  initialSubGroupLabel: '',
                  postedDefinitionCount: item.publicCount,
                ),
                publicDefinitionCount: item.publicCount,
              ),
            )
            .toList(),
        nextCursor: page.nextCursor,
        hasMore: page.nextCursor != null,
      );
    } on DioException catch (exception) {
      throw ApiException.fromDioException(exception);
    }
  }
}
