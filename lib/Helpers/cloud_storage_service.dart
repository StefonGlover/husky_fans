import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'auth.dart';


Future<void> getProfilePic() async {

  FirebaseAuth auth = FirebaseAuth.instance;

  //Get the user's id
  String uid = auth.currentUser!.uid.toString();

  String downloadURL = await
  FirebaseStorage.instance.ref('profilePic/$uid').getDownloadURL();
// Within your widgets:
// Image.network(downloadURL);
}