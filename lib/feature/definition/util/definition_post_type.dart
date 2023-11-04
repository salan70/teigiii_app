import 'package:flutter/cupertino.dart';

enum DefinitionPostType {
  public,
  private;

  String get label {
    switch (this) {
      case DefinitionPostType.public:
        return '全体に公開';
      case DefinitionPostType.private:
        return '非公開';
    }
  }

  IconData get icon {
    switch (this) {
      case DefinitionPostType.public:
        return CupertinoIcons.person_3;
      case DefinitionPostType.private:
        return CupertinoIcons.lock_fill;
    }
  }

  double get lergeIconSize {
    switch (this) {
      case DefinitionPostType.public:
        return 32;
      case DefinitionPostType.private:
        return 24;
    }
  }
}
