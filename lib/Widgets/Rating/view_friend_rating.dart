import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetFriendRank extends StatefulWidget {
  final String documentId;

  GetFriendRank(this.documentId);

  @override
  State<GetFriendRank> createState() => _GetFriendRankState();
}

class _GetFriendRankState extends State<GetFriendRank> {
  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(widget.documentId).collection("ranks").doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15));
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Please rate ", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15));
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
          return Text("Rating: ${data['ranking']}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),);
        }

        return Text("loading");
      },
    );
  }
}
