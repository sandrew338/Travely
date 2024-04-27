import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travely/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  //final currentUser = FirebaseAuth.instance.currentUser!;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        actions: [
          IconButton(onPressed: signUserOut, icon: const Icon(Icons.logout))
        ],
        title: const Text("ProfilePage"),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        children:  [
          const SizedBox(height: 50),

          //profile pic
          const Icon(Icons.person,
          size: 72,),


          //user email
          Text("currentUser Email",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700],)),

          const SizedBox(height: 50),

          //user details

          Padding(padding: const EdgeInsets.only(left: 25.0),
          child: Text(
            "My details",
            style: TextStyle(color: Colors.grey[600]),
          ))
          //username

          //bio

          //users routs

        ],
      ),
    ); //SvgPicture.asset("assets/images/selected/time_past.svg")
      )
    );
  }
}