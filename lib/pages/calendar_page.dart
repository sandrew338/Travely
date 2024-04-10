import 'package:flutter/material.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => CalendardPageState();
}

class CalendardPageState extends State<CalendarPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title:const Text("CalendarPage")),);
  }
}