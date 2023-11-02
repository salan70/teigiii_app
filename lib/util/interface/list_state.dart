import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ListState {
  bool get hasMore;
  QueryDocumentSnapshot? get lastReadQueryDocumentSnapshot;
}
