class Definition {
  Definition({
    required this.id,
    required this.wordId,
    required this.authorId,
    required this.word,
    required this.definition,
    required this.updatedAt,
    required this.authorName,
    required this.authorIconUrl,
    required this.likesCount,
    required this.isLikedByUser,
  });
  final String id;
  final String wordId;
  final String authorId;
  final String word;
  final String definition;
  final DateTime updatedAt;
  final String authorName;
  final String authorIconUrl;
  final int likesCount;
  final bool isLikedByUser;
}
