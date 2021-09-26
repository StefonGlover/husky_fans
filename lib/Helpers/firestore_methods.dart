import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
          'isAdmin': false,
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

Future<bool> getFavorite(
    String details, String firstName, String photo, Timestamp timePosted) async {
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


Future<bool> deleteFavorite(
    String details, String firstName) async {
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
Future<int> getPostsCount() async
{
  QuerySnapshot _posts = await FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: FirebaseAuth.instance.currentUser!.uid).get();
  List<DocumentSnapshot> _myPostCount = _posts.docs;
  return _myPostCount.length;
}