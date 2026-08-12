enum AuthProviderType {
  apple,
  google;

  String get displayName {
    switch (this) {
      case AuthProviderType.apple:
        return 'Apple';
      case AuthProviderType.google:
        return 'Google';
    }
  }
}
