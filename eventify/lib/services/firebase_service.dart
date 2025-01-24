// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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
      QuerySnapshot snapshot = await _firestore.collection('event_registrations')
          .where('userId', isEqualTo: userId)
          .where('eventId', isEqualTo: eventId)
          .get();

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
}
