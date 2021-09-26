import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/firestore_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:timeago/timeago.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  CollectionReference posts = FirebaseFirestore.instance.collection('posts');

  int numberOfItems = 1000;

  List<Color> _colors = [];

  getdatafromserver() async {
    //this show you are fetching data from server
    _colors = List.generate(numberOfItems, (index) => Colors.black);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getdatafromserver();
  }

//Favorite
//   Color _selectFavorite = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: posts.orderBy('timePosted', descending: true).get(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
                numberOfItems = snapshot.data.docs.length;
                return Container(
                  margin: EdgeInsets.all(10),
                  child: new Card(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.pets,
                            color: Colors.black,
                          ),
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                  snapshot.data.docs[index].data()['firstName'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  snapshot.data.docs[index]
                                      .data()['timePosted']
                                      .toDate()
                                      .toString()
                                      .substring(0, 16),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          subtitle: Text(
                              snapshot.data.docs[index].data()['details'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.network(
                              snapshot.data.docs[index].data()['photo']),
                        ),
                        ButtonBar(
                          children: [
                            Row(
                              children: [
                                IconButton(
                                    onPressed: () async {
                                      setState(() {
                                        _colors[index] = Colors.red;
                                      });
                                      bool favoriteAdded = await getFavorite(
                                          snapshot.data.docs[index]
                                              .data()['details'],
                                          snapshot.data.docs[index]
                                              .data()['firstName'],
                                          snapshot.data.docs[index]
                                              .data()['photo'],
                                          snapshot.data.docs[index]
                                              .data()['timePosted']);

                                      if (favoriteAdded) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Post was added to favorites!')));
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(const SnackBar(
                                                content: Text(
                                                    'Error adding post to favorites!')));
                                      }
                                    },
                                    icon: Icon(
                                      Icons.favorite,
                                      color: _colors[index],
                                    )),
                                IconButton(
                                    onPressed: null,
                                    icon:
                                        Icon(Icons.chat, color: Colors.black)),
                                IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.share,
                                      color: Colors.black,
                                    ))
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
