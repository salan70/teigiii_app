import 'package:flutter/cupertino.dart';

enum DefinitionPostType {
  public,
  private;

  String get labelForWrite {
    switch (this) {
      case DefinitionPostType.public:
        return '全体に公開';
      case DefinitionPostType.private:
        return '非公開';
    }
  }

  String get labelForChange {
    switch (this) {
      case DefinitionPostType.public:
        return '全体に公開する';
      case DefinitionPostType.private:
        return '非公開にする';
    }
  }

  String get confirmChangeMessage {
    switch (this) {
      case DefinitionPostType.public:
        return '全体に公開しますか？';
      case DefinitionPostType.private:
        return '非公開にしますか？';
    }
  }

  String get completeChangeMessage {
    switch (this) {
      case DefinitionPostType.public:
        return '全体に公開しました';
      case DefinitionPostType.private:
        return '非公開にしました';
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

  double get largeIconSize {
    switch (this) {
      case DefinitionPostType.public:
        return 32;
      case DefinitionPostType.private:
        return 24;
    }
  }
}
