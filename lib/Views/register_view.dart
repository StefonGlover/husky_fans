import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Widgets/register_forms_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(RegisterView());

class RegisterView extends StatefulWidget {
  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  //Form key and variables
  final _formKey = GlobalKey<FormState>();

  //Controllers to catch user's inputs
  TextEditingController _emailField = TextEditingController();
  TextEditingController _passwordField = TextEditingController();
  TextEditingController _confirmPasswordField = TextEditingController();
  TextEditingController _firstNameField = TextEditingController();
  TextEditingController _lastNameField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.grey[900],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: RegisterForms()
      ),
    );
  }
}
