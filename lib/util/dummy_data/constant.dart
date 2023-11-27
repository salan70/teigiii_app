import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final usersCollection = _firestore.collection('Users');
final wordsCollection = _firestore.collection('Words');
final definitionsCollection = _firestore.collection('Definitions');
final likesCollection = _firestore.collection('Likes');
final userFollowsCollection = _firestore.collection('UserFollows');
