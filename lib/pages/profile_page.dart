import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
<<<<<<< HEAD
    return Scaffold(appBar: AppBar(title:const Text("ProfilePage")),);
=======
    return Scaffold(appBar: AppBar(title:const Text("ProfilePage")),
    body:SvgPicture.asset("assets/images/selected/time_past.svg"),
    );
>>>>>>> origin/Ivan_branch
  }
}