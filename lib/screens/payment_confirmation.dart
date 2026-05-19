//payment_confirmation.dart
//file to show loading animation after click confirm booking on app
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'booking_success.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  final String paymentMethod;
  final double totalAmount;
  final String bookingId;

  const PaymentConfirmationScreen({
    Key? key,
    required this.paymentMethod,
    required this.totalAmount,
    required this.bookingId,
  }) : super(key: key);

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool _isProcessing = true;
  bool _isSuccess = false;

  @override
  void initState() {
    super.initState();
    _simulatePayment();
  }

  Future<void> _simulatePayment() async {
    try{
    // Simulate payment processing delay
    await Future.delayed(const Duration(seconds: 2));
    
    //update booking status
    await _updateBookingStatus('active');

    // Check and update booking status to 'completed' if applicable
  await _checkAndUpdateBookingStatus(widget.bookingId);

    setState(() {
      _isProcessing = false;
      _isSuccess = true;
    });

    // Simulate navigation delay after success
    await Future.delayed(const Duration(seconds: 1));
    
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const BookingSuccessScreen(),
        ),
        (route) => false, // Clear navigation stack
      );
    }
  }catch (e){
    print("Payment processing error: $e");
     setState(() {
      _isProcessing = false;
      _isSuccess = false;
    });

    // Show error to user
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Payment processing failed: $e'),
        backgroundColor: Colors.red,
      ),
    );
  }
  }

  Future<void> _updateBookingStatus(String status) async {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  if (userId != null) {
    // Update the booking status in Firestore
    await FirebaseFirestore.instance
        .collection('bookings')
        .doc(widget.bookingId) // This now works
        .update({
      'status': status,
      'userId': userId,
    });
  }
}

Future<void> _checkAndUpdateBookingStatus(String bookingId) async {
  final bookingSnapshot = await FirebaseFirestore.instance.collection('bookings').doc(bookingId).get();
  
  final endDateStr = bookingSnapshot.data()?['endDate'] as String?;
  final endTimeStr = bookingSnapshot.data()?['endTime'] as String?;
  
  if (endDateStr != null && endTimeStr != null) {
    // Combine date and time strings and parse
    final endDateTime = DateTime.parse('${endDateStr.replaceAll(',', '')} ${endTimeStr}');
    final now = DateTime.now();
    
    if (endDateTime.isBefore(now)) {
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(bookingId)
          .update({'status': 'completed'});
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (_isProcessing) ...[
                const CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF41E465)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Processing Payment...',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                  ),
                ),
              ] else if (_isSuccess) ...[
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF41E465),
                  size: 60,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Payment Successful!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
              ],
              const SizedBox(height: 20),
              Text(
                '${widget.paymentMethod} - \RM${widget.totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}