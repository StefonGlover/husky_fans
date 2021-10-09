import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:fan_page_app/Views/account_page_view.dart';
import 'package:fan_page_app/Views/favorites_page_view.dart';
import 'package:fan_page_app/Views/feed_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FriendsList extends StatefulWidget {
  @override
  _FriendsListState createState() => _FriendsListState();
}

class _FriendsListState extends State<FriendsList> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  late String friendName;
  late String friendPhoto;
  late String friendBio;
  late String friendHometown;
  late String friendAge;

  void _viewFriendDialog() {
    showDialog(
        context: context,
        builder: (BuildContext) {
          var _postMessage = TextEditingController();
          return AlertDialog(
            scrollable: true,
            title:
                Text('$friendName', style: TextStyle(color: Colors.grey[900])),
            content: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  CircleAvatar(
                    maxRadius: 50,
                    backgroundColor: Colors.black,
                    backgroundImage: NetworkImage('$friendPhoto'),
                  ),
                  SizedBox(height: 3),
                  Text('Bio: ' + '$friendBio'),
                  Text('Hometown: ' + '$friendHometown'),
                  Text('Age: ' + '$friendAge'),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: users
            .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    margin: EdgeInsets.all(10),
                    child: Card(
                      child: Container(
                        height: 210,
                        width: 350,
                        child: Column(
                          children: [
                            SizedBox(height: 8),
                            CircleAvatar(
                              maxRadius: 50,
                              backgroundColor: Colors.black,
                              backgroundImage: NetworkImage(snapshot
                                  .data.docs[index]
                                  .data()['profilePic']),
                            ),
                            SizedBox(height: 2),
                            Text(
                                snapshot.data.docs[index].data()['firstName'] +
                                    " " +
                                    snapshot.data.docs[index]
                                        .data()['lastName'],
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: 2),
                            Text(
                                'Date joined: ' +
                                    snapshot.data.docs[index]
                                        .data()['dateRegistered']
                                        .toDate()
                                        .toString()
                                        .substring(0, 10),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                            ButtonBar(
                              children: [
                                IconButton(
                                    onPressed: () {
                                      friendName = snapshot.data.docs[index]
                                              .data()['firstName'] +
                                          " " +
                                          snapshot.data.docs[index]
                                              .data()['lastName'];
                                      friendPhoto = snapshot.data.docs[index]
                                          .data()['profilePic'];
                                      friendBio = snapshot.data.docs[index]
                                          .data()['bio'];
                                      friendHometown = snapshot.data.docs[index]
                                          .data()['hometown'];
                                      friendAge = snapshot.data.docs[index]
                                          .data()['age'];

                                      _viewFriendDialog();
                                    },
                                    icon: Icon(
                                      Icons.info,
                                      color: Colors.black,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
              },
            );
          }
        },
      ),
    );
  }
}
