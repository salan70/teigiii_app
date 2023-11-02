enum DefinitionPostType {
  public,
  private;

  String get label {
    switch (this) {
      case DefinitionPostType.public:
        return '公開';
      case DefinitionPostType.private:
        return '非公開';
    }
  }
}
