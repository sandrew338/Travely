import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travely/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser;

  Future<void> editField(String field) async {}

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: const Text("ProfilePage"),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        children: [
          const SizedBox(
            height: 50,
          ),

          //profile pic

          const Icon(
            Icons.person,
            size: 72,
          ),

          const SizedBox(
            height: 50,
          ),

          //user email
          Text(currentUser!.email!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[700])),

          const SizedBox(
            height: 50,
          ),
          //user details
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child:
                Text("My Details", style: TextStyle(color: Colors.grey[600])),
          ),

          //username

          MyTextBox(
            sectionName: "username",
            text: "Ivan",
            onPressed: () => editField("username"),
          ),

          const SizedBox(
            height: 20,
          ),

          //bio

          MyTextBox(
            sectionName: "empty bio",
            text: "bio",
            onPressed: () => editField("bio"),
          ),

          //user posts

          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text("My Posts", style: TextStyle(color: Colors.grey[600])),
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),

      // Text("Logged in as ${currentUser!.email}"),
      // floatingActionButton:
      //     IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout)));
    ); //SvgPicture.asset("assets/images/selected/time_past.svg")
  }
}
