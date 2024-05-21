import 'dart:async';
import 'package:flutter/material.dart';
import 'package:travely/pages/map_page.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> images;

  ImageCarousel({required this.images});

  @override
  _ImageCarouselState createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _controller;
  int _currentPage = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentPage);
    _timer = Timer.periodic(Duration(seconds: 4), (Timer timer) {
      if (_currentPage < widget.images.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _controller.animateToPage(
        _currentPage,
        duration: Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: widget.images.length,
      itemBuilder: (context, index) {
        return Image.asset(widget.images[index]);
      },
    );
  }
}

class RoutesPage extends StatefulWidget {
  const RoutesPage({Key? key}) : super(key: key);

  @override
  State<RoutesPage> createState() => _RoutesPageState();
}

class _RoutesPageState extends State<RoutesPage> {
  final List<Map<String, dynamic>> items = [
    {
      'title': 'Заголовок 1',
      'text': 'Текст 1',
      'images': [
        'lib/images/images-1.png',
        'lib/images/images-2.png',
        'lib/images/images-3.png'
      ]
    },
    // інші елементи...
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
        children: items.map((Map<String, dynamic> item) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>  MapPage(onItemTapped: (int ) { return 0; },)),
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
                  ImageCarousel(images: item['images']),
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
                                                    builder: (context) =>
                                                         MapPage(onItemTapped: (int ) { return 0; },)),
                                              );
                                            },
                                            child: ImageCarousel(
                                                images: item['images']),
                                          ),
                                          const SizedBox(height: 10),
                                          Text(
                                            item['title'],
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
                                                item['text'],
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
                            item['title'],
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
