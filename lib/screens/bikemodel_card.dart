//bikemodel_card.dart
import 'package:flutter/material.dart';

class BikeModelCard extends StatelessWidget {
  final String imageUrl;
  final String bikeName;
  final Function(String, String) onTap;
  final bool selected;

  const BikeModelCard({
    Key? key,
    required this.imageUrl,
    required this.bikeName,
    required this.onTap,
    this.selected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(bikeName, imageUrl), //Pass the bike name and imageUrl
      child: Container(
        width: 149,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? Colors.green : Colors.black, width: 5),
        ),
        child: Image.network(
          imageUrl,
          fit: BoxFit.contain,
          semanticLabel: 'Bike model option',
        ),
      ),
    );
  }
}
