import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class SideViewPage extends StatefulWidget {
  const SideViewPage({super.key});

  @override
  State<SideViewPage> createState() => _SideViewPageState();
}

class _SideViewPageState extends State<SideViewPage> {
  String currentTime = '';

  @override
  void initState() {
    super.initState();
    // Update the time every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = _getCurrentTime();
        });
      }
    });
  }

  String _getCurrentTime() {
    DateTime now = DateTime.now();
    String formattedTime = '${_addZeroIfNeeded(now.hour)}:'
        '${_addZeroIfNeeded(now.minute)}:'
        '${_addZeroIfNeeded(now.second)}';
    return formattedTime;
  }

  String _addZeroIfNeeded(int value) {
    if (value < 10) {
      return '0$value';
    }
    return value.toString();
  }

  int? currentBottle;
  int? lastIndexBottle;

  void pushBottleLeft() {
    setState(() {
      bottle.add(initialBottleLeft);
    });
  }

  void pushBottleRight() {}

  Widget initialBottleLeft = Positioned(
    top: 393,
    left: 147,
    child: Container(
      width: 112,
      height: 112,
      // color: Colors.red,
      child: const Image(
        image: AssetImage('assets/images/bottle_top_empty.png'),
        fit: BoxFit.fill,
      ),
    ),
  );

  List<Widget> bottle = [
    Positioned(
      top: 540,
      left: 210,
      child: Container(
        width: 112,
        height: 112,
        // color: Colors.red,
        child: const Image(
          image: AssetImage('assets/images/bottle_side.png'),
          fit: BoxFit.fill,
        ),
      ),
    )
  ];
  List bottlePositioned = [];

  @override
  Widget build(BuildContext context) {
    AssetImage backgroundImage = const AssetImage('assets/images/Meja.png');
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(2, 42, 94, 0.7),
      //   title: const Text("POLMAN BANDUNG"),
      // ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(2, 42, 94, 0.7),
              // image: DecorationImage(
              //   image: backgroundImage,
              //   fit: BoxFit.cover,
              // ),
            ),
          ),
          // Your Scaffold content goes here
          Scaffold(
            backgroundColor:
                Colors.transparent, // Make Scaffold background transparent
            appBar: AppBar(
              backgroundColor: const Color.fromRGBO(2, 42, 94, 0.7),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Replace 'assets/logo.png' with the path to your logo image
                      Image.asset(
                        'assets/images/Logo.png',
                        width: 120, // Adjust the width as needed
                      ),
                      const SizedBox(
                          width: 8), // Add some space between logo and time
                    ],
                  ),
                  // Widget to display current time
                  _buildCurrentTimeWidget(),
                ],
              ),
            ),
            body: Center(
              child: Container(
                alignment: Alignment.bottomCenter,
                width: MediaQuery.of(context)
                    .size
                    .width, // Adjust container size as needed
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    Positioned(
                      top: 180,
                      left: 170,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Image(
                          image: AssetImage('assets/images/magazine_side.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    ...bottle,
                    Image(
                      image: AssetImage('assets/images/side_empty.png'),
                      fit: BoxFit
                          .cover, // Fill the available space while maintaining aspect ratio
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Widget _buildCurrentTimeWidget() {
  return Padding(
    padding: const EdgeInsets.only(right: 16.0), // Adjust the padding as needed
    child: StreamBuilder(
      stream: Stream.periodic(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        return Text(
          DateFormat("EEEE, d MMMM y   HH : mm : ss")
              .format(DateTime.now()), // Format the time (HH:mm)
          style: const TextStyle(fontSize: 18, color: Colors.white),
        );
      },
    ),
  );
}
