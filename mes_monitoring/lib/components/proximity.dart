import 'package:flutter/material.dart';

class ProximityComponent1 extends StatelessWidget {
  final bool active;

  const ProximityComponent1({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 155,
      left: MediaQuery.of(context).size.width * 0.48,
      child: Container(
        decoration: !active
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.redAccent.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              )
            : null,
        height: MediaQuery.of(context).size.height * 0.06,
        child: const Image(
          image: AssetImage('assets/images/proximity.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class ProximityComponent2 extends StatelessWidget {
  final bool active;

  const ProximityComponent2({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 45,
      left: MediaQuery.of(context).size.width * 0.54,
      child: Transform.rotate(
        angle: 1 * 3.14159,
        child: Container(
          decoration: !active
              ? BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.redAccent.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: const Offset(0, 0),
                    ),
                  ],
                )
              : null,
          height: MediaQuery.of(context).size.height * 0.06,
          child: const Image(
            image: AssetImage('assets/images/proximity.png'),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
