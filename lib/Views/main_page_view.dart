import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fan_page_app/Helpers/auth.dart';
import 'package:fan_page_app/Views/account_page_view.dart';
import 'package:fan_page_app/Views/favorites_page_view.dart';
import 'package:fan_page_app/Views/feed_page_view.dart';
import 'package:fan_page_app/Widgets/home_page.dart';
import 'package:fan_page_app/Widgets/Friends/search_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../main.dart';
import 'login_view_page.dart';

void main() => runApp(MainPageView());

class MainPageView extends StatefulWidget {
  @override
  _MainPageViewState createState() => _MainPageViewState();
}

class _MainPageViewState extends State<MainPageView> {
  @override
  Widget build(BuildContext context) {
    return HomePage();
  }
}
