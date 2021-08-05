import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> userSetup(
    String displayName, String address, String phonenumber) async {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;
  String uid = auth.currentUser!.uid.toString();
  users.add({
    'displayName': displayName,
    'uid': uid,
    'Address': address,
    'PhoneNumber': phonenumber
  });
  return;
}
