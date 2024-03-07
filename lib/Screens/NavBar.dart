import 'package:btd/Screens/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class NavBar extends StatelessWidget {
  final BuildContext context;

  const NavBar({required this.context, Key? key}) : super(key: key);

  void _exitFunction() async {
    await GoogleSignIn().signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  @override
  Widget build(BuildContext context) {

    User? user=FirebaseAuth.instance.currentUser;

    return Drawer(
      child: Center(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.displayName ?? 'User'),
              accountEmail: Text(user?.email ?? 'Email@gmail.com'),
              currentAccountPicture: CircleAvatar(
                child: ClipOval(
                  child: Icon(Icons.account_circle_outlined, size: 64),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.orangeAccent,
              ),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app_outlined),
              title: Text('Sign Out'),
              onTap: _exitFunction,
            )
          ],
        ),
      ),
    );
  }
}
