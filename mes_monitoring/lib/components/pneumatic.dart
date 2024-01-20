import 'package:flutter/material.dart';

class PneumaticLeftComponent extends StatelessWidget {
  final bool active;

  const PneumaticLeftComponent({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 130,
      child: Container(
        decoration: active
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.5),
                    spreadRadius: 15,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              )
            : null,
        height: MediaQuery.of(context).size.height * 0.2,
        child: const Image(
          image: AssetImage('assets/images/pneumatic.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}

class PneumaticRightComponent extends StatelessWidget {
  final bool active;
  const PneumaticRightComponent({super.key, required this.active});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 100,
      left: 263,
      child: Container(
        decoration: active
            ? BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.greenAccent.withOpacity(0.5),
                    spreadRadius: 15,
                    blurRadius: 10,
                    offset: const Offset(0, 0),
                  ),
                ],
              )
            : null,
        height: MediaQuery.of(context).size.height * 0.2,
        child: const Image(
          image: AssetImage('assets/images/pneumatic.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
