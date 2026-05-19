//duration_picker.dart
import 'package:flutter/material.dart';
import 'duration_option.dart';
import 'bike_details.dart'; // Import the BikeDetails screen

class DurationPickerScreen extends StatefulWidget {
  final String bikeName;
  final String bikeImageUrl;

  const DurationPickerScreen({Key? key,
  required this.bikeName,
  required this.bikeImageUrl
  }) : super(key: key);

  @override
  _DurationPickerScreenState createState() => _DurationPickerScreenState();
}

class _DurationPickerScreenState extends State<DurationPickerScreen> {
  // Track the selected duration option
  String? selectedDuration;

  // Function to handle option selection
  void _selectDuration(String duration) {
    setState(() {
      selectedDuration = duration;  // Update the selected duration
    });
  }

  // Function to navigate to BikeDetails
void _navigateToBikeDetails() {
  if (selectedDuration != null && selectedDuration!.isNotEmpty) {
    // Navigate to the BikeDetails screen with selectedDuration
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BikeDetails(
          selectedDuration: selectedDuration!,
          bikeName: widget.bikeName,
          bikeImageUrl: widget.bikeImageUrl,
          ),
      ),
    );
  } else {
    // If no selection, show a warning to the user
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Please select a duration')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(17, 27, 17, 27),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button using an Icon
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  iconSize: 30,
                  color: Colors.black,
                  onPressed: () {
                    Navigator.pop(context); // Go back to the previous page
                  },
                ),
                const SizedBox(height: 31),
                Text(
                  'Pick a duration',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 82),
                DurationOption(
                  title: 'By Hour',
                  isSelected: selectedDuration == 'By Hour',  // Check if selected
                  onTap: () => _selectDuration('By Hour'),  // Handle selection
                ),
                const SizedBox(height: 30),
                DurationOption(
                  title: 'By Day',
                  isSelected: selectedDuration == 'By Day',
                  onTap: () => _selectDuration('By Day'),
                ),
                const SizedBox(height: 20),
                DurationOption(
                  title: 'By Week',
                  isSelected: selectedDuration == 'By Week',
                  onTap: () => _selectDuration('By Week'),
                ),
                const SizedBox(height: 32),
                Center(
                  child: ElevatedButton(
                    onPressed: _navigateToBikeDetails,  // Navigate to BikeDetails with selected duration
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF41E465),
                      minimumSize: const Size(308, 48),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Next',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
