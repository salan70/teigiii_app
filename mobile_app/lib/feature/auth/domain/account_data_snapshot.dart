class AccountDataSnapshot {
  const AccountDataSnapshot({
    required this.definedWordCount,
    required this.savedWordCount,
    required this.followingCount,
    required this.hasEditedProfile,
  });

  final int definedWordCount;
  final int savedWordCount;
  final int followingCount;
  final bool hasEditedProfile;

  bool get hasData =>
      definedWordCount > 0 ||
      savedWordCount > 0 ||
      followingCount > 0 ||
      hasEditedProfile;
}
