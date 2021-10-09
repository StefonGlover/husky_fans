
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import 'auth.dart';


class FirebaseApi{

  static UploadTask? uploadPostImage(File file){
    try{
      FirebaseAuth auth = FirebaseAuth.instance;

      //Get the user's id
      String uid = auth.currentUser!.uid.toString();

      final ref = FirebaseStorage.instance.ref('posts/$uid');

      return ref.putFile(file);

    }on FirebaseException catch(e)
    {
      print('$e');
      return null;
    }
  }

}