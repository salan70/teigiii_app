enum CommunityWordFilter { all, defined, undefined }

extension CommunityWordFilterDisplay on CommunityWordFilter {
  String get apiValue => switch (this) {
    CommunityWordFilter.all => 'all',
    CommunityWordFilter.defined => 'defined',
    CommunityWordFilter.undefined => 'undefined',
  };

  String get label => switch (this) {
    CommunityWordFilter.all => 'すべて',
    CommunityWordFilter.defined => '定義あり',
    CommunityWordFilter.undefined => '定義なし',
  };
}
