import 'package:firebase_core/firebase_core.dart';

import '../util/constant/flavor.dart';
import 'firebase_options_dev.dart' as dev;
import 'firebase_options_prod.dart' as prod;

FirebaseOptions firebaseOptionsWithFlavor(Flavor flavor) {
  switch (flavor) {
    case Flavor.prod:
      return prod.DefaultFirebaseOptions.currentPlatform;
    case Flavor.dev:
      return dev.DefaultFirebaseOptions.currentPlatform;
  }
}
