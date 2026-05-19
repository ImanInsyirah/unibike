import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  const HeaderSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF41E465),
      padding: const EdgeInsets.fromLTRB(25, 38, 25, 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start
        children: [
          Expanded(
            child: Text(
              'UNI-BIKE',
              style: TextStyle(
                fontSize: 23, // Adjust the font size
                fontFamily: 'League Gothic',
                fontWeight: FontWeight.w400,
              ),
              overflow: TextOverflow.ellipsis, // If text is too long, truncate with ellipsis
              maxLines: 1, // Limit to one line
            ),
          ),
          const Text(
            'Cruise through Campus Life',
            style: TextStyle(
              fontSize: 18,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
