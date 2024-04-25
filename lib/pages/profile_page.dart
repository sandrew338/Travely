import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  final user = FirebaseAuth.instance.currentUser;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ProfilePage")),
        body: Text("Logged in as ${user!.email}"),
        floatingActionButton:
            IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)));
    //SvgPicture.asset("assets/images/selected/time_past.svg")
  }
}
