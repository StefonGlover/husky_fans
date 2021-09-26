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
      child: FutureBuilder(
        future: favorites
            .orderBy('timePosted', descending: true)
            .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
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
                              Text(snapshot.data.docs[index].data()['firstName'], style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              Text(snapshot.data.docs[index].data()['timePosted'].toDate().toString().substring(0,16), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold))
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
                           IconButton(onPressed: () async{
                             setState(() {
                               _colors[index] = Colors.black;
                             });

                             deleteFavorite(snapshot.data.docs[index].data()['details'], snapshot.data.docs[index].data()['firstName']);

                           }, icon: Icon(Icons.favorite, color: _colors[index])),
                            IconButton(
                                onPressed: null,
                                icon:
                                Icon(Icons.chat, color: Colors.black))
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
