import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Add this import
import '../screens/booked_history.dart';
import '../screens/home_screen.dart';
import '../screens/profile.dart';
import '../widgets/navigation_bar.dart';
import 'screens/login_page.dart';
import 'screens/bike_selection.dart';
import 'screens/notification_page.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';                 // new

import 'app_state.dart';                                 // new

void main() async {
  // Ensure widgets are initialized and Firebase is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase here

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniBike App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const UniBikeSplash(),
      routes: {
        '/bike_selection': (context) => const BikeSelectionScreen(),
        '/login': (context) => LoginScreen(),
        '/profile': (context) => ProfilePage(),
        '/home': (context) => const HomeScreen(),
        '/booking': (context) => BookingPage(),
        '/notification': (context) => NotificationPage(),
      },
    );
  }
}

class UniBikeSplash extends StatefulWidget {
  const UniBikeSplash({Key? key}) : super(key: key);

  @override
  _UniBikeSplashState createState() => _UniBikeSplashState();
}

class _UniBikeSplashState extends State<UniBikeSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/login');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.directions_bike,
              size: 80,
              color: Colors.black,
            ),
            const SizedBox(height: 20),
            const Text(
              'UNI-BIKE',
              style: TextStyle(
                color: Colors.black,
                fontSize: 85,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
