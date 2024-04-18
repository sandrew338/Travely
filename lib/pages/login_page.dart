// ignore_for_file: prefer_const_constructors, duplicate_ignore, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:travely/components/my_button.dart';
import 'package:travely/components/my_textfield.dart';
import 'package:travely/components/square_tile.dart';
import 'package:travely/pages/navigator_bar.dart';

class LoginPage extends StatefulWidget {

  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}



//text editing controller
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  //sign user in method

class _LoginPageState extends State<LoginPage> {
  @override
  void signUserIn(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NavigatorBar()),
    );
  }
  Widget build(BuildContext context) {
    // Build your login page UI here
    return
  Scaffold(
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
                controller: usernameController,
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
                onTap:(){ signUserIn(context);}
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
                height: 25,
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
