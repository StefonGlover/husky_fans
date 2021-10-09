import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// This method allows the user to sign in
/// @params email & password of String
/// returns bool of sign in state
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

/// This method allows the user to sign in anonymously
/// @params none
/// returns bool of the sign in state
Future<bool> signInAnonymously() async {
  try {
    UserCredential userCredential =
        await FirebaseAuth.instance.signInAnonymously();
    return true;
  } on FirebaseAuthException catch (e) {
    print('Error with signing in.');
    return false;
  }
}

/// This method allows the user to create a new account
/// @params email, password, firstName, lastname, and time registered
/// returns bool of the execution state
Future<bool> register(
    String bio,
    String hometown,
    String age,
    String email,
    String password,
    String firstName,
    String lastName,
    String profilePic,
    Timestamp timeRegistered) async {
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
          'bio': bio,
          'hometown': hometown,
          'age': age,
          'firstName': firstName,
          'lastName': lastName,
          'profilePic': profilePic,
          'dateRegistered': timeRegistered,
          'isAdmin': false,
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

/// This methods sign the user out
/// @params none
/// return none
Future<void> signOut() async {
  await FirebaseAuth.instance.signOut();
}

/// This method obtains the user's uid
/// @param none
/// returns String of user's uid
Future<String?> currentUserId() async {
  var currentUser = FirebaseAuth.instance.currentUser;

  if (currentUser != null) {
    return currentUser.uid;
  } else {
    return null;
  }
}

/// This sends a email link to the user to reset his/her password
/// @param Email of the user
/// return none
Future<void> resetPassword(String email) async {
  await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
}

/// This method allows the user to sign in with a gmail account
/// @params none
/// returns credential for logging in
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

/// This method signs the user out from Google
/// @param none
/// returns none
Future<void> signOutFromGoogle() async {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  await _googleSignIn.signOut();
  await _auth.signOut();
}

/// This method delete the user's account after re-authentication is called
/// @params String of email & password
/// returns bool of the state
Future<bool> deleteUser(String email, String password) async {
  try {
    await FirebaseAuth.instance.currentUser!.delete();
    return true;
  } on FirebaseAuthException catch (e) {
    if (e.code == 'requires-recent-login') {
      print(
          'The user must reauthenticate before this operation can be executed.');
    }
    return false;
  }
}

/// This method re-authenticate the user to allow various actions to be performed
/// @params String email & password
/// returns bool of the state
Future<bool> userReauthenticated(String email, String password) async {
  try {
    // Create a credential
    AuthCredential credential =
        EmailAuthProvider.credential(email: email, password: password);

    //Reauthenticate
    await FirebaseAuth.instance.currentUser!
        .reauthenticateWithCredential(credential);

    return true;
  } on FirebaseAuthException catch (e) {
    print(
        'Error with reauthentication. Verify that the user\'s email and password were correct.');

    return false;
  }
}
