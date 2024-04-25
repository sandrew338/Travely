import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //user
  final currentUser = FirebaseAuth.instance.currentUser!;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: Colors.grey[300],
    appBar: AppBar(
      title:const Text("ProfilePage"),
      backgroundColor: Colors.grey[900]
      
      ),
      body: ListView(
        children: [
          const SizedBox(height: 50),

          //profile pic
          const Icon(Icons.person,
          size: 72,),


          //user email
          Text(currentUser.email!,
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[700]),)

          //user details

          //username

          //bio

          //users routs

        ],
      )
    );
  }
}