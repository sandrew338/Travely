/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travely/pages/nearby_places_screen.dart';

class FilterSearch extends StatefulWidget {
  const FilterSearch({super.key});

  @override
  State<FilterSearch> createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  double _currentSliderValue = 5;
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
                            leading: SvgPicture.asset(
                              "assets/images/location1.svg",
                              height: 30,
                            ),

                            trailing: <Widget>[
                              Tooltip(
                                  message: 'Enter origin location',
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("map"),
                                  )),
                            ],
                            hintText: "Enter origin location",
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
                              leading: SvgPicture.asset(
                                "assets/images/right_arrow.svg",
                                height: 30,
                              ),
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
                    const SizedBox(height: 16.0),
                    // �������� �� �����
                    Slider(
                      value: _currentSliderValue,
                      max: 100,
                      divisions: 5,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (BuildContext context) {
                                  getNearbyPlaces
                              return const NearByPlacesScreen();
                            }));
                          },
                          child: const Text('OK'),
                        ),
                        const SizedBox(width: 70.0),
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
*/
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travely/pages/nearby_places_screen.dart';

class FilterSearch extends StatefulWidget {
  final VoidCallback onFilterPressed; // Callback function

  const FilterSearch({super.key, required this.onFilterPressed});

  @override
  State<FilterSearch> createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  double _currentSliderValue = 5;
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
                            leading: SvgPicture.asset(
                              "assets/images/location1.svg",
                              height: 30,
                            ),

                            trailing: <Widget>[
                              Tooltip(
                                  message: 'Enter origin location',
                                  child: TextButton(
                                    onPressed: () {},
                                    child: const Text("map"),
                                  )),
                            ],
                            hintText: "Enter origin location",
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
                              leading: SvgPicture.asset(
                                "assets/images/right_arrow.svg",
                                height: 30,
                              ),
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
                    const SizedBox(height: 16.0),
                    // �������� �� �����
                    Slider(
                      value: _currentSliderValue,
                      max: 100,
                      divisions: 5,
                      label: _currentSliderValue.round().toString(),
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                        });
                      },
                    ),

                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Call the callback function when OK is pressed
                            widget.onFilterPressed();
                          },
                          child: const Text('OK'),
                        ),
                        const SizedBox(width: 70.0),
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
