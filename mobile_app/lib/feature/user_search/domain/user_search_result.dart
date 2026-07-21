class UserSearchResult {
  const UserSearchResult({
    required this.id,
    required this.publicId,
    required this.name,
    required this.avatarUrl,
  });

  final String id;
  final String publicId;
  final String name;
  final String? avatarUrl;
}
