import 'package:btd/Screens/Home.dart';
import 'package:btd/Screens/Login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Image Prediction',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool? _isSignedIn; // Variable to track user sign-in status

  @override
  void initState() {
    super.initState();
    checkUserSignIn();
  }

  void checkUserSignIn() {
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      setState(() {
        _isSignedIn = true;
      });
    } else {
      setState(() {
        _isSignedIn = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isSignedIn == null // Show a loading indicator if sign-in status is unknown
          ? Center(child: CircularProgressIndicator(color: Colors.orangeAccent,))
          : _isSignedIn! // Show Login or Home widget based on sign-in status
          ? Home()
          : Login(),
    );
  }
}
