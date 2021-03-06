import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/firestore_methods.dart';
import 'package:fan_page_app/Views/feed_page_view.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FavoritesPage extends StatefulWidget {
  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  CollectionReference favorites =
      FirebaseFirestore.instance.collection('favorites');

  int numberOfItems = 1000;

  List<Color> _colors = [];

  getdatafromserver() async {
    //this show you are fetching data from server
    _colors = List.generate(numberOfItems, (index) => Colors.red);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getdatafromserver();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: favorites
            .orderBy('timePosted', descending: true)
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          if (snapshot.hasError) {
            return Text("Something went wrong");
          } else {
            final data = snapshot.requireData;
            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (BuildContext context, int index) {
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
                              Text(data.docs[index]['firstName'],
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold)),
                              Text(
                                  data.docs[index]['timePosted']
                                      .toDate()
                                      .toString()
                                      .substring(0, 16),
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold))
                            ],
                          ),
                          subtitle: Text(data.docs[index]['details'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Image.network(data.docs[index]['photo'],
                              height: 300),
                        ),
                        ButtonBar(
                          children: [
                            IconButton(
                                onPressed: () async {
                                  setState(() {
                                    _colors[index] = Colors.black;
                                  });

                                  deleteFavorite(data.docs[index]['details'],
                                      data.docs[index]['firstName']);
                                },
                                icon: Icon(Icons.favorite,
                                    color: _colors[index])),
                            IconButton(
                                onPressed: null,
                                icon: Icon(Icons.chat, color: Colors.black))
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
