import 'package:flutter/material.dart';
import 'package:travely/pages/map_page.dart';

class RoutesPage extends StatefulWidget {
  const RoutesPage({super.key});

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}
class _RoutesPageState extends State<RoutesPage> {

final List<String> items = [
    'There is ful...',
    'There is ful...',
    'There is ful...',
    'There is ful...',
    'There is ful...',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(205, 158, 190, 255),
         appBar: AppBar(
           title: const Text("RoutesPage"),
           centerTitle: true,
      ),
      body: ListView.separated(
        itemCount: items.length,
        separatorBuilder: (BuildContext context, int index) => const Divider(height: 50),
        itemBuilder: (context, index)  {
          return ListTile(
            leading: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MapPage()),
                );
              },
              child: Image.asset(
                                    'lib/images/travelly.png',
                   fit: BoxFit.cover, // Fixes border issues
                   //width: 110.0,
                   //height: 110.0,
              ),
            ),
            title: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Container(
                        height: 300,
                        width: 300,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(items[index]),
                                  IconButton(
                                    icon: const Icon(Icons.close),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: <Widget>[
                                  Image.asset(
                                    'lib/images/travelly.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Flexible(child: Text("There is a full text"),) 
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Text(items[index]),
            ),
          );
        },
      ),
    );
  }


}