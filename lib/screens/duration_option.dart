//duration_option.dart
import 'package:flutter/material.dart';

class DurationOption extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const DurationOption({
    Key? key,
    required this.title,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.green : const Color(0xFF8E8E8E), // Color changes when selected
                  width: 2,
                ),
                color: isSelected ? Colors.green : Colors.white, // Circle color change
              ),
            ),
            const SizedBox(width: 27),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
