//login_page.dart
import 'package:flutter/material.dart';
import 'create_account.dart';
import 'home_screen.dart';
import 'package:provider/provider.dart';
import '../app_state.dart';

class LoginScreen extends StatefulWidget {
   @override
  _LoginScreenState createState() => _LoginScreenState();
}
  
class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  
  void _login() async {
    setState(() {
      _isLoading = true;
    });
    try {
      await context.read<ApplicationState>().signIn(
        _emailController.text, 
        _passwordController.text
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e'))
      );
    }finally{
      setState(() {
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 34.0),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 194),
                const Text(
                  'Welcome to\nUni-Bike!',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 86),
                const Text(
                  'EMAIL',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFE7E6E6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter your email',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 6,
                    ),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'PASSWORD',
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 5),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFE7E6E6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Enter your password',
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 17,
                      vertical: 6,
                    ),
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                    :ElevatedButton(
                      onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF41E465),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 7),
                    ),
                    child: const Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 33),
                Row(
                  children: [
                    const Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Inter',
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to CreateAccountScreen when the "Sign Up" text is tapped
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateAccountScreen(),
                          ),
                        );
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: 'Inter',
                          decoration: TextDecoration.underline,
                          color: Color(0xFF0E0BA4),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
