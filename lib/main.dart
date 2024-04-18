import 'package:flutter/material.dart';
import 'package:travely/pages/login_page.dart';
import 'package:travely/pages/navigator_bar.dart';

void main() => runApp(const Travely());

class Travely extends StatelessWidget {
  const Travely({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
      
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage());
  }
}
