import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:mes_monitoring/components/utils.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
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

  @override
  Widget build(BuildContext context) {
    AssetImage backgroundImage =
        const AssetImage('assets/images/background_polman.png');
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
              actions: [
                PopupMenuButton<String>(
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      const PopupMenuItem<String>(
                        value: 'option1',
                        child: Text('ATUR URL'),
                      ),
                    ];
                  },
                  onSelected: (String choice) {
                    if (choice == "option1") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SetUrlDialog(); // Custom dialog widget
                        },
                      );
                    }
                  },
                ),
              ],
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 35, top: 75),
                    child: const Text(
                      'Station View',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: () {
                              Get.toNamed("/top");
                            },
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(25),
                                child: Image.asset(
                                  "assets/images/top.png",
                                  width:
                                      MediaQuery.of(context).size.width * 0.45,
                                )),
                          ),
                          const Text(
                            'Tampak Atas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 32.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      // Column(
                      //   children: [
                      //     InkWell(
                      //       onTap: () {
                      //         Get.toNamed("/side");
                      //       },
                      //       child: ClipRRect(
                      //           borderRadius: BorderRadius.circular(25),
                      //           child: Image.asset(
                      //             "assets/images/bottom.png",
                      //             width:
                      //                 MediaQuery.of(context).size.width * 0.45,
                      //           )),
                      //     ),
                      //     const Text(
                      //       'Tampak Samping',
                      //       textAlign: TextAlign.center,
                      //       style: TextStyle(
                      //           color: Colors.white,
                      //           fontSize: 32.0,
                      //           fontWeight: FontWeight.bold),
                      //     ),
                      //   ],
                      // )
                    ],
                  )
                ],
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
