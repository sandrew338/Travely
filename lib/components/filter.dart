import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Filter extends StatelessWidget {
  const Filter({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.grey,
      icon: SvgPicture.asset(
        "assets/images/filter.svg",
        height: 30,
      ),
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              insetPadding: const EdgeInsets.all(10),
              child: Container(
                height: 380,
                width: 300,
                padding: const EdgeInsets.all(8.0),
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //where to go
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchBar(
                              leading: SvgPicture.asset("assets/images/location1.svg",height: 30,),

                              trailing: <Widget>[
                                Tooltip(
                                    message: 'Enter origin location',
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text("map"),
                                    )),
                              ],
                              hintText:"Enter origin location",
                              //textStyle: MaterialStateProperty,
                              ),
                              
                        ],
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Container(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SearchBar(
                              leading: SvgPicture.asset("assets/images/right_arrow.svg",height: 30,),
                              trailing: <Widget>[
                                Tooltip(
                                    message: '123',
                                    child: TextButton(
                                      onPressed: () {},
                                      child: const Text("Enter"),
                                    )),
                              ]),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    const Text('Mileage'),
                    const SizedBox(height: 8.0),
                    const Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'from',
                            ),
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'km',
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_left),
                          onPressed: () {
                            // Handle left arrow button press
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.arrow_right),
                          onPressed: () {
                            // Handle right arrow button press
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle OK button press
                          },
                          child: const Text('OK'),
                        ),
                        const SizedBox(width: 8.0),
                        ElevatedButton(
                          onPressed: () {
                            // Handle CANCEL button press
                          },
                          child: const Text('CANCEL'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
