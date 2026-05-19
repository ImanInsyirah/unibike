import 'package:flutter/material.dart';

class BookingTimeInput extends StatelessWidget {
  const BookingTimeInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 31),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFE6E3E3),
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'TIME',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 6),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(70, 0, 70, 54),
            decoration: BoxDecoration(
              color: const Color(0xFFE6E3E3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              '_',
              style: TextStyle(
                fontSize: 36,
                color: Color(0xFF5B5B5B),
                fontFamily: 'Inter',
              ),
            ),
          ),
        ],
      ),
    );
  }
}