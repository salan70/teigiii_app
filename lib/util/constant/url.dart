const latestInformationPage =
    'https://almondine-ixora-d9e.notion.site/8e8ca7ad482a473099743dddb3b930ab?pvs=4';

String userReportFormUrl({
  required String targetUserPublicId,
  required String currentUserPublicId,
}) {
  return 'https://docs.google.com/forms/d/e/1FAIpQLSe_Y83WDspTgZIN0obOtFxpCM3IPskdPHkQ30Rtw-mrvRmSeg/viewform?usp=pp_url&entry.1412333435=$targetUserPublicId&entry.399122039=$currentUserPublicId';
}

String inquireFormUrl(String currentUserPublicId) {
  return 'https://docs.google.com/forms/d/e/1FAIpQLScVQ21a8-CtMRwD7Syy3AZfK07SpZQQCjYSuqNNvoA4g7rSsw/viewform?usp=pp_url&entry.2104212620=$currentUserPublicId';
}
