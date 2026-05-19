import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendNotification(String title, String description) async {
  final currentUser = FirebaseAuth.instance.currentUser;
  
  if (currentUser != null) {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'description': description,
      'date': Timestamp.now(),
      'userId': currentUser.uid,
    });
  }
}