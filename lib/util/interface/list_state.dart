import 'package:cloud_firestore/cloud_firestore.dart';

abstract class ListState {
  List<dynamic> get list;
  bool get hasMore;
  QueryDocumentSnapshot? get lastReadQueryDocumentSnapshot;
}
