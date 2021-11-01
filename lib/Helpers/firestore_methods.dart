import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// This method adds a new user to the database
/// @params String of the user's name & DateTime registered
/// returns bool of the state
Future<bool> addUser(
    String firstName, String lastName, DateTime dateRegistered) async {
  try {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;

    //Get the user's id
    String uid = auth.currentUser!.uid.toString();

    users
        .doc(uid)
        .set({
          'firstName': firstName,
          'lastName': lastName,
          'dateRegistered': dateRegistered,
          'isAdmin': true,
          'isCustomer': true,
          'uid': uid
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

/// This method update the database with the user's favorites posts
/// @params post details
/// returns bool of the state
Future<bool> getFavorite(String details, String firstName, String photo,
    Timestamp timePosted) async {
  try {
    CollectionReference favorite =
        FirebaseFirestore.instance.collection('favorites');
    FirebaseAuth auth = FirebaseAuth.instance;

    //Get the user's id
    String uid = auth.currentUser!.uid.toString();

    favorite
        .add({
          'details': details,
          'firstName': firstName,
          'photo': photo,
          'timePosted': timePosted,
          'uid': uid
        })
        .then((value) => print("Favorite Added"))
        .catchError((error) => print("Failed to add favorite: $error"));
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

/// This method removes the user's favorite post
/// @params String of details and firstName from the post
/// returns bool of the state
Future<bool> deleteFavorite(String details, String firstName) async {
  try {
    CollectionReference favorite =
        FirebaseFirestore.instance.collection('favorites');
    FirebaseAuth auth = FirebaseAuth.instance;

    //Get the user's id
    String uid = auth.currentUser!.uid.toString();

    favorite
        .where('details', isEqualTo: details)
        .where('firstName', isEqualTo: firstName)
        .get()
        .then((snapshot) => snapshot.docs.first.reference.delete())
        .catchError((error) => print("Failed to delete favorite: $error"));
    return true;
  } catch (e) {
    print(e);
    return false;
  }
}

/// This methods obtains the number of posts the user made
/// @params none
/// returns int number of posts
Future<int> getPostsCount() async {
  QuerySnapshot _posts = await FirebaseFirestore.instance
      .collection('posts')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
  List<DocumentSnapshot> _myPostCount = _posts.docs;
  return _myPostCount.length;
}

Future<List> getUserInfor() async {
  QuerySnapshot _user = await FirebaseFirestore.instance
      .collection('user')
      .where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
      .get();
  List<DocumentSnapshot> _myUser = _user.docs;
  return _myUser;
}

Future<bool> rankFriend(String friendUID, chatRoomMap) async {
  try {
    await FirebaseFirestore.instance
        .collection('ranking')
        .doc(friendUID)
        .set(chatRoomMap)
        .catchError((e) {
      print(e.toString());
    });
    return true;
  } on FirebaseException catch (e) {
    return false;
    print("Error: $e");
  }
}

Future<bool> createRank(String friendUID, double rank) async {
  try {


    Map<String, dynamic> chatRoomMap = {
      "rank": rank,
      "rankingUserUID": FirebaseAuth.instance.currentUser!.uid
    };

    rankFriend(friendUID, chatRoomMap);

    return true;
  } on FirebaseException catch (e) {
    return false;
    print("Error: $e");
  }
}


