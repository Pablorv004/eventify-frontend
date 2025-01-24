// Import functions and admin SDK
const functions = require('firebase-functions/v1');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

// Execute this function every 10 minutes
exports.sendEventReminderNotification = functions.pubsub
  .schedule('every 10 minutes')
  .onRun(async (context) => {
    // Get the current UTC time
    const currentTimeUTC = new Date().getTime();

    // Adjust to UTC+1 (adding 1 hour in milliseconds)
    const currentTimeInSpain = currentTimeUTC + 60 * 60 * 1000;

    // Define one hour before the event in milliseconds
    const oneHourBeforeEvent = 60 * 60 * 1000;

    try {
      // Obtain all event registrations that are 1 hour before the event
      const eventRegistrationsSnapshot = await admin
        .firestore()
        .collection('event_registrations')
        .where('eventStartTime', '<=', currentTimeInSpain + oneHourBeforeEvent)
        .get();

      // Loop through each event registration document
      for (const doc of eventRegistrationsSnapshot.docs) {
        const registration = doc.data();
        const userId = registration.userId;

        // Obtain the user's FCM token
        const userSnapshot = await admin
          .firestore()
          .collection('users')
          .doc(userId.toString())
          .get();

        if (userSnapshot.exists) {
          const userData = userSnapshot.data();
          const fcmToken = userData.fcmToken;

          // Send the push notification to the user
          const message = {
            notification: {
              title: '¡Remember! The event is about to start!',
              body: 'The event you registered for is starting in 1 hour.',
            },
            token: fcmToken,
          };

          try {
            await admin.messaging().send(message);
            console.log(`Notification sent to the user with ID: ${userId}`);
          } catch (error) {
            console.error('Error while sending notification:', error);
          }
        }
      }
    } catch (error) {
      console.error('Error obtaining events info:', error);
    }
  });
