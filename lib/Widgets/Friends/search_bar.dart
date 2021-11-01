import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Widgets/Friends/buildFriendsSearch.dart';
import 'package:fan_page_app/models/friendsList.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  TextEditingController _searchController = TextEditingController();
  final ScrollController _firstController = ScrollController();


  late Future resultsLoaded;
  List _allResults = [];
  List _resultsList = [];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    resultsLoaded = getUsersStreamSnapshots();
  }

  _onSearchChanged() {
    searchResultsList();
  }

  searchResultsList() {
    var showResults = [];
    var rankedResuts = [];

    if (_searchController.text != "") {
      for (var friendsSnapshot in _allResults) {
        var firstName =
            Friends_List.fromSnapshot(friendsSnapshot).firstName.toLowerCase();

        if (firstName.contains(_searchController.text.toLowerCase())) {
          showResults.add(friendsSnapshot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    setState(() {
      _resultsList = showResults;
    });
  }

  getUsersStreamSnapshots() async {
    var data = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isNotEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();
    setState(() {
      _allResults = data.docs;
    });
    searchResultsList();
    return "complete";
  }

  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 16, left: 16, right: 16, bottom: 5),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: "Search...",
                hintStyle: TextStyle(color: Colors.black),
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20,
                ),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: EdgeInsets.all(8),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(color: Colors.grey)),
              ),
            ),
          ),
          Expanded(
              child: Scrollbar(
                controller: _firstController,
                child: ListView.builder(
                  controller: _firstController,
                  itemCount: _resultsList.length,
                  itemBuilder: (BuildContext context, int index) =>
                      buildFriendsSearch(context, _resultsList[index]),
                ),
              )),
        ],
      ),
    );
  }
}
