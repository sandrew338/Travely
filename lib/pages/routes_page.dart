import 'package:flutter/material.dart';
import 'package:travely/pages/map_page.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}
class _RoutesPageState extends State<RoutesPage> {

List routesList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    backgroundColor: const Color.fromARGB(255, 195, 226, 251),
    appBar: AppBar(
      title:const Text("RoutesPage"),
      centerTitle: true,
      ),
    body: ListView.builder(
      itemCount: routesList.length,
      itemBuilder: (BuildContext context, int index) {
        return Container();
      } ));
  }
}