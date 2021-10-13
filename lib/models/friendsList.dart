import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Friends_List {
  String profilePic;
  String bio;
  String hometown;
  String firstName;
  String lastName;
  String age;
  bool isAdmin;
  Timestamp dateRegistered;
  String uid;

  Friends_List(this.profilePic, this.bio, this.hometown, this.firstName,
      this.lastName, this.age, this.isAdmin, this.dateRegistered, this.uid);

  // creating a Friends List object from a firebase snapshot
  Friends_List.fromSnapshot(DocumentSnapshot doc)
      : bio = doc.get('bio'),
        hometown = doc.get('hometown'),
        firstName = doc.get('firstName'),
        lastName = doc.get('lastName'),
        age = doc.get('age'),
        profilePic = doc.get('profilePic'),
        isAdmin = doc.get('isAdmin'),
        dateRegistered = doc.get('dateRegistered'),
        uid = doc.get('uid');
}
