const latestInformationPageUrl =
    'https://almondine-ixora-d9e.notion.site/8e8ca7ad482a473099743dddb3b930ab?pvs=4';

const termPageUrl =
    'https://almondine-ixora-d9e.notion.site/cf91474015864ce381297e89be7a6e1e?pvs=4';

const privacyPolicyUrl =
    'https://almondine-ixora-d9e.notion.site/d6aee44eb66a4d4b88fe0a89c6e3da00?pvs=4';

String userReportFormUrl({
  required String targetUserPublicId,
  required String currentUserPublicId,
}) {
  return 'https://docs.google.com/forms/d/e/1FAIpQLSe_Y83WDspTgZIN0obOtFxpCM3IPskdPHkQ30Rtw-mrvRmSeg/viewform?usp=pp_url&entry.1412333435=${Uri.encodeComponent(targetUserPublicId)}&entry.399122039=${Uri.encodeComponent(currentUserPublicId)}';
}

String inquireFormUrl(String currentUserPublicId) {
  return 'https://docs.google.com/forms/d/e/1FAIpQLScVQ21a8-CtMRwD7Syy3AZfK07SpZQQCjYSuqNNvoA4g7rSsw/viewform?usp=pp_url&entry.2104212620=${Uri.encodeComponent(currentUserPublicId)}';
}
