//booking_detail_page.dart
import 'package:flutter/material.dart';
import '../widgets/booking_details_w.dart';
import 'payment_confirmation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class BookingDetailScreen extends StatefulWidget {
  final String selectedDate;
  final String selectedTime;
  final String duration;
  final int durationValue;
  final double basePrice;
  final String bikeId;
  final String bookingId;
  final String bikeImageUrl;

  const BookingDetailScreen({
    Key? key,
    required this.selectedDate,
    required this.selectedTime,
    required this.duration,
    required this.durationValue,
    required this.basePrice,
    required this.bikeId,
    required this.bookingId,
    required this.bikeImageUrl,
  }) : super(key: key);

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  String? _selectedPaymentMethod;
  String? _endDate;
  String? _endTime;

  @override
  void initState(){
    super.initState();
    _calculateEndDateTime();
  }

  void _calculateEndDateTime() {
  try {
    // Explicitly parse the date and time strings
    DateTime startDate = DateFormat('MMM dd, yyyy').parse(widget.selectedDate);
    TimeOfDay startTime = TimeOfDay.fromDateTime(
      DateFormat('h:mm a').parse(widget.selectedTime)
    );

    DateTime fullStartDateTime = DateTime(
      startDate.year, 
      startDate.month, 
      startDate.day, 
      startTime.hour, 
      startTime.minute
    );

    // Rest of the existing method remains the same
  } catch (e) {
    print('Date parsing error: $e');
    print('Selected Date: ${widget.selectedDate}');
    print('Selected Time: ${widget.selectedTime}');
  }
}
  // Function to save booking details to Firestore
  Future<void> _saveBookingToFirestore() async {
    try {
      final bookingData = {
        'selectedDate': widget.selectedDate,
        'selectedTime': widget.selectedTime,
        'endDate': _endDate,
        'endTime': _endTime,
        'duration': widget.duration,
        'durationValue': widget.durationValue,
        'basePrice': widget.basePrice,
        'bikeId': widget.bikeId,
        'bikeImageUrl': widget.bikeImageUrl,
        'paymentMethod': _selectedPaymentMethod,
        'status': 'active',  
        'bookingId': widget.bookingId,
        'timestamp': FieldValue.serverTimestamp(),
      };
       // Save to Firestore in 'bookings' collection
      await FirebaseFirestore.instance
          .collection('bookings')
          .doc(widget.bookingId) // Use the bookingId as the document ID
          .set(bookingData);

      print("Booking saved successfully");
    } catch (e) {
      print("Error saving booking: $e");
    }
  }

  void _handleConfirmBooking(BuildContext context) {
    if (_selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final total = widget.basePrice;

    // Save booking details to Firestore before navigating to the Payment Confirmation page
    _saveBookingToFirestore();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentConfirmationScreen(
          paymentMethod: _selectedPaymentMethod!,
          totalAmount: total,
          bookingId: widget.bookingId,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.fromLTRB(19, 27, 19, 123),
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                iconSize: 30,
                color: Colors.black,
                onPressed: () => Navigator.pop(context),
              ),
              // Add Bike Details Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bike Image
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      widget.bikeImageUrl,
                      width: 120,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          width: 120,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.bike_scooter, size: 40),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Bike Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.bikeId,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Booking id: ${widget.bookingId}',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 35,
                thickness: 3,
                color: Color(0xFFCCCCCC),
              ),
              const SizedBox(height: 24),
              const Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  'Booking Detail',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              BookingTimeWidget(
                selectedDate: widget.selectedDate,
                selectedTime: widget.selectedTime,
                duration: widget.duration,
                durationValue: widget.durationValue,
              ),
              PriceDetailWidget(
                basePrice: widget.basePrice,
                discountAmount: null,
              ),
              PaymentMethodWidget(
                onPaymentMethodSelected: (method) {
                  setState(() {
                    _selectedPaymentMethod = method;
                  });
                },
              ),
              const SizedBox(height: 18),
              Center(
                child: ElevatedButton(
                  onPressed: () => _handleConfirmBooking(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF41E465),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minimumSize: const Size(308, 50),
                  ),
                  child: const Text(
                    'Confirm Booking',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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