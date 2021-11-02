import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RankingMethods {
  CollectionReference ranking = FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;


  Future<bool> rankFriend(String friendUID, rankingMap) async {
    try {
      await ranking
          .doc(friendUID)
          .collection('ranks')
          .doc(auth.currentUser!.uid)
          .set(rankingMap);

      return true;
    } on FirebaseException catch (e) {
      return false;
      print("Error: $e");
    }
  }



  sendRank(String friendUID, double rank) {
    //messageMap: Who sent it(uid), message, and timestamp
    Map<String, dynamic> rankingMap = {
      "ranking": rank,
      "rankedBy": auth.currentUser!.uid,
      'ranked': friendUID,
      "timeSent": Timestamp.fromDate(DateTime.now())
    };

    rankFriend(friendUID, rankingMap);
  }
}
