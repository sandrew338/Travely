import 'package:flutter/material.dart';
import 'package:travely/pages/login_page.dart';
import 'package:travely/pages/map_page.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({Key? key}) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final List<Map<String, String>> items = [
    {'title': 'Заголовок 1', 'text': 'Lorem ipsum dolor sit amet, consectetur adipisci elit, sed eiusmod tempor incidunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur. Quis aute iure reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint obcaecat cupiditat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. ', 'image': 'lib/images/images-2.png'},
    {'title': 'Заголовок 2', 'text': 'Текст 2', 'image': 'lib/images/images-2.png'},
    {'title': 'Заголовок 3', 'text': 'Текст 3', 'image': 'lib/images/images-2.png'},
    {'title': 'Заголовок 4', 'text': 'Текст 4', 'image': 'lib/images/images-2.png'},
    {'title': 'Заголовок 5', 'text': 'Текст 5', 'image': 'lib/images/images-2.png'},
    {'title': 'Заголовок 6', 'text': 'Текст 6', 'image': 'lib/images/images-2.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(205, 158, 190, 255),
      appBar: AppBar(
        title: const Text("RoutesPage"),
        centerTitle: true,
      ),
      body: GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        padding: const EdgeInsets.all(4.0),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
        children: items.map((Map<String, String> item) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapPage()),
              );
            },
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapPage()),
                      );
                    },
                    child: Image.asset(
                      item['image']!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Colors.grey.withOpacity(0.5),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  child: Container(
                                    height: 700,
                                    width: 400,
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context, 
                                                MaterialPageRoute(
                                                    builder: (context) => const MapPage()),
                                              );
                                            },
                                            child: Image.asset(
                                              item['image']!,
                                              width: 50,
                                              height: 50,
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            item['title']!,
                                            style: TextStyle(
                                              fontSize: 20.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                          const SizedBox(height: 10),
                                          Flexible(
                                            child: SingleChildScrollView(
                                              child: Text(
                                                item['text']!,
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          IconButton(
                                            icon: const Icon(Icons.close),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Text(
                            item['title']!,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}



  
//   List routesList = [4];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: const Color.fromARGB(255, 195, 226, 251),
//         appBar: AppBar( 
//           title: const Text("RoutesPage"),
//           centerTitle: true,
//         ),
//         body: ListView.builder(
//             itemCount: routesList.length,
//             itemBuilder: (BuildContext context, int index) {
//               return GestureDetector(
//                 onTap: () {
                  
//                 }, // Image tapped
//                 child: Image.asset(
//                   "lib/images/images-2.png",
//                   fit: BoxFit.cover, // Fixes border issues
//                   width: 110.0,
//                   height: 110.0,
//                 ),

//                 //child: Row(
//                 //  children: [Image.asset(name)],
//                 //),
//               );
//             }));
//   }
// }
