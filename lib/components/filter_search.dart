import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:travely/pages/autocomplete_page';

class FilterSearch extends StatefulWidget {
  final Function(List<String>, double) onFilterChanged;
  final List<String> initialFilters;
  final double initialRadius;

  const FilterSearch({
    Key? key,
    required this.onFilterChanged,
    this.initialFilters = const [],
    this.initialRadius = 1500,
  }) : super(key: key);

  @override
  _FilterSearchState createState() => _FilterSearchState();
}

class _FilterSearchState extends State<FilterSearch> {
  late double _currentSliderValue;
  late Map<String, bool> _filters;
  TextEditingController _locationController = TextEditingController();
  TextEditingController _destinationController = TextEditingController();

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
    widget.onFilterChanged(selectedFilters, _currentSliderValue * 1000);
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
          onPlaceSelected: (place) {
            setState(() {
              if (isLocation) {
                _locationController.text = place;
              } else {
                _destinationController.text = place;
              }
            });
          },
        ),
      ),
    );

    if (result != null) {
      setState(() {
        if (isLocation) {
          _locationController.text = result;
        } else {
          _destinationController.text = result;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Color(0xFFEEF0F2),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
          side: BorderSide(color: Colors.black)),
      child: Container(
        width: 360,
        height: 550,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ///////////////////////////////////////////1 TEXTFIELD/////////////////////////////////////
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
                  fillColor: Color(0xFFDADDD8),
                  filled: true,
                  prefixIcon: Container(
                      height: 25,
                      width: 25,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 15),
                      child: SvgPicture.asset("assets/images/location1.svg",
                          height: 25, width: 25, fit: BoxFit.scaleDown)),
                  hintText: 'Enter your location',
                  hintStyle: TextStyle(
                      fontSize: 14, color: Colors.black, fontFamily: 'Kanit')),
              onTap: () {
                _navigateToAutocompleteScreen(true);
              },
            ),
            const SizedBox(height: 16),
///////////////////////////////////////////2 TEXTFIELD/////////////////////////////////////

            SizedBox(
              height: 60,
              child: TextField(
                keyboardType: TextInputType.none,
                controller: _locationController,
                showCursor: false,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(32.0),
                      borderSide: BorderSide.none,
                    ),
                    fillColor: Color(0xFFDADDD8),
                    filled: true,
                    prefixIcon: Container(
                        height: 25,
                        width: 25,
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(left: 15),
                        child: SvgPicture.asset("assets/images/right_arrow.svg",
                            height: 25, width: 25, fit: BoxFit.scaleDown)),
                    hintText: 'Destination(optional)',
                    hintStyle: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Kanit')),
                onTap: () {
                  _navigateToAutocompleteScreen(false);
                },
              ),
            ),
/////////////////////////////////////////////////////////////////////////////////////////////////

            const Center(
              child: Text('Radius',
                  style: TextStyle(
                      fontSize: 24, color: Colors.black, fontFamily: 'Kanit')),
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
                inactiveColor: Color(0xFFFAFAFF),
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
                    style: TextStyle(
                        fontSize: 14, color: Colors.black, fontFamily: 'Kanit'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 0),
            const Center(
              child: Text(
                'Select type',
                style: TextStyle(
                    fontSize: 24, color: Colors.black, fontFamily: 'Kanit'),
              ),
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 5,
                mainAxisSpacing: 4,
                crossAxisSpacing:     0,
                physics: NeverScrollableScrollPhysics(),
                children: _filters.keys.map((String key) {
                  return CheckboxListTile(
                    title: Container(
                      
                      padding: EdgeInsets.all(5),
                      width: 50,
                      decoration: BoxDecoration(
                          color: Color(0xFFD9D9D9),
                          borderRadius: BorderRadius.all(Radius.circular(16))),
                      child: Text(
                        key,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontFamily: 'Kanit'),
                      ),
                    ),
                    contentPadding:EdgeInsets.all(0),
                    //tileColor:Colors.amber,
                    controlAffinity: ListTileControlAffinity.trailing,
                    activeColor: const Color(0xFF1C1C1C),
                    checkColor: Colors.white,
                    value: _filters[key],
                    onChanged: (bool? value) {
                      setState(() {
                        _filters[key] = value!;
                      });
                    },
                  );
                }).toList(),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
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
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.grey,
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
      Paint()..color = Color.fromARGB(255, 0, 0, 0),
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
