import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:travely/model/nearby_response.dart';

class NearByPlacesScreen extends StatefulWidget {
  const NearByPlacesScreen({Key? key}) : super(key: key);

  @override
  State<NearByPlacesScreen> createState() => _NearByPlacesScreenState();
}

class _NearByPlacesScreenState extends State<NearByPlacesScreen> {

  String apiKey = "AIzaSyCTa7obRMkWaWr7Ma4wlAEPieccmHIFZNE";
  String radius = "100";
  double latitude = 49.8401193;
  double longitude = 24.0245918;
  String  PLACES_API_KEY = 'AIzaSyCTa7obRMkWaWr7Ma4wlAEPieccmHIFZNE';
  NearbyPlacesResponse nearbyPlacesResponse = NearbyPlacesResponse();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Places'),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){

              getNearbyPlaces();

            }, child: const Text("Get Nearby Places")),

            if(nearbyPlacesResponse.results != null)
              for(int i = 0 ; i < nearbyPlacesResponse.results!.length; i++)
                  nearbyPlacesWidget(nearbyPlacesResponse.results![i])
          ],
        ),
      ),
    );
  }

  void getNearbyPlaces() async {

    var url = Uri.parse('https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=' + latitude.toString() + ','
    + longitude.toString() + '&radius=' + radius + '&key=' + apiKey
    );

    var response = await http.post(url);

    nearbyPlacesResponse = NearbyPlacesResponse.fromJson(jsonDecode(response.body));

    setState(() {});

  }
// Image getImage(photoReference) {
//     final baseUrl = "https://maps.googleapis.com/maps/api/place/photo";
//     final maxWidth = "400";
//     final maxHeight = "200";
//     final url = "$baseUrl?maxwidth=$maxWidth&maxheight=$maxHeight&photoreference=$photoReference&key=$PLACES_API_KEY";
//     return Image.network(url);
//   }
  
  Widget nearbyPlacesWidget(Results results) {

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10,left: 10,right: 10),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(border: Border.all(color: Colors.black),borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text("Name: " + results.name!),
          Text("Location: " + results.geometry!.location!.lat.toString() + " , " + results.geometry!.location!.lng.toString()),
          Text(results.openingHours != null ? "Open" : "Closed"),
          ListView.builder(
        itemCount: results.photos!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.all(8.0),
            child: ListTile(
              leading: Image.network(
                results.photos![index] as String,
                width: 100, // Adjust width as needed
                height: 100, // Adjust height as needed
                fit: BoxFit.cover,
              ),
              title: Text('Photo ${index + 1}'),
              // You can add more details here like photo captions, etc.
            ),
          );
        },
      ),
        ],
        
      ),
    );
    

  }
}