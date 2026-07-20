import '../../definition/domain/definition_draft.dart';

class PersonalDictionaryOverview {
  const PersonalDictionaryOverview({
    required this.definedWordCount,
    required this.draftCount,
    required this.savedWordCount,
    required this.recentDefinitions,
  });

  const PersonalDictionaryOverview.empty()
    : definedWordCount = 0,
      draftCount = 0,
      savedWordCount = 0,
      recentDefinitions = const [];

  final int definedWordCount;
  final int draftCount;
  final int savedWordCount;
  final List<RecentDefinition> recentDefinitions;

  bool get isEmpty =>
      definedWordCount == 0 &&
      draftCount == 0 &&
      savedWordCount == 0 &&
      recentDefinitions.isEmpty;
}

class RecentDefinition {
  const RecentDefinition({
    required this.id,
    required this.word,
    required this.body,
    required this.isPublic,
  });

  final String id;
  final String word;
  final String body;
  final bool isPublic;
}

class DefinedWord {
  const DefinedWord({
    required this.id,
    required this.word,
    required this.reading,
    required this.publicCount,
    required this.privateCount,
  });

  final String id;
  final String word;
  final String reading;
  final int publicCount;
  final int privateCount;
}

class SavedWord {
  const SavedWord({
    required this.id,
    required this.word,
    required this.reading,
    required this.isDefinedByMe,
  });

  final String id;
  final String word;
  final String reading;
  final bool isDefinedByMe;
}

class PagedItems<T> {
  const PagedItems({required this.items, required this.nextCursor});

  final List<T> items;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;

  PagedItems<T> append(PagedItems<T> next) =>
      PagedItems(items: [...items, ...next.items], nextCursor: next.nextCursor);
}

extension DefinitionDraftDisplay on DefinitionDraft {
  String get displayLabel {
    if (word.isNotEmpty) {
      return word;
    }
    if (definition.isNotEmpty) {
      return definition;
    }
    return wordReading;
  }
}
