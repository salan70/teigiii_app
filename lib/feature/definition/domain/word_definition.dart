class WordDefinition {
  WordDefinition({
    required this.wordID,
    required this.definitionID,
    required this.authorID,
    required this.word,
    required this.definition,
    required this.updatedAt,
    required this.authorName,
    required this.authorIconUrl,
    required this.likesCount,
    required this.isLikedByUser,
  });
  final String wordID;
  final String definitionID;
  final String authorID;
  final String word;
  final String definition;
  final DateTime updatedAt;
  final String authorName;
  final String authorIconUrl;
  final int likesCount;
  final bool isLikedByUser;
}
