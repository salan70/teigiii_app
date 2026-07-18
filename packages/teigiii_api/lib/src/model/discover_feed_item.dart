//
// HAND-MAINTAINED FILE (excluded via .openapi-generator-ignore)
//
// openapi-generator の dart-dio + json_serializable は oneOf を単一クラスに
// 潰してしまい、discriminator (`type`) による分岐を生成できないため、
// この union だけ手書きで維持する。スキーマ変更時は openapi.json の
// DiscoverFeedItem に追従して手動更新すること。

import 'package:teigiii_api/src/model/definition_activity.dart';
import 'package:teigiii_api/src/model/word_registered_activity.dart';

sealed class DiscoverFeedItem {
  const DiscoverFeedItem();

  factory DiscoverFeedItem.fromJson(Map<String, dynamic> json) {
    final type = json['type'];
    switch (type) {
      case 'definition':
        return DiscoverFeedDefinitionItem(DefinitionActivity.fromJson(json));
      case 'wordRegistered':
        return DiscoverFeedWordRegisteredItem(
          WordRegisteredActivity.fromJson(json),
        );
      default:
        throw FormatException('Unknown DiscoverFeedItem type: $type', json);
    }
  }

  Map<String, dynamic> toJson();
}

class DiscoverFeedDefinitionItem extends DiscoverFeedItem {
  const DiscoverFeedDefinitionItem(this.activity);

  final DefinitionActivity activity;

  @override
  Map<String, dynamic> toJson() => activity.toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoverFeedDefinitionItem && other.activity == activity;

  @override
  int get hashCode => activity.hashCode;
}

class DiscoverFeedWordRegisteredItem extends DiscoverFeedItem {
  const DiscoverFeedWordRegisteredItem(this.activity);

  final WordRegisteredActivity activity;

  @override
  Map<String, dynamic> toJson() => activity.toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DiscoverFeedWordRegisteredItem && other.activity == activity;

  @override
  int get hashCode => activity.hashCode;
}
