import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'success_signup.dart';
import '../app_state.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _matricController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  void _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await context.read<ApplicationState>().signUp(
          email: _emailController.text,
          password: _passwordController.text,
          name: _nameController.text,
          matricNumber: _matricController.text,
          phoneNumber: _phoneController.text,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CongratulationsScreen()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sign up failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 480),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 34, vertical: 118),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 46,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 56),
                _buildFormField(
                  label: 'FULL NAME',
                  controller: _nameController,
                  validator: (value) =>
                      value?.isEmpty ?? true ? 'Please enter your name' : null,
                ),
                _buildFormField(
                  label: 'MATRIC NUMBER',
                  controller: _matricController,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter matric number'
                      : null,
                ),
                _buildFormField(
                  label: 'EMAIL',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter your email'
                      : null,
                ),
                _buildFormField(
                  label: 'PHONE NUMBER',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter phone number'
                      : null,
                ),
                _buildFormField(
                  label: 'PASSWORD',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) => value?.isEmpty ?? true
                      ? 'Please enter password'
                      : null,
                ),
                const SizedBox(height: 27),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF41E465),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
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

  Widget _buildFormField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
    bool obscureText = false,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 9),
          TextFormField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            validator: validator,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE7E6E6),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
