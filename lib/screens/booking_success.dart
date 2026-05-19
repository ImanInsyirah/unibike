import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../notif_service.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 305),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 91,
                height: 79,
                decoration: const BoxDecoration(
                  color: Color(0xFF41E465),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 21),
              const Text(
                'Successful Booking',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    //send notif
                    await sendNotification('Booking Confirmed!','Your bike booking was successfully completed.');
                    // Navigate to home screen and remove all previous routes
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                      (route) => false, // This removes all previous routes
                    );
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFF41E465),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
