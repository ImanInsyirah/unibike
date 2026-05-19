import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:appunibike/app_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _matricNumberController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadUserDetails();
  }

  void _loadUserDetails() async {
    final userDetails = await Provider.of<ApplicationState>(context, listen: false).getUserProfile();
    if (userDetails != null) {
      setState(() {
        _nameController = TextEditingController(text: userDetails['name']);
        _phoneController = TextEditingController(text: userDetails['phoneNumber']);
        _emailController = TextEditingController(text: userDetails['email']);
        _matricNumberController = TextEditingController(text: userDetails['matricNumber']);
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _matricNumberController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      // Update profile in Firestore
      FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
          'name': _nameController.text,
          'phoneNumber': _phoneController.text,
          'matricNumber': _matricNumberController.text,
        })
        .then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile updated successfully')),
          );
          Navigator.pop(context);
        })
        .catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update profile: $error')),
          );
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 480),
            padding: const EdgeInsets.fromLTRB(27, 20, 27, 9),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture
                  Container(
                    width: 127,
                    height: 127,
                    margin: const EdgeInsets.only(bottom: 30),
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
                  
                  // Name Field
                  _buildEditField(
                    label: 'FULL NAME',
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                  ),

                  // Matric Number Field
                  _buildEditField(
                    label: 'MATRIC NUMBER',
                    controller: _matricNumberController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your matric number';
                      }
                      return null;
                    },
                  ),

                  // Phone Number Field
                  _buildEditField(
                    label: 'PHONE NUMBER',
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your phone number';
                      }
                      return null;
                    },
                  ),

                  // Email Field (Read-only as it's a unique identifier)
                  _buildEditField(
                    label: 'EMAIL',
                    controller: _emailController,
                    readOnly: true,
                  ),

                  // Save Button
                  GestureDetector(
                    onTap: _saveProfile,
                    child: Container(
                      margin: const EdgeInsets.only(top: 24),
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 70),
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 308),
                      color: const Color(0xFF41E465),
                      child: const Text(
                        'Save',
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
          ),
        ),
      ),
    );
  }

  Widget _buildEditField({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    bool readOnly = false,
  }) {
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
          constraints: const BoxConstraints(maxWidth: 308),
          child: TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            validator: validator,
            readOnly: readOnly,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              fontFamily: 'Inter',
            ),
            decoration: InputDecoration(
              filled: true,
              fillColor: readOnly ? Colors.grey.shade200 : const Color(0xFFE7E6E6),
              contentPadding: const EdgeInsets.fromLTRB(21, 6, 21, 6),
              border: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(0),
              ),
            ),
          ),
        ),
      ],
    );
  }
}