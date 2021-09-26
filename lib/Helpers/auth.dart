import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<bool> signIn(String email, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'user-not-found') {
      print('No user found for that email.');
    } else if (e.code == 'wrong-password') {
      print('Wrong password provided for that user.');
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<bool> register(String email, String password, String firstName,
    String lastName, String timeRegistered) async {
  try {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    FirebaseAuth auth = FirebaseAuth.instance;

    //Get the user's id
    String uid = auth.currentUser!.uid.toString();

    users
        .doc(uid)
        .set({
          'firstName': firstName,
          'lastName': lastName,
          'dateRegistered': timeRegistered,
          'isAdmin': false,
          'isCustomer': true,
          'uid': uid
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'weak-password') {
      print('The password provided is too weak.');
    } else if (e.code == 'email-already-in-use') {
      print('The account already exists for that email.');
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}

Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

Future<String?> currentUserId() async {
  var currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    return currentUser.uid;
  } else {
    return null;
  }
}

Future<void> resetPassword(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

Future<String?> signInWithGoogle() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  try {
    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    await _auth.signInWithCredential(credential);
  } on FirebaseAuthException catch (e) {
    print(e.message);
    throw e;
  }
}

Future<void> signOutFromGoogle() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  await _googleSignIn.signOut();
  await _auth.signOut();
}

Future<bool> deleteUser( String email, String password) async{

// Create a credential
  AuthCredential credential = EmailAuthProvider.credential(email: email, password: password);

// Reauthenticate
  await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);

  try {
    await FirebaseAuth.instance.currentUser!.delete();
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      print('The user must reauthenticate before this operation can be executed.');

    }
    return false;
  }
}
