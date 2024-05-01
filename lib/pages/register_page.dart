// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:travely/components/my_button.dart';
import 'package:travely/components/my_textfield.dart';
import 'package:travely/components/square_tile.dart';
import 'package:travely/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
//text editing controller
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

//sign user in method
  void signUserUp() async {
    //show loading circle
    showDialog(
        context: context,
        builder: (builder) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });
    //try signup

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      showErrorMessage("Password don't match!");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      FirebaseFirestore.instance
          .collection("Users")
          .doc(userCredential.user!.email)
          .set({
        "username": emailController.text.split("@")[0],
        "bio": "Empty bio"
      });

      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      showErrorMessage(e.code);
    }
  }

  //try creating the user

  void showErrorMessage(String message) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(message),
          );
        });

    /*
        if (e.code == "user-not-found") {
        print("No user found");
        wrongEmailMessage();
      } else if (e.code == "wrong-found") {
        print("Wrong password buddy");
        wrongPasswordMessage();
      }*/
  }

  @override
  Widget build(BuildContext context) {
    // Build your login page UI here
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    //logo
                    const Icon(
                      Icons.lock,
                      size: 100,
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    //welcome back
                    const Text("Реєстрація!",
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
                      hintText: "Email",
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
                      height: 25,
                    ),
                    //password textfield
                    MyTextField(
                      controller: confirmPasswordController,
                      hintText: "Підтвердження паролю",
                      obscureText: true,
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    //sign in button
                    MyButton(
                      onTap: signUserUp,
                      text: "Зареєструватися",
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
                              "Або зареєструватись через",
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
                      height: 20,
                    ),

                    //google + apple logo
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SquareTile(
                            onTap: () => AuthService().signInWithGoogle(),
                            imagePath: "lib/images/google.png"),
                        const SizedBox(
                          width: 25,
                        ),
                        SquareTile(
                            onTap: () => AuthService().signInWithGoogle(),
                            imagePath: "lib/images/apple.png")
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
                          "Вже зареєстровані?",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        GestureDetector(
                          onTap: widget.onTap,
                          child: const Text(
                            "Увійти зараз!",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          ),
                        )
                      ],
                    )
                  ]),
            ),
          ),
        ));
  }
}