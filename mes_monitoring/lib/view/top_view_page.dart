import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:mes_monitoring/components/pneumatic.dart';
import 'package:mes_monitoring/components/proximity.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../components/utils.dart';

class TopViewPage extends StatefulWidget {
  const TopViewPage({super.key});

  @override
  State<TopViewPage> createState() => _TopViewPageState();
}

class _TopViewPageState extends State<TopViewPage> {
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

  // double positionBottleTop = 393;
  // double positionBottleLeft = 147;

  Map plcData = {
    "AUTO": false,
    "MANUAL": false,
    "START": false,
    "OPTIC_2": false,
    "EMERGENCY": false,
    "RESET": false,
    "RETURN": false,
    "PROXIMITY_1": false,
    "PROXIMITY_2": false,
    "S_A0": false,
    "S_A1": false,
    "S_B0": false,
    "S_B1": false,
    "S_RGB1": false,
    "S_RGB2": false,
    "OPTIC_1": false
  };

  Future<bool> controlPLC(bodyPost) async {
    try {
      String url = "http://localhost";
      if (box.read("url") != null) {
        url = box.read("url");
      }
      print(url);
      final response = await http.post(
        Uri.parse('$url:8000/control'),
        body: json.encode(bodyPost),
        headers: {'Content-Type': 'application/json'},
      );
      var body = json.decode(response.body);
      if (response.statusCode == 200) {
        // Handle a successful POST response
        debugPrint('Request success with message: ${body["message"]}');
        return body["data"];
      } else {
        // Handle an error
        debugPrint('Request failed with status: ${response.statusCode}');
        Get.snackbar("Request failed with message",
            "(${response.statusCode})${body["message"]}");
        return false;
      }
    } catch (e) {
      // Handle an error
      debugPrint('Error: $e');
      Get.snackbar("Error", "$e");
      return false;
    }
  }

  // Websocket
  late IO.Socket socket;
  int second = 180;
  late Timer timerSocket;

  void initSocket() {
    String url = "http://localhost";
    if (box.read("url") != null) {
      url = box.read("url");
    }
    print(url);
    socket = IO.io('$url:8080', <String, dynamic>{
      'transports': ['websocket'],
    });

    socket.onConnect((_) {
      print('WebSocket connected');
      Get.snackbar("Websocket", "WebSocket connected");
    });

    socket.onDisconnect((_) {
      print('WebSocket disconnected');
      Get.snackbar("Websocket", "WebSocket disconnected");
    });

    socket.connect();
    initWebSocket();
    startTimerSocket();
  }

  void initWebSocket() {
    socket.on('initData', (data) {
      print('WebSocket initData : $data');
      plcData = data["data"];
      timerSocket.cancel();
    });
    socket.on('distribution:update', (data) {
      // print('WebSocket distribution:update : $data');
      timerSocket.cancel();
      if (data != null) {
        setDataSocket(data);
      }
    });
  }

  void startTimerSocket() {
    const oneSec = Duration(seconds: 1);
    timerSocket = Timer.periodic(oneSec, (timer) {
      if (second > 0) {
        setState(() {
          second -= 1;
        });
      } else {
        socket.emit('disconnect_request', []);
        timer.cancel();
      }
    });
  }

  Map lastData = {};
  void setDataSocket(data) {
    setState(() {
      plcData = data;
    });
    if ((lastData["S_A0"] != plcData["S_A0"])) {
      lastData["S_A0"] = data["S_A0"];
      if (!data["S_A0"]) pushWhiteBottle();
    }
    if ((lastData["S_B0"] != plcData["S_B0"])) {
      lastData["S_B0"] = data["S_B0"];
      if (!data["S_B0"]) pushBlackBottle();
    }
    if ((lastData["PROXIMITY_1"] != plcData["PROXIMITY_1"])) {
      lastData["PROXIMITY_1"] = data["PROXIMITY_1"];
      if (data["PROXIMITY_1"]) stage2();
    }
    if ((lastData["PROXIMITY_2"] != plcData["PROXIMITY_2"])) {
      lastData["PROXIMITY_2"] = data["PROXIMITY_2"];
      if (data["PROXIMITY_2"]) stage3();
    }

    if (data["RESET"]) {
      bottleProperties.clear();
    }
  }

  void glockOClock() {
    // Update the time every second
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          currentTime = _getCurrentTime();
        });
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // WebSocket
    initSocket();
    glockOClock();
  }

  @override
  void dispose() {
    timerSocket.cancel();
    socket.disconnect();

    super.dispose();
  }

  List bottleProperties = [];
  bool dispenserGlowUp = false;

  int findIndex(stage) {
    return bottleProperties.indexWhere(
      (bottle) => bottle[stage] == false,
    );
  }

  void pushBlackBottle() {
    bottleProperties
        .add({"left": 237, "top": 277, "duration": 750, "filled": "empty"});
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        bottleProperties[bottleProperties.length - 1] = {
          "color": "black",
          "left": 237,
          "top": 465,
          "duration": 1000,
          "filled": "empty",
          "stage1": false,
          "stage2": false,
          "stage3": false,
          "stage4": false,
          "stage5": false,
        };
      });
    }).then((value) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          bottleProperties[bottleProperties.length - 1] = {
            "color": "black",
            "left": 535,
            "top": 465,
            "duration": 6000,
            "filled": "empty",
            "stage1": false,
            "stage2": false,
            "stage3": false,
            "stage4": false,
            "stage5": false,
          };
        });
      });
    });
  }

  void pushWhiteBottle() {
    bottleProperties
        .add({"left": 104, "top": 277, "duration": 750, "filled": "empty"});
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        bottleProperties[bottleProperties.length - 1] = {
          "color": "white",
          "left": 104,
          "top": 465,
          "duration": 500,
          "filled": "empty",
          "stage1": false,
          "stage2": false,
          "stage3": false,
          "stage4": false,
          "stage5": false,
        };
      });
    }).then((value) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          bottleProperties[bottleProperties.length - 1] = {
            "color": "white",
            "left": 535,
            "top": 465,
            "duration": 6000,
            "filled": "empty",
            "stage1": false,
            "stage2": false,
            "stage3": false,
            "stage4": false,
            "stage5": false,
          };
        });
      });
    });
  }

  void stage2() {
    int index = findIndex("stage1");
    print("stage1: $index");
    if (index >= 0) {
      setState(() {
        bottleProperties[index] = {
          "color": bottleProperties[index]["color"],
          "left": 625,
          "top": 465,
          "duration": 2750,
          "filled": "empty",
          "stage1": true,
          "stage2": false,
          "stage3": false,
          "stage4": false,
          "stage5": false,
        };
      });
    }
  }

  void stage3() {
    int index = findIndex("stage2");
    print("stage2: $index");
    if (index >= 0) {
      setState(() {
        bottleProperties[index] = {
          "color": bottleProperties[index]["color"],
          "left": 756,
          "top": 465,
          "duration": 2750,
          "filled": "empty",
          "stage1": true,
          "stage2": true,
          "stage3": false,
          "stage4": false,
          "stage5": false,
        };
      });
      Future.delayed(new Duration(milliseconds: 2750), () {
        stage4();
      });
    }
  }

  void stage4() {
    int index = findIndex("stage3");
    print("stage3: $index");
    setState(() {
      dispenserGlowUp = true;
    });
    Future.delayed(const Duration(milliseconds: 3000), () async {
      if (index >= 0) {
        setState(() {
          dispenserGlowUp = false;
          bottleProperties[index] = {
            "color": bottleProperties[index]["color"],
            "left": 756,
            "top": 465,
            "duration": 2750,
            "filled": "fill",
            "stage1": true,
            "stage2": true,
            "stage3": true,
            "stage4": false,
            "stage5": false,
          };
        });
        if (bottleProperties[index]["color"] == "black") {
          await Future.delayed(const Duration(milliseconds: 3000), () {
            setState(() {
              dispenserGlowUp = true;
            });
          });
          await Future.delayed(const Duration(milliseconds: 3000), () {
            setState(() {
              dispenserGlowUp = false;
              bottleProperties[index] = {
                "color": bottleProperties[index]["color"],
                "left": 756,
                "top": 465,
                "duration": 2750,
                "filled": "fill",
                "stage1": true,
                "stage2": true,
                "stage3": true,
                "stage4": false,
                "stage5": false,
              };
            });
          });
          stage5();
        } else {
          stage5();
        }
      }
    });
  }

  void stage5() {
    int index = findIndex("stage4");
    print("stage4: $index");
    if (index >= 0) {
      setState(() {
        bottleProperties[index] = {
          "left": 1065,
          "top": 465,
          "duration": 5000,
          "filled": "fill",
          "stage1": true,
          "stage2": true,
          "stage3": true,
          "stage4": true,
          "stage5": false,
        };
      });
    }
    Future.delayed(const Duration(milliseconds: 5000), () {
      print("stage5: $index");
      if (index >= 0) {
        setState(() {
          bottleProperties[index] = {
            "left": 1065,
            "top": 25,
            "duration": 8000,
            "filled": "fill",
            "stage1": true,
            "stage2": true,
            "stage3": true,
            "stage4": true,
            "stage5": true,
          };
        });
      }
      // Future.delayed(const Duration(milliseconds: 3500), () {
      //   print(index);
      //   setState(() {
      //     bottleProperties.removeAt(index);
      //   });
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(2, 42, 94, 0.7),
      //   title: const Text("POLMAN BANDUNG"),
      // ),
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
                    } else if (choice == "option2") {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const SetBoxDialog(); // Custom dialog widget
                        },
                      ).then((value) async {
                        print(value);
                        if (value != null) await controlPLC(value);
                      });
                    }
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
                child: Stack(
                  // fit: StackFit.expand,
                  children: [
                    // PNEUMATIC LEFT
                    PneumaticLeftComponent(active: !plcData["S_A0"]),
                    // PNEUMATIC RIGHT
                    PneumaticRightComponent(active: !plcData["S_B0"]),

                    const Image(
                      image: AssetImage('assets/images/top_empty.png'),
                      fit: BoxFit
                          .cover, // Fill the available space while maintaining aspect ratio
                    ),
                    ...(bottleProperties.asMap().entries.map((entry) {
                      int index = entry.key;
                      return AnimatedPositioned(
                          duration: Duration(
                            milliseconds: bottleProperties[index]["duration"],
                          ),
                          left: bottleProperties[index]["left"].toDouble(),
                          top: bottleProperties[index]["top"].toDouble(),
                          child: SizedBox(
                              width: 79,
                              height: 79,
                              child: Image(
                                image: AssetImage(
                                    'assets/images/bottle_top_${bottleProperties[index]["filled"]}.png'),
                                fit: BoxFit.contain,
                              )));
                    }).toList()),
                    // Positioned(
                    //     top: 10,
                    //     child: TextButton(
                    //       child: const Text(
                    //         "STAGE 1",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       onPressed: () {
                    //         pushWhiteBottle();
                    //       },
                    //     )),
                    // Positioned(
                    //     top: 50,
                    //     child: TextButton(
                    //       child: const Text(
                    //         "STAGE 1B",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       onPressed: () {
                    //         pushBlackBottle();
                    //       },
                    //     )),
                    // Positioned(
                    //     top: 10,
                    //     left: 65,
                    //     child: TextButton(
                    //       child: const Text(
                    //         "STAGE 2",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       onPressed: () {
                    //         stage2();
                    //       },
                    //     )),
                    // Positioned(
                    //     top: 10,
                    //     left: 130,
                    //     child: TextButton(
                    //       child: const Text(
                    //         "STAGE 3",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       onPressed: () {
                    //         stage3();
                    //       },
                    //     )),
                    // Positioned(
                    //     top: 10,
                    //     left: 200,
                    //     child: TextButton(
                    //       child: const Text(
                    //         "STAGE 4",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       onPressed: () {
                    //         stage4();
                    //       },
                    //     )),
                    // Positioned(
                    //     top: 10,
                    //     left: 275,
                    //     child: TextButton(
                    //       child: const Text(
                    //         "STAGE 5",
                    //         style: TextStyle(color: Colors.white),
                    //       ),
                    //       onPressed: () {
                    //         stage5();
                    //       },
                    //     )),
                    // PROXIMITY1
                    ProximityComponent1(active: !plcData["PROXIMITY_1"]),
                    ProximityComponent2(active: !plcData["PROXIMITY_2"]),
                    Positioned(
                      top: 215,
                      right: 320,
                      child: Container(
                        decoration: dispenserGlowUp
                            ? BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.greenAccent.withOpacity(0.5),
                                    spreadRadius: 5,
                                    blurRadius: 10,
                                    offset: const Offset(0, 0),
                                  ),
                                ],
                              )
                            : null,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: const Image(
                          image: AssetImage('assets/images/dispenser_top.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Positioned(
                        left: 104,
                        top: 277,
                        child: Container(
                            decoration: (!plcData["OPTIC_1"] &&
                                    !plcData["S_RGB1"])
                                ? BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.redAccent.withOpacity(0.5),
                                        spreadRadius: 15,
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  )
                                : null,
                            width: 79,
                            height: 79,
                            child: const Image(
                              image: AssetImage(
                                  'assets/images/bottle_top_empty.png'),
                              fit: BoxFit.contain,
                            ))),
                    Positioned(
                        left: 237,
                        top: 277,
                        child: Container(
                            decoration: (!plcData["OPTIC_2"] &&
                                    !plcData["S_RGB2"])
                                ? BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.redAccent.withOpacity(0.5),
                                        spreadRadius: 15,
                                        blurRadius: 10,
                                        offset: const Offset(0, 0),
                                      ),
                                    ],
                                  )
                                : null,
                            width: 79,
                            height: 79,
                            child: const Image(
                              image: AssetImage(
                                  'assets/images/bottle_top_empty.png'),
                              fit: BoxFit.contain,
                            ))),
                    Positioned(
                      top: 27,
                      right: 220,
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.white, // Set the background color
                          borderRadius: BorderRadius.circular(
                              20.0), // Set the border radius
                        ),
                        child: Wrap(
                          spacing: 20,
                          alignment: WrapAlignment.spaceBetween,
                          children: [
                            CircularButton(
                              onPressed: () async {
                                var isDone =
                                    await controlPLC({"START_INPUT": true});
                                if (isDone) {
                                  await controlPLC({"START_INPUT": false});
                                }
                              },
                              text: "START",
                              buttonColor: Colors.green,
                              buttonSize: 100,
                              isOn: plcData["START"],
                            ),
                            CircularButton(
                              onPressed: () async {
                                var isDone =
                                    await controlPLC({"RESET_INPUT": true});
                                if (isDone) {
                                  await controlPLC({"RESET_INPUT": false});
                                }
                              },
                              isOn: plcData["RESET"],
                              text: "RESET",
                              buttonColor: Colors.orange,
                              buttonSize: 100,
                            ),
                            CircularButton(
                              onPressed: () async {
                                var isDone =
                                    await controlPLC({"RETURN_INPUT": true});
                                if (isDone) {
                                  await controlPLC({"RETURN_INPUT": false});
                                }
                              },
                              isOn: plcData["RETURN"],
                              text: "RETURN",
                              buttonColor: Colors.yellow,
                              buttonSize: 100,
                            ),
                            CircularButton(
                              isOn: !plcData["EMERGENCY"],
                              onPressed: () async {},
                              text: "EMG",
                              buttonColor: Colors.red,
                              buttonSize: 100,
                            ),
                          ],
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

class CircularButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final double buttonSize;
  final Color borderColor;
  final Color buttonColor;
  final bool isOn;

  const CircularButton({
    super.key,
    required this.onPressed,
    required this.text,
    required this.buttonColor,
    this.buttonSize = 50.0,
    this.borderColor = Colors.grey,
    this.isOn = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: buttonSize,
        height: buttonSize,
        decoration: BoxDecoration(
          color: buttonColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: 8.0, // Adjust the border width as needed
          ),
          boxShadow: [
            if (isOn) ...[
              BoxShadow(
                  color: buttonColor, // Adjust the shadow color as needed
                  blurRadius: 10, // Adjust the blur radius for the glow effect
                  spreadRadius:
                      2, // Adjust the spread radius for the glow effect
                  blurStyle: BlurStyle.solid),
            ]
          ],
        ),
        child: Center(
            child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        )),
      ),
    );
  }
}
