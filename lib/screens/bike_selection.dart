//bikeselection.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'bikemodel_card.dart';
import 'duration_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BikeSelectionScreen extends StatefulWidget {
  const BikeSelectionScreen({Key? key}) : super(key: key);

  @override
  _BikeSelectionScreenState createState() => _BikeSelectionScreenState();
}

class _BikeSelectionScreenState extends State<BikeSelectionScreen> {
  // Track the selected bike model
  String? selectedBike;
  String? selectedBikeImage;

  // Function to handle bike selection
  void _selectBike(String bike, String imageUrl) {
    setState(() {
      selectedBike = bike; 
      selectedBikeImage = imageUrl;
    });
  }

  // Function to navigate to the next screen with the selected bike
  void _proceedToNext() async {
    if (selectedBike != null) {
      try{
        //get current user
        User? currentUser = FirebaseAuth.instance.currentUser;

        if(currentUser != null){
          //save selected bike to firestore
          await FirebaseFirestore.instance
          .collection('bike_rentals')
          .doc(currentUser.uid)
          .set({
            'selectedBike' : selectedBike,
            'selectedBikeImage': selectedBikeImage,
            'timestamp': FieldValue.serverTimestamp(),
          },SetOptions(merge: true));
       
      // Navigate to the next screen, passing the selected bike model
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DurationPickerScreen(
            bikeName: selectedBike!,
            bikeImageUrl: selectedBikeImage!,
          ),
        ),
      );
    }  else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please log in first')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving bike selection: $e')),
        );
      }
    }else {
      // Show an alert if no bike is selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a bike model')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.fromLTRB(19, 27, 19, 75),
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
                Padding(
                  padding: const EdgeInsets.only(left: 24, top: 5),
                  child: Text(
                    'Choose a bike model',
                    style: GoogleFonts.inter(
                      fontSize: 46,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 55),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BikeModelCard(
                      imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/9697208d9181fc028e4482efdb019d4b3d73f57c8dad84d15fdee5bc2de78473?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
                      bikeName: 'Bike 1',
                      onTap: _selectBike,
                      selected: selectedBike == 'Bike 1', // Highlight if selected
                    ),
                    const SizedBox(width: 19),
                    BikeModelCard(
                      imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/bf1463ea110ab0ae515f31c31bf45bd08cfdb90da0b52607950c42d184889f2d?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
                      bikeName: 'Bike 2',
                      onTap: _selectBike,
                      selected: selectedBike == 'Bike 2', // Highlight if selected
                    ),
                  ],
                ),
                const SizedBox(height: 27),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BikeModelCard(
                      imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/0e67634dbdab16134fa7c453302e0b3d30c3601d7cd50cb864e8f8e5f3028795?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
                      bikeName: 'Bike 3',
                      onTap: _selectBike,
                      selected: selectedBike == 'Bike 3', // Highlight if selected
                    ),
                    const SizedBox(width: 19),
                    BikeModelCard(
                      imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/881347144348d2e07cb086a67ea212cd4bc165fca34b86653c940b2537e2951e?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
                      bikeName: 'Bike 4',
                      onTap: _selectBike,
                      selected: selectedBike == 'Bike 4', // Highlight if selected
                    ),
                  ],
                ),
                const SizedBox(height: 17),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    BikeModelCard(
                      imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/8569ef09c478999ac9192f72e096005bd1423c97c968a07e07bf585df92bb75c?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
                      bikeName: 'Bike 5',
                      onTap: _selectBike,
                      selected: selectedBike == 'Bike 5', // Highlight if selected
                    ),
                    const SizedBox(width: 19),
                    BikeModelCard(
                      imageUrl: 'https://cdn.builder.io/api/v1/image/assets/TEMP/d95a1f71526feaac3dcbca5fea3347fef4a30d54dce7985020ff97e6cb77a40e?placeholderIfAbsent=true&apiKey=129624c0f788444588c4c3a1718805d4',
                      bikeName: 'Bike 6',
                      onTap: _selectBike,
                      selected: selectedBike == 'Bike 6', // Highlight if selected
                    ),
                  ],
                ),
                const SizedBox(height: 38),
                Center(
                  child: ElevatedButton(
                    onPressed: _proceedToNext, // Proceed to next screen
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF41E465),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      minimumSize: const Size(308, 0),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'Next',
                      style: GoogleFonts.inter(
                        fontSize: 20,
                        color: Colors.black,
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
