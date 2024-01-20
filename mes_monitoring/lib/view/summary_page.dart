import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../components/utils.dart';

class SummaryPage extends StatefulWidget {
  const SummaryPage({super.key});

  @override
  State<SummaryPage> createState() => _SummaryPageState();
}

class _SummaryPageState extends State<SummaryPage> {
  String currentTime = '';
  GetStorage box = GetStorage();
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Meja.png'),
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
                      const PopupMenuItem<String>(
                        value: 'option2',
                        child: Text('INPUT BOX'),
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
                    } else if (choice == "option2") {}
                  },
                ),
              ],
            ),
            body: Center(
              child: SizedBox(
                width: MediaQuery.of(context)
                    .size
                    .width, // Adjust container size as needed
                height: MediaQuery.of(context).size.height,
                child: const Row(
                  children: [],
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
