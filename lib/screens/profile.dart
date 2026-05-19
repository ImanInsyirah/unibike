import 'package:appunibike/app_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/navigation_bar.dart' as custom_nav;
import 'edit_profile_page.dart'; // Import the edit profile page
import 'login_page.dart'; // Import the login screen


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>?> _userProfileFuture;

  @override
  void initState() {
    super.initState();
    _refreshUserProfile();
  }

  void _refreshUserProfile() {
    setState(() {
      _userProfileFuture = Provider.of<ApplicationState>(context, listen: false)
          .getUserProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _userProfileFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(
              child: Text('No user profile found.'),
            );
          }

          final userDetails = snapshot.data!;
          return buildProfileContent(userDetails, context);
        },
      ),
      bottomNavigationBar: custom_nav.NavigationBar(
        currentIndex: 3,
        onTabSelected: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/home');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/booking');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/notification');
              break;
            case 3:
              break; // Already on profile
          }
        },
      ),
    );
  }

  Widget buildProfileContent(Map<String, dynamic> userDetails, BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 480),
        padding: const EdgeInsets.fromLTRB(27, 53, 27, 9),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Header with "Edit" button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(),
                      ),
                    ).then((_){
                      _refreshUserProfile();
                    });                   
                  },
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(21, 8, 21, 8),
                    margin: const EdgeInsets.only(top: 7),
                    color: const Color(0xFFF3F3F3),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Profile Picture
            Container(
              width: 127,
              height: 127,
              margin: const EdgeInsets.only(top: 30),
              decoration: const BoxDecoration(
                color: Color(0xFF41E465),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            const SizedBox(height: 30),
            // User Details
            buildUserDetailItem('FULL NAME', userDetails['name']),
            buildUserDetailItem('MATRIC NUMBER', userDetails['matricNumber']),
            buildUserDetailItem('PHONE NUMBER', userDetails['phoneNumber']),
            buildUserDetailItem('EMAIL', userDetails['email']),
            const SizedBox(height: 30),
            // Logout Button
            GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                 builder: (context){
                  return AlertDialog(
                    title: const Text("Confirm Logout"),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: (){
                        Navigator.pop(context); //close the dialog
                      }, 
                      child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: (){
                Provider.of<ApplicationState>(context, listen: false).signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              },
              child:const Text("Logout"),
                      ),
                    ],
                  );
                 },
                );
              },
              child: Container(
                margin: const EdgeInsets.only(top: 24),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 308),
                color: const Color(0xFF41E465),
                child: const Text(
                  'Logout',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUserDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 9, left: 16),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
              fontFamily: 'Inter',
            ),
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 9),
          padding: const EdgeInsets.fromLTRB(21, 6, 21, 6),
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 308),
          color: const Color(0xFFE7E6E6),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
          ),
        ),
      ],
    );
  }
}
