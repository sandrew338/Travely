import 'package:flutter/material.dart';
import 'package:travely/components/filter_search.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

//import 'dart:ui' as ui;
//import 'dart:html';

//import 'package:web/src/dom/html.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}



class _MapPageState extends State<MapPage> {
  static const LatLng _pGooglePlex = LatLng(49.8401193, 24.0245918);
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Replace this container with your Map widget
          const GoogleMap(
              initialCameraPosition:
                  CameraPosition(target: _pGooglePlex, zoom: 16)),
          Positioned(
            top: 30,
            right: 15,
            left: 15,
            height: 55,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(80)),
                color: Color(0xFFFFFFFF
),
              ),
              child: Row(
                children: <Widget>[
                  IconButton(
                    splashColor: Colors.grey,
                    icon: const Icon(Icons.menu),
                    onPressed: () {},
                  ),
                  const Expanded(
                    child: TextField(
                      cursorColor: Colors.black,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.go,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 15),
                          hintText: "Search..."),
                    ),
                  ),
                  const FilterSearch(),
                  const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Text('RD'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),

//child: bottomAppBarContents,
    );
  }
}
