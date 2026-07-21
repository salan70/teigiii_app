sealed class TimelineItem {
  const TimelineItem();
}

class TimelineDefinitionItem extends TimelineItem {
  const TimelineDefinitionItem(this.definitionId);

  final String definitionId;

  @override
  bool operator ==(Object other) =>
      other is TimelineDefinitionItem && other.definitionId == definitionId;

  @override
  int get hashCode => definitionId.hashCode;
}

class TimelineWordRegisteredItem extends TimelineItem {
  const TimelineWordRegisteredItem({
    required this.wordId,
    required this.word,
    required this.reading,
  });

  final String wordId;
  final String word;
  final String reading;

  @override
  bool operator ==(Object other) =>
      other is TimelineWordRegisteredItem &&
      other.wordId == wordId &&
      other.word == word &&
      other.reading == reading;

  @override
  int get hashCode => Object.hash(wordId, word, reading);
}

class TimelinePage {
  const TimelinePage({required this.items, required this.nextCursor});

  final List<TimelineItem> items;
  final String? nextCursor;

  bool get hasMore => nextCursor != null;
}
