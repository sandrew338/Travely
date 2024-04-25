import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  @override
  final user = FirebaseAuth.instance.currentUser;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("ProfilePage")),
        body: Text("Logged in as ${user!.email}"),
        floatingActionButton:
            IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)));
    //SvgPicture.asset("assets/images/selected/time_past.svg")
  }
}
