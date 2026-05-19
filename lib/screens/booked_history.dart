import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../widgets/navigation_bar.dart' as custom_nav;

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  int _activeTab = 0;
  final String? _currentUserId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              _buildBookingHeader(),
              Expanded(
                child: _activeTab == 0
                    ? _buildActiveBookings()
                    : _buildCompletedBookings(),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: custom_nav.NavigationBar(
        currentIndex: 1,
        onTabSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/notification');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }

  Widget _buildBookingHeader() {
    return Padding(
      padding: const EdgeInsets.only(top: 47, left: 23, right: 23),
      child: Column(
        children: [
          const Text(
            'Booking History',
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 51),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTabHeader(0, 'ACTIVE'),
              const SizedBox(width: 22),
              _buildTabHeader(1, 'COMPLETED'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTabHeader(int tabIndex, String title) {
    return GestureDetector(
      onTap: () => setState(() => _activeTab = tabIndex),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 20,
              fontFamily: 'Inter',
              color: _activeTab == tabIndex 
                  ? Colors.black 
                  : const Color(0xFF8E8E8E),
              fontWeight: _activeTab == tabIndex 
                  ? FontWeight.bold 
                  : FontWeight.normal,
            ),
          ),
          const SizedBox(height: 8),
          if (_activeTab == tabIndex)
            Container(
              height: 7,
              width: 100,
              color: const Color(0xFF41E465),
            ),
        ],
      ),
    );
  }

  Widget _buildActiveBookings() {
    if (_currentUserId == null) {
      return const Center(child: Text('Please log in to view bookings'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: _currentUserId)
          .where('status', isEqualTo: 'active')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No active bookings',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        //check and update expired bookings
         WidgetsBinding.instance.addPostFrameCallback((_) {
        snapshot.data!.docs.forEach((booking) {
          _checkAndUpdateBookingStatus(booking);
        });
      });

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var booking = snapshot.data!.docs[index];
            return _buildBookingCard(booking, isActive: true);
          },
        );
      },
    );
  }

  Widget _buildCompletedBookings() {
    if (_currentUserId == null) {
      return const Center(child: Text('Please log in to view bookings'));
    }

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('bookings')
          .where('userId', isEqualTo: _currentUserId)
          .where('status', isEqualTo: 'completed')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No completed bookings',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          );
        }

        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            var booking = snapshot.data!.docs[index];
            return _buildBookingCard(booking, isActive: false);
          },
        );
      },
    );
  }

void _showBookingDetailsDialog(DocumentSnapshot booking) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Booking Details'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Booking ID: ${booking.id}'),
              Text('Bike ID: ${booking['bikeId'] ?? 'N/A'}'),
              Text('Selected Date: ${_formatBookingDate(booking['selectedDate'])}'),
              Text('Selected Time: ${_formatBookingTime(booking['selectedTime'])}'),
              Text('Duration: ${booking['durationValue'] ?? 'Unknown Duration'} ${booking['duration'] ?? 'Unknown'}'),
              Text('Price: \RM${(booking['basePrice'] ?? 0.0).toStringAsFixed(2)}'),
              Text('Payment Method: ${booking['paymentMethod']}'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}

//method to check and update booking status
void _checkAndUpdateBookingStatus(DocumentSnapshot booking) {
  // Check if end date and end time exist in the booking
  if (booking['endDate'] != null && booking['endTime'] != null) {
    try {
      // Parse end date and time
      DateTime endDateTime = DateFormat('MMM dd, yyyy h:mm a').parse('${booking['endDate']} ${booking['endTime']}');

      // If booking has passed its end time, update status to completed
      if (DateTime.now().isAfter(endDateTime)) {
        FirebaseFirestore.instance
            .collection('bookings')
            .doc(booking.id)
            .update({
              'status': 'completed',
              'completedAt': FieldValue.serverTimestamp()
            });
      }
    } catch (e) {
      print('Error processing booking expiration: $e');
    }
  }
}

  Widget _buildBookingCard(DocumentSnapshot booking, {required bool isActive}) {
    return GestureDetector(
      onTap: isActive 
        ? () => _showBookingDetailsDialog(booking) 
        : null,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 23, vertical: 10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                booking['bikeImageUrl'] ?? '',
                width: 80,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 60,
                    color: Colors.grey[300],
                    child: const Icon(Icons.bike_scooter),
                  );
                },
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['bikeId'] ?? '',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    'Booking ID: ${booking.id}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    _formatBookingDate(booking['selectedDate']),
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatBookingDate(dynamic date) {
  if (date == null) return 'Unknown Date';

  // If the field is a Timestamp, format it
  if (date is Timestamp) {
    final datetime = date.toDate();
    return '${datetime.day.toString().padLeft(2, '0')}/${datetime.month.toString().padLeft(2, '0')}/${datetime.year}';
  }
  
  // If it's a String, assume it's in a valid date format and return it
  if (date is String) {
    return date;  // You may want to perform further validation/formatting here if necessary
  }

  return 'Invalid Date';
}

String _formatBookingTime(dynamic time) {
  if (time == null) return 'Unknown Time';

  // If the field is a Timestamp, format it
  if (time is Timestamp) {
    final datetime = time.toDate();
    return '${datetime.hour.toString().padLeft(2, '0')}:${datetime.minute.toString().padLeft(2, '0')}';
  }

  // If it's a String, assume it's in a valid time format
  if (time is String) {
    return time;  // You may want to perform further validation/formatting here if necessary
  }

  return 'Invalid Time';
}
}