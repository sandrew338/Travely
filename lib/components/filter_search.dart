// ignore_for_file: library_private_types_in_public_api

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travely/pages/autocomplete_page';

class FilterSearch extends StatefulWidget {
  final Function(List<String> filters, double radius, LatLng sourceLocation,
      LatLng destinationLocation) onFilterChanged;
  final List<String> initialFilters;
  final double initialRadius;
  final LatLng sourceLocation;
  final LatLng destinationLocation;
  final VoidCallback onApplyFilters;

  const FilterSearch({
    super.key,
    required this.onFilterChanged,
    required this.initialFilters,
    required this.initialRadius,
    required this.sourceLocation,
    required this.destinationLocation,
    required this.onApplyFilters,
  });

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  late double _currentSliderValue;
  late Map<String, bool> _filters;
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentSliderValue = widget.initialRadius / 1000;
    _filters = {
      "art_gallery": false,
      "museum": false,
      "store": false,
      "church": false,
      "cafe": false,
      "zoo": false,
      "park": false,
      "gym": false,
      "aquarium": false,
    };
    for (var filter in widget.initialFilters) {
      _filters[filter] = true;
    }
  }

  void _applyFilters() {
    List<String> selectedFilters = _filters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    widget.onFilterChanged(selectedFilters, _currentSliderValue * 1000,
        widget.sourceLocation, widget.destinationLocation);
    widget.onApplyFilters();
  }

  Future<void> _navigateToAutocompleteScreen(bool isLocation) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AutocompleteScreen(
          isLocation: isLocation,
          initialText: isLocation
              ? _locationController.text
              : _destinationController.text,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (isLocation) {
          _locationController.text = result['description'];
          final newSourceLocation = LatLng(result['lat'], result['lng']);
          widget.onFilterChanged(
            _filters.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList(),
            _currentSliderValue * 1000,
            newSourceLocation,
            widget.destinationLocation,
          );
        } else {
          _destinationController.text = result['description'];
          final newDestinationLocation = LatLng(result['lat'], result['lng']);
          widget.onFilterChanged(
            _filters.entries
                .where((entry) => entry.value)
                .map((entry) => entry.key)
                .toList(),
            _currentSliderValue * 1000,
            widget.sourceLocation,
            newDestinationLocation,
          );
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFFEEF0F2),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: const BorderSide(color: Colors.black),
      ),
      child: Container(
        width: 360,
        height: 550,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              keyboardType: TextInputType.none,
              controller: _locationController,
              showCursor: false,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.zero,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(32.0),
                  borderSide: BorderSide.none,
                ),
                fillColor: const Color(0xFFDADDD8),
                filled: true,
                prefixIcon: Container(
                  height: 25,
                  width: 25,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 15),
                  child: SvgPicture.asset(
                    "assets/images/location1.svg",
                    height: 25,
                    width: 25,
                    fit: BoxFit.scaleDown,
                  ),
                ),
                hintText: 'Enter your location',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontFamily: 'Kanit',
                ),
              ),
              onTap: () {
                _navigateToAutocompleteScreen(true);
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 60,
              child: TextField(
                keyboardType: TextInputType.none,
                controller: _destinationController,
                showCursor: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(32.0),
                    borderSide: BorderSide.none,
                  ),
                  fillColor: const Color(0xFFDADDD8),
                  filled: true,
                  prefixIcon: Container(
                    height: 25,
                    width: 25,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(left: 15),
                    child: SvgPicture.asset(
                      "assets/images/right_arrow.svg",
                      height: 25,
                      width: 25,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                  hintText: 'Destination (optional)',
                  hintStyle: const TextStyle(
                    fontSize: 14,
                    color: Colors.black,
                    fontFamily: 'Kanit',
                  ),
                ),
                onTap: () {
                  _navigateToAutocompleteScreen(false);
                },
              ),
            ),
            const Center(
              child: Text(
                'Radius',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                sliderTheme: const SliderThemeData(
                  thumbShape: MySliderComponentShape(),
                  trackHeight: 5,
                  thumbColor: Color(0xFFD9D9D9),
                ),
              ),
              child: Slider(
                inactiveColor: const Color(0xFFFAFAFF),
                value: _currentSliderValue,
                min: 0.0,
                max: 20.0,
                divisions: 40,
                activeColor: const Color(0xFFD9D9D9),
                onChanged: (val) {
                  setState(() {
                    _currentSliderValue = val;
                  });
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    '${_currentSliderValue.toStringAsFixed(1)} km',
                    textAlign: TextAlign.right,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                      fontFamily: 'Kanit',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 0),
            const Center(
              child: Text(
                'Select type',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                  fontFamily: 'Kanit',
                ),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 5,
                mainAxisSpacing: 4,
                crossAxisSpacing: 0,
                physics: const NeverScrollableScrollPhysics(),
                children: _filters.keys.map((String key) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: const BoxDecoration(
                              color: Color(0xFFD9D9D9),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16)),
                            ),
                            child: Text(
                              key,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: 'Kanit',
                              ),
                            ),
                          ),
                        ),
                        Checkbox(
                          activeColor: const Color(0xFF1C1C1C),
                          checkColor: Colors.white,
                          value: _filters[key],
                          onChanged: (bool? value) {
                            setState(() {
                              _filters[key] = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _applyFilters(); // Apply filters and call the callback passed from the parent
                    //Navigator.pop(context); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFF1C1C1C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('OK'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(
                        context); // Close the dialog without applying filters
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xFFD9D9D9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('CANCEL'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class MySliderComponentShape extends SliderComponentShape {
  const MySliderComponentShape();

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return const Size(34, 34);
  }

  @override
  void paint(PaintingContext context, Offset center,
      {required Animation<double> activationAnimation,
      required Animation<double> enableAnimation,
      required bool isDiscrete,
      required TextPainter labelPainter,
      required RenderBox parentBox,
      required SliderThemeData sliderTheme,
      required TextDirection textDirection,
      required double value,
      required double textScaleFactor,
      required Size sizeWithOverflow}) {
    final Canvas canvas = context.canvas;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 24, height: 24),
        const Radius.circular(32),
      ),
      Paint()..color = const Color.fromARGB(255, 0, 0, 0),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(center: center, width: 21, height: 21),
        const Radius.circular(32),
      ),
      Paint()..color = const Color(0xFFD9D9D9),
    );
  }
}



abstract class FilterStrategy {
  void applyFilter(Map<String, bool> filters, double radius, LatLng source, LatLng destination);
}

class BasicFilterStrategy implements FilterStrategy {
  @override
  void applyFilter(Map<String, bool> filters, double radius, LatLng source, LatLng destination) {
    // Базова реалізація фільтрації
  }
}

abstract class TextFieldDecorator {
  String decorate(String text);
}

class PrefixIconDecorator implements TextFieldDecorator {
  @override
  String decorate(String text) {
    return "PrefixIcon($text)";
  }
}



