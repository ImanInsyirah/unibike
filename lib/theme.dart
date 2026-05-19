import 'package:flutter/material.dart';

class UniBikeTheme {
  static ThemeData get theme {
    return ThemeData(
      fontFamily: 'League Gothic',
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 85,
          fontWeight: FontWeight.w400,
          color: Colors.black,
        ),
      ),
    );
  }
}