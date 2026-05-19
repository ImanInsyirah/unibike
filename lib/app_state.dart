
//app_state.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ApplicationState extends ChangeNotifier {
  User? currentUser;
  bool get isLoggedIn => currentUser != null;

  ApplicationState() {
    _initAuthListener();
  }

  void _initAuthListener() {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      currentUser = user;
      notifyListeners();
    });
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String name,
    required String matricNumber,
    required String phoneNumber,
  }) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .set({
        'name': name,
        'matricNumber': matricNumber,
        'phoneNumber': phoneNumber,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        throw Exception('This email is already registered.');
      } else if (e.code == 'weak-password') {
        throw Exception('The password is too weak.');
      } else {
        throw Exception('An unknown error occurred.');
      }
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

    //check if email is verified
   /* if (userCredential.user != null && !userCredential.user!.emailVerified) {
      throw Exception('Please verify your email before logging in.');
    }*/
      currentUser = userCredential.user;

      // Optionally fetch user profile
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (userDoc.exists) {
        print('User profile: ${userDoc.data()}');
      }
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Exception('Incorrect password.');
      } else {
        throw Exception('An unknown error occurred.');
      }
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    currentUser = null;
    notifyListeners();
  }

  Future<Map<String, dynamic>?> getUserProfile() async {
    if (currentUser == null) return null;

    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();

    if(userDoc.exists){
      notifyListeners();
      return userDoc.data() as Map<String, dynamic>;
    }

    return null;
  }
}
