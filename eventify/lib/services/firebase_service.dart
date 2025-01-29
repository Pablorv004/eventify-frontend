// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Registers an event in firestore
  Future<void> registerUserToEventInFirebase(int userId, int eventId, DateTime eventStartTime) async {
    try {
      // Access the collection of user registrations for events
      await _firestore.collection('event_registrations').add({
        'userId': userId,
        'eventId': eventId,
        'eventStartTime': eventStartTime,
        'registeredAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print("Error while registering the event at firebase: $e");
      throw Exception("Error while registering the event at firebase");
    }
  }

  // Unregister an event in firestore
  Future<void> unregisterUserFromEventInFirebase(int userId, int eventId) async {
    try {
      // Access the collection of user registrations for events
      // This method gets all the documents that match the query inside the collection
      QuerySnapshot snapshot = await _firestore.collection('event_registrations').where('userId', isEqualTo: userId).where('eventId', isEqualTo: eventId).get();

      // Check if the registration exists
      if (snapshot.docs.isNotEmpty) {
        // If there's registrations from the user to that event, delete them
        for (var doc in snapshot.docs) {
          await doc.reference.delete();
        }

        print("User unregistered from event successfully.");
      } else {
        print("No registration found for user $userId to event $eventId.");
      }
    } catch (e) {
      print("Error while unregistering the event at firebase: $e");
      throw Exception("Error while unregistering the event at firebase");
    }
  }

  // Get the FCM token for the user and save it to Firestore
  Future<void> getFCMToken(int userId) async {
    // Obtain the FCM token
    String? token = await _firebaseMessaging.getToken();

    if (token != null) {
      print('FCM Token: $token');

      // Save the token to Firestore
      await _saveTokenToFirestore(token, userId);
    }
  }

  // Save the FCM token to Firestore
  Future<void> _saveTokenToFirestore(String token, int userId) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId.toString()).set({
        'fcmToken': token,
      }, SetOptions(merge: true));

      print('Token saved to Firestore');
    } catch (e) {
      print('Error saving token to Firestore: $e');
    }
  }
}
