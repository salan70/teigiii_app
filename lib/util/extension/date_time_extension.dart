extension DateTimeExtension on DateTime {
  String timeAgo(DateTime baseTime) {
    final difference = baseTime.difference(this);

    const daysInWeek = 7;
    const daysInMonth = 30; // 平均的な月の日数として30を使用
    const daysInYear = 365; // 閏年は未考慮

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}分前';
    }
    if (difference.inHours < 24) {
      return '${difference.inHours}時間前';
    }
    if (difference.inDays < daysInWeek) {
      return '${difference.inDays}日前';
    }
    if (difference.inDays < daysInMonth) {
      // floor()を使用することで、小数点以下を切り捨てて整数のみ取得している（下記も同様）
      return '${(difference.inDays / daysInWeek).floor()}週間前';
    }
    if (difference.inDays < daysInYear) {
      return '${(difference.inDays / daysInMonth).floor()}ヶ月前';
    }
    return '${(difference.inDays / daysInYear).floor()}年前';
  }
}
