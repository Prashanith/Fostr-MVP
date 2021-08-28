import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fostr/models/UserModel/RoomUser.dart';

final firestoreInstance = FirebaseFirestore.instance;
final userCollection = firestoreInstance.collection('users');
final roomCollection = firestoreInstance.collection('roomss');