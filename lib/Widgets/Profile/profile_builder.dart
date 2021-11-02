import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/firestore_methods.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:fan_page_app/Views/main_page_view.dart';
import 'package:fan_page_app/Widgets/Profile/delete_account_alert.dart';
import 'package:fan_page_app/models/user.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ProfileBuilder extends StatefulWidget {
  @override
  _ProfileBuilderState createState() => _ProfileBuilderState();
}

class _ProfileBuilderState extends State<ProfileBuilder> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  int postCount = 0;

  UserInfor? _userInfor;

  void getUserProfile() async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((data) async {
      setState(() {
        _userInfor = UserInfor(
            data['profilePic'],
            data['bio'],
            data['hometown'],
            data['firstName'],
            data['lastName'],
            data['age'],
            data['isAdmin'],
            data['dateRegistered'],
            data['uid']);
      });
    });
  }

  getPostsCount() async {
    QuerySnapshot _posts = await FirebaseFirestore.instance
        .collection('posts')
        .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    List<DocumentSnapshot> _myPostCount = _posts.docs;
    if (_myPostCount.length == null) {
      postCount = 0;
    } else {
      postCount = _myPostCount.length;
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getPostsCount();
    getUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfor == null) {
      return MaterialApp(
          debugShowCheckedModeBanner: false,
          home: Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          ));
    } else {
      return Container(
          alignment: Alignment.topCenter,
          margin: EdgeInsets.all(10),
          child: Card(
            child: Container(
              height: 360,
              child: Column(
                children: [
                  SizedBox(height: 8),
                  Text(
                    greeting(_userInfor!.firstName),
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  CircleAvatar(
                    maxRadius: 70,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage(_userInfor!.profilePic),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _userInfor!.bio,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  SizedBox(height: 8),
                  Text('Hometown: ' + _userInfor!.hometown,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15)),
                  SizedBox(height: 8),
                  Text(
                      'Date joined: ' +
                          _userInfor!.dateRegistered
                              .toDate()
                              .toString()
                              .substring(0, 10),
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      )),
                  SizedBox(height: 8),
                  Text("Number of posts: $postCount",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  ButtonBar(
                    children: [
                      IconButton(
                          onPressed: () async {
                            await accountDeleteAlert(context);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.black,
                          )),
                      IconButton(
                          onPressed: () async {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc('7h4ohkm4L3PFnLDGDKG5QtVXYnH2')
                            .collection('ranks')
                            .doc('X1RVjxN7v7RIQoEFq1q94QFdADk2')
                                .get()
                                .then((DocumentSnapshot documentSnapshot) {
                              if (documentSnapshot.exists) {
                                print('Document data: ${documentSnapshot.data()}');
                              } else {
                                print('Document does not exist on the database');
                              }
                            });
                          },
                          icon: Icon(
                            Icons.catching_pokemon,
                            color: Colors.black,
                          ))
                    ],
                  ),
                ],
              ),
            ),
          ));
    }
  }
}
