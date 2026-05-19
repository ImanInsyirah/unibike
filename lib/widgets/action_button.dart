import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: ElevatedButton(
        onPressed: () {
          // Navigate to the bike_selection page when the button is clicked
        Navigator.pushNamed(context, '/bike_selection');
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF41E465),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          minimumSize: const Size(200, 50),
        ),
        child: const Text(
          'Book Now',
          style: TextStyle(
            fontSize: 18,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}