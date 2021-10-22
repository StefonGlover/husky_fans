import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fan_page_app/models/friendsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UserInfor {
  String profilePic;
  String bio;
  String hometown;
  String firstName;
  String lastName;
  String age;
  bool isAdmin;
  Timestamp dateRegistered;
  String uid;


  UserInfor(this.profilePic, this.bio, this.hometown, this.firstName,
      this.lastName, this.age, this.isAdmin, this.dateRegistered, this.uid);


  // creating a user object from a firebase snapshot
  UserInfor.fromSnapshot(DocumentSnapshot doc)
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

