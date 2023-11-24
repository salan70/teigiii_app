const appleId = '6472884411';

const appStoreUrl = 'https://apps.apple.com/jp/app/id$appleId';

const googlePlayStoreUrl =
    'https://play.google.com/store/apps/details?id=com.toda.teigiii';

const latestInformationPageUrl =
    'https://almondine-ixora-d9e.notion.site/8e8ca7ad482a473099743dddb3b930ab?pvs=4';

const termPageUrl =
    'https://almondine-ixora-d9e.notion.site/cf91474015864ce381297e89be7a6e1e?pvs=4';

const privacyPolicyPageUrl =
    'https://almondine-ixora-d9e.notion.site/d6aee44eb66a4d4b88fe0a89c6e3da00?pvs=4';

const howToPageUrl =
    'https://almondine-ixora-d9e.notion.site/c1c523c7a9e949208dc814c50b2c4477?pvs=4';

String userReportFormUrl({
  required String targetUserPublicId,
  required String currentUserPublicId,
}) {
  return 'https://docs.google.com/forms/d/e/1FAIpQLSe_Y83WDspTgZIN0obOtFxpCM3IPskdPHkQ30Rtw-mrvRmSeg/viewform?usp=pp_url&entry.1412333435=${Uri.encodeComponent(targetUserPublicId)}&entry.399122039=${Uri.encodeComponent(currentUserPublicId)}';
}

String inquireFormUrl(String currentUserPublicId) {
  return 'https://docs.google.com/forms/d/e/1FAIpQLScVQ21a8-CtMRwD7Syy3AZfK07SpZQQCjYSuqNNvoA4g7rSsw/viewform?usp=pp_url&entry.2104212620=${Uri.encodeComponent(currentUserPublicId)}';
}

const defaultIconImageUrlListForProd = <String>[
  'https://firebasestorage.googleapis.com/v0/b/everyone-teigi-prod.appspot.com/o/common%2Fdefault_icon_image%2Fghost_writer.png?alt=media&token=37ed60f0-9f7a-4307-981b-437cde7a5e6f',
  'https://firebasestorage.googleapis.com/v0/b/everyone-teigi-prod.appspot.com/o/common%2Fdefault_icon_image%2Fanimal_chara_radio_penguin.png?alt=media&token=9fe745eb-51a3-4194-b4ab-c96823e486f4',
  'https://firebasestorage.googleapis.com/v0/b/everyone-teigi-prod.appspot.com/o/common%2Fdefault_icon_image%2Fanimal_chara_mogura_hakase.png?alt=media&token=3606cf7f-a8ee-4ba3-8aee-42ab4ddde5bd',
];

const defaultIconImageUrlListForDev = [
  'https://firebasestorage.googleapis.com/v0/b/everyone-teigi-dev.appspot.com/o/common%2Fdefault_icon_image%2Fanimal_chara_mogura_hakase.png?alt=media&token=fe96fdd8-f17a-45ec-9c47-3921b60b2580',
  'https://firebasestorage.googleapis.com/v0/b/everyone-teigi-dev.appspot.com/o/common%2Fdefault_icon_image%2Fanimal_chara_radio_penguin.png?alt=media&token=bc0088e1-9474-4b0c-9778-3c34e8381a2c',
  'https://firebasestorage.googleapis.com/v0/b/everyone-teigi-dev.appspot.com/o/common%2Fdefault_icon_image%2Fghost_writer.png?alt=media&token=0e2a4605-8b0f-4a36-96cd-cf7e36302243',
];
