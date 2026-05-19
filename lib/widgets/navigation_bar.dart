import 'package:flutter/material.dart';
import '../screens/home_screen.dart';
import '../screens/profile.dart';
import '../screens/notification_page.dart';
import '../screens/booked_history.dart';

class NavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const NavigationBar({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(context, 0, Icons.home, 'Home', HomeScreen()),
          _buildNavItem(context, 1, Icons.calendar_today, 'Booking', BookingPage()),
          _buildNavItem(context, 2, Icons.notifications, 'Notification', NotificationPage()),
          _buildNavItem(context, 3, Icons.account_circle, 'Profile', const ProfilePage()),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData icon, String label, Widget page) {
    final isSelected = currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        onTabSelected(index);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 30,
            color: isSelected ? const Color(0xFF41E465) : Colors.black54,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontFamily: 'Inter',
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? const Color(0xFF41E465) : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}



