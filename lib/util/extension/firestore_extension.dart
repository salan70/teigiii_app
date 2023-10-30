import 'package:cloud_firestore/cloud_firestore.dart';

extension DocumentSnapshotListExtension on List<DocumentSnapshot> {
  DocumentSnapshot? get firstOrNull => isEmpty ? null : first;
}

extension QueryDocumentSnapshotListExtension on List<QueryDocumentSnapshot> {
  QueryDocumentSnapshot? get lastOrNull => isEmpty ? null : last;
}
