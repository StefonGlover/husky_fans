import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).collection("ranks").doc(FirebaseAuth.instance.currentUser!.uid).get(),
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
          return Text("Rating: ${data['ranking'].toString()}", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15),);
        }

        return Text("loading");
      },
    );
  }
}