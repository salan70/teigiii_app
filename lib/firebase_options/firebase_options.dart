import 'package:firebase_core/firebase_core.dart';

import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;

FirebaseOptions firebaseOptionsWithFlavor(String flavorName) {
  switch (flavorName) {
    case 'dev':
      return dev.DefaultFirebaseOptions.currentPlatform;
    case 'prod':
      return prod.DefaultFirebaseOptions.currentPlatform;
    default:
      throw UnsupportedError(
        'this flavor is not expected',
      );
  }
}
