import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopViewPage extends StatefulWidget {
  const TopViewPage({super.key});

  @override
  State<TopViewPage> createState() => _TopViewPageState();
}

class _TopViewPageState extends State<TopViewPage> {
  String currentTime = '';

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
  Timer? _timer;
  String bottleState = 'assets/images/bottle_top_empty.png';

  void startTimer() {
    bottleState = 'assets/images/bottle_top_empty.png';
    const duration = Duration(milliseconds: 1); // Change the duration as needed

    _timer = Timer.periodic(duration, (timer) {
      // Your function logic here
      // Perform any action you want at specified intervals
      setState(() {
        if (top < 657) {
          top = top + 1;
        } else {
          if (left < 1167) {
            left = left + 1;
          } else {
            bottleState = 'assets/images/bottle_top_fill.png';
            if (left < 1500) {
              left = left + 1;
            } else {
              _timer?.cancel();
            }
          }
        }
        initialBottleLeft = Positioned(
          top: top,
          left: left,
          child: SizedBox(
            width: 112,
            height: 112,
            // color: Colors.red,
            child: Image(
              image: AssetImage(bottleState),
              fit: BoxFit.fill,
            ),
          ),
        );
      });
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  void pushBottleLeft() {
    if (_timer == null)
      startTimer();
    else
      stopTimer();
  }

  void pushBottleRight() {}

  Widget initialBottleLeft = const Positioned(
    top: 393,
    left: 147,
    child: SizedBox(
      width: 112,
      height: 112,
      // color: Colors.red,
      child: Image(
        image: AssetImage('assets/images/bottle_top_empty.png'),
        fit: BoxFit.fill,
      ),
    ),
  );

  List<Widget> bottle = [];
  List bottlePositioned = [];

  // var positioned = {"top": 393, "left": 147};
  double top = 393;
  double left = 147;
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
    setState(() {
      bottle.add(Positioned(
        // top: positioned["top"] as double,
        top: top,
        left: left,
        // left: positioned["left"] as double,
        child: SizedBox(
          width: 112,
          height: 112,
          // color: Colors.red,
          child: Image(
            image: AssetImage(bottleState),
            fit: BoxFit.fill,
          ),
        ),
      ));
    });
  }

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
              image: DecorationImage(
                image: backgroundImage,
                fit: BoxFit.cover,
              ),
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
                width: MediaQuery.of(context)
                    .size
                    .width, // Adjust container size as needed
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    Image(
                      image: AssetImage('assets/images/top_empty.png'),
                      fit: BoxFit
                          .cover, // Fill the available space while maintaining aspect ratio
                    ),
                    Positioned(
                      top: 10,
                      child: IconButton(
                          onPressed: () {
                            pushBottleLeft();
                          },
                          icon: Icon(Icons.play_arrow)),
                    ),
                    // ...bottle,
                    initialBottleLeft,
                    Positioned(
                      top: 255,
                      right: 320,
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: Image(
                          image: AssetImage('assets/images/dispenser_top.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    )
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
