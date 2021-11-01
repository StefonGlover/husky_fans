import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RankingMethods {
  CollectionReference ranking =
      FirebaseFirestore.instance.collection('users');
  FirebaseAuth auth = FirebaseAuth.instance;

  String getConversationID(String userID, String peerID) {
    return userID.hashCode <= peerID.hashCode
        ? userID + '_' + peerID
        : peerID + '_' + userID;
  }


  Future<bool> rankFriend(String friendUID, rankingMap) async {
    try {
      await ranking
      .doc(friendUID)
      .collection('ranks')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .set(rankingMap);

      return true;
    } on FirebaseException catch (e) {
      return false;
      print("Error: $e");
    }
  }
  Future<double?> userRank(String friendUID) async {
    var ranking;
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance.collection(
          'users').doc(friendUID)
          .collection('ranks')
          .doc(FirebaseAuth.instance.currentUser!.uid).get().then((value) =>
      ranking = value.data()!['ranking']);
    } on Exception catch (e) {
      if (ranking == null) {
        ranking = 0;
      }
      return ranking;
    }
  }



      sendRank(String friendUID, double rank) {
    //messageMap: Who sent it(uid), message, and timestamp
    Map<String, dynamic> rankingMap = {
      "ranking": rank,
      "rankedBy": FirebaseAuth.instance.currentUser!.uid,
      'ranked': friendUID,
      "timeSent": Timestamp.fromDate(DateTime.now())
    };

    rankFriend(friendUID, rankingMap);
  }

}
