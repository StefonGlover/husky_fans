import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Helpers/firestore_methods.dart';
import 'package:fan_page_app/Helpers/validation_methods.dart';
import 'package:fan_page_app/Views/main_page_view.dart';
import 'package:fan_page_app/Widgets/Profile/delete_account_alert.dart';
import 'package:fan_page_app/Widgets/Profile/profile_builder.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';
import 'login_view_page.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return ProfileBuilder();
  }
}
