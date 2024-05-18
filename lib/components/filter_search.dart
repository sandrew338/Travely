import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:travely/components/constans.dart';

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
  List<dynamic> _locationPredictions = [];
  List<dynamic> _destinationPredictions = [];
  Timer? _debounce;

  bool _showLocationSuggestions = false;
  bool _showDestinationSuggestions = false;

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
    _locationController.addListener(() => _onTextChanged(_locationController, true));
    _destinationController.addListener(() => _onTextChanged(_destinationController, false));
  }

  void _applyFilters() {
    List<String> selectedFilters = _filters.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    widget.onFilterChanged(selectedFilters, _currentSliderValue * 1000);
  }

  void _onTextChanged(TextEditingController controller, bool isLocation) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (controller.text.isNotEmpty) {
        _getSuggestions(controller.text, isLocation);
      }
    });
  }

  Future<void> _getSuggestions(String input, bool isLocation) async {
    String baseURL = 'https://maps.googleapis.com/maps/api/place/autocomplete/json';
    String request = '$baseURL?input=$input&key=$google_api_key';
    var response = await http.get(Uri.parse(request));
    if (response.statusCode == 200) {
      setState(() {
        if (isLocation) {
          _locationPredictions = json.decode(response.body)['predictions'];
        } else {
          _destinationPredictions = json.decode(response.body)['predictions'];
        }
      });
    } else {
      throw Exception('Failed to load predictions');
    }
  }

  Future<void> _selectPrediction(String placeId) async {
    String url = 'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$google_api_key';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var details = json.decode(response.body)['result'];
      final lat = details['geometry']['location']['lat'];
      final lng = details['geometry']['location']['lng'];
      final name = details['name'];
      // Handle marker addition in the parent widget if needed
    } else {
      throw Exception('Failed to load place details');
    }
  }

  @override
 Widget build(BuildContext context) {
  return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
    child: Container(
      width: 380,
      height: 550,
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _locationController,
            decoration: InputDecoration(
              hintText: 'Search Location',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onTap: () {
              setState(() {
                _showLocationSuggestions = true;
                _showDestinationSuggestions = false;
              });
            },
          ),
          if (_showLocationSuggestions)
            Container(
              height: 150, // Adjust height as needed
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _locationPredictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_locationPredictions[index]['description']),
                    onTap: () {
                      _selectPrediction(_locationPredictions[index]['place_id']);
                      _locationController.text = _locationPredictions[index]['description'];
                      _locationPredictions = [];
                    },
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          TextField(
            controller: _destinationController,
            decoration: InputDecoration(
              hintText: 'Search Destination',
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            onTap: () {
              setState(() {
                _showLocationSuggestions = false;
                _showDestinationSuggestions = true;
              });
            },
          ),
          if (_showDestinationSuggestions)
            Container(
              height: 150, // Adjust height as needed
              padding: EdgeInsets.all(8.0),
              child: ListView.builder(
                itemCount: _destinationPredictions.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_destinationPredictions[index]['description']),
                    onTap: () {
                      _selectPrediction(_destinationPredictions[index]['place_id']);
                      _destinationController.text = _destinationPredictions[index]['description'];
                      _destinationPredictions = [];
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'Radius',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1C1C1C),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Slider(
              value: _currentSliderValue,
              min: 0.0,
              max: 20.0,
              divisions: 40,
              activeColor: const Color(0xFF1C1C1C),
              label: "${_currentSliderValue.toStringAsFixed(1)} km",
              onChanged: (val) {
                setState(() {
                  _currentSliderValue = val;
                });
              },
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text(
                'Select type',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF1C1C1C),
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 4,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                children: _filters.keys.map((String key) {
                  return CheckboxListTile(
                    title: Text(key),
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

