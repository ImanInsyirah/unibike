import 'package:flutter/material.dart';

class UniBikeTitle extends StatelessWidget {
  const UniBikeTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: -13),
      child: Text(
        'UNI-BIKE',
        style: TextStyle(
          color: Colors.black,
          fontSize: 85,
          fontWeight: FontWeight.w400,
          fontFamily: 'League Gothic',
        ),
      ),
    );
  }
}