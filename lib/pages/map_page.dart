import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps/google_maps.dart';

import 'package:travely/components/filter.dart';
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
                  const Filter(),
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

/*
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    String htmlId = "7";

  // ignore: undefined_prefixed_name
  ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {
    final myLatlng = LatLng(1.3521, 103.8198);

    final mapOptions = MapOptions()
      ..zoom = 10
      ..center = LatLng(1.3521, 103.8198);

    final elem = DivElement()
      ..id = htmlId
      ..style.width = "100%"
      ..style.height = "100%"
      ..style.border = 'none';

    final map = GMap(elem as HTMLElement?, mapOptions);

    Marker(MarkerOptions()
      ..position = myLatlng
      ..map = map
      ..title = 'Hello World!'
      );

    return elem;
  });

  return HtmlElementView(viewType: htmlId);
  }
}
*/
/////////////////////////////////////////////////////////////////////////////////////
// class ExampleStaggeredAnimations extends StatefulWidget {
//   const ExampleStaggeredAnimations({
//     super.key,
//   });
//
//   @override
//   State<ExampleStaggeredAnimations> createState() =>
//       _ExampleStaggeredAnimationsState();
// }
//
// class _ExampleStaggeredAnimationsState extends State<ExampleStaggeredAnimations>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _drawerSlideController;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _drawerSlideController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 150),
//     );
//   }
//
//   @override
//   void dispose() {
//     _drawerSlideController.dispose();
//     super.dispose();
//   }
//
//   bool _isDrawerOpen() {
//     return _drawerSlideController.value == 1.0;
//   }
//
//   bool _isDrawerOpening() {
//     return _drawerSlideController.status == AnimationStatus.forward;
//   }
//
//   bool _isDrawerClosed() {
//     return _drawerSlideController.value == 0.0;
//   }
//
//   void _toggleDrawer() {
//     if (_isDrawerOpen() && _isDrawerOpening()) {
//     _drawerSlideController.reverse();
//     } else {
//     _drawerSlideController.forward();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: _buildAppBar(),
//       body: Stack(
//         children: [
//           _buildContent(),
//           _buildDrawer(),
//         ],
//       ),
//     );
//   }
//
//   PreferredSizeWidget _buildAppBar() {
//     return AppBar(
//       title: const Text(
//         'Flutter Menu',
//         style: TextStyle(
//           color: Colors.black,
//         ),
//       ),
//       backgroundColor: Colors.transparent,
//       elevation: 0.0,
//       automaticallyImplyLeading: false,
//       actions: [
//         AnimatedBuilder(
//           animation: _drawerSlideController,
//           builder: (context, child) {
//             return IconButton(
//                 onPressed: _toggleDrawer,
//                 icon: const Icon(
//               Icons.clear,
//               color: Colors.black,
//                 )
//             );
//           },
//         ),
//       ],
//     );
//   }
//
//   Widget _buildContent() {
//     // Put page content here.
//     return const SizedBox();
//   }
//
//   Widget _buildDrawer() {
//     return AnimatedBuilder(
//       animation: _drawerSlideController,
//       builder: (context, child) {
//         return FractionalTranslation(
//           translation: Offset(1.0 - _drawerSlideController.value, 0.0),
//           child: _isDrawerClosed() ? const SizedBox() : const Menu(),
//         );
//       },
//     );
//   }
// }
//
// class Menu extends StatefulWidget {
//   const Menu({super.key});
//
//   @override
//   State<Menu> createState() => _MenuState();
// }
//
// class _MenuState extends State<Menu> with SingleTickerProviderStateMixin {
//   static const _menuTitles = [
//     'Declarative style',
//     'Premade widgets',
//     'Stateful hot reload',
//     'Native performance',
//     'Great community',
//   ];
//
//   static const _initialDelayTime = Duration(milliseconds: 50);
//   static const _itemSlideTime = Duration(milliseconds: 250);
//   static const _staggerTime = Duration(milliseconds: 50);
//   static const _buttonDelayTime = Duration(milliseconds: 150);
//   static const _buttonTime = Duration(milliseconds: 500);
//   final _animationDuration = _initialDelayTime +
//       (_staggerTime * _menuTitles.length) +
//       _buttonDelayTime +
//       _buttonTime;
//
//   late AnimationController _staggeredController;
//   final List<Interval> _itemSlideIntervals = [];
//   late Interval _buttonInterval;
//
//   @override
//   void initState() {
//     super.initState();
//
//     _createAnimationIntervals();
//
//     _staggeredController = AnimationController(
//       vsync: this,
//       duration: _animationDuration,
//     )..forward();
//   }
//   void _createAnimationIntervals() {
//     for (var i = 0; i < _menuTitles.length; ++i) {
//       final startTime = _initialDelayTime + (_staggerTime * i);
//       final endTime = startTime + _itemSlideTime;
//       _itemSlideIntervals.add(
//         Interval(
//           startTime.inMilliseconds / _animationDuration.inMilliseconds,
//           endTime.inMilliseconds / _animationDuration.inMilliseconds,
//         ),
//       );
//     }
//
//     final buttonStartTime =
//         Duration(milliseconds: (_menuTitles.length * 50)) + _buttonDelayTime;
//     final buttonEndTime = buttonStartTime + _buttonTime;
//     _buttonInterval = Interval(
//       buttonStartTime.inMilliseconds / _animationDuration.inMilliseconds,
//       buttonEndTime.inMilliseconds / _animationDuration.inMilliseconds,
//     );
//   }
//
//   @override
//   void dispose() {
//     _staggeredController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.white,
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           _buildFlutterLogo(),
//           _buildContent(),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildFlutterLogo() {
//     return const Positioned(
//       right: -100,
//       bottom: -30,
//       child: Opacity(
//         opacity: 0.2,
//         child: FlutterLogo(
//           size: 400,
//         ),
//       ),
//     );
//   }
//
//   Widget _buildContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const SizedBox(height: 16),
//         ..._buildListItems(),
//         const Spacer(),
//         _buildGetStartedButton(),
//       ],
//     );
//   }
//
//   List<Widget> _buildListItems() {
//     final listItems = <Widget>[];
//     for (var i = 0; i < _menuTitles.length; ++i) {
//       listItems.add(
//         AnimatedBuilder(
//           animation: _staggeredController,
//           builder: (context, child) {
//             final animationPercent = Curves.easeOut.transform(
//               _itemSlideIntervals[i].transform(_staggeredController.value),
//             );
//             final opacity = animationPercent;
//             final slideDistance = (1.0 - animationPercent) * 150;
//
//             return Opacity(
//               opacity: opacity,
//               child: Transform.translate(
//                 offset: Offset(slideDistance, 0),
//                 child: child,
//               ),
//             );
//           },
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 16),
//             child: Text(
//               _menuTitles[i],
//               textAlign: TextAlign.left,
//               style: const TextStyle(
//                 fontSize: 24,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ),
//       );
//     }
//     return listItems;
//   }
//
//   Widget _buildGetStartedButton() {
//     return SizedBox(
//       width: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.all(24),
//         child: AnimatedBuilder(
//           animation: _staggeredController,
//           builder: (context, child) {
//             final animationPercent = Curves.elasticOut.transform(
//                 _buttonInterval.transform(_staggeredController.value));
//             final opacity = animationPercent.clamp(0.0, 1.0);
//             final scale = (animationPercent * 0.5) + 0.5;
//
//             return Opacity(
//               opacity: opacity,
//               child: Transform.scale(
//                 scale: scale,
//                 child: child,
//               ),
//             );
//           },
//           child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               shape: const StadiumBorder(),
//               backgroundColor: Colors.blue,
//               padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 14),
//             ),
//             onPressed: () {},
//             child: const Text(
//               'Get started',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 22,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }