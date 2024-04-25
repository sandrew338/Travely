// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:travely/components/my_button.dart';
import 'package:travely/components/my_textfield.dart';
import 'package:travely/components/square_tile.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
//text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

//sign user in method
  void signUserIn() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (builder) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
    //try sign in
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == "user-not-found") {
        print("No user found");
        wrongEmailMessage();
      } else if (e.code == "wrong-found") {
        print("Wrong password buddy");
        wrongPasswordMessage();
      }
    }
  }

  void wrongEmailMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Incorrect Email!"),
          );
        });
  }

  void wrongPasswordMessage() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Incorrect Password!"),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    // Build your login page UI here
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              const SizedBox(
                height: 50,
              ),
              //logo
              const Icon(
                Icons.lock,
                size: 100,
              ),

              const SizedBox(
                height: 50,
              ),
              //welcome back
              Text("Привіт, тебе давно не було!",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                  )),

              const SizedBox(
                height: 25,
              ),
              //username textfield

              MyTextField(
                controller: emailController,
                hintText: "Ім'я користувача",
                obscureText: false,
              ),

              const SizedBox(
                height: 25,
              ),
              //password textfield
              MyTextField(
                controller: passwordController,
                hintText: "Пароль",
                obscureText: true,
              ),

              const SizedBox(
                height: 10,
              ),
              //forgot password?
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Забули пароль?",
                      style: TextStyle(fontSize: 15, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 25,
              ),
              //sign in button
              MyButton(
                onTap: signUserIn,
              ),

              const SizedBox(
                height: 50,
              ),
              //or continue with
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Або увійди через",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                    Expanded(
                        child: Divider(
                      thickness: 0.5,
                      color: Colors.grey[400],
                    ))
                  ],
                ),
              ),

              const SizedBox(
<<<<<<< HEAD
<<<<<<< HEAD
                height: 25,
=======
                height: 20,
>>>>>>> origin/Ivan_branch
=======
                height: 25,
>>>>>>> origin/Ivan_branch
              ),

              //google + apple logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SquareTile(imagePath: "lib/images/google.png"),
                  const SizedBox(
                    width: 25,
                  ),
                  SquareTile(imagePath: "lib/images/apple.png")
                ],
              ),

              const SizedBox(
                height: 25,
              ),

              //not a member ? register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Ще не зареєстровані?",
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  const Text(
                    "Зареєструватись зараз!",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                  )
                ],
              )
            ]),
          ),
        ));
  }
}
