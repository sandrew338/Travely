import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
=======
import 'package:travely/pages/login_page.dart';
import 'package:travely/pages/navigator_bar.dart';
>>>>>>> origin/Ivan_branch

class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
<<<<<<< HEAD
    body: StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder:context, snapshot),)
  
      );
    
    
=======
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const NavigatorBar();
          } else {
            return LoginPage();
          }
        },
      ),
    );
>>>>>>> origin/Ivan_branch
  }
} 

