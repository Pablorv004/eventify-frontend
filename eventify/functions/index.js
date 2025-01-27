// Import functions and admin SDK
const functions = require('firebase-functions/v1');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

// Execute this function every minute
exports.sendEventReminderNotification = functions.pubsub
  .schedule('every 10 minutes')
  .onRun(async (context) => {
    const currentTimeUTC = new Date().getTime(); // Get current time in UTC

    // Adjust to UTC+1 for reference if necessary (just for logging)
    const currentTimeInSpain = currentTimeUTC + 60 * 60 * 1000; // 1 hour ahead for Spain (UTC+1)
    const oneHourFromNow = currentTimeInSpain + 60 * 60 * 1000;

    console.log(`Current server time (UTC): ${new Date(currentTimeUTC).toISOString()}`);
    console.log(`Adjusted time (UTC+1): ${new Date(currentTimeInSpain).toISOString()}`);
    console.log(`Query range (UTC+1): [${new Date(currentTimeInSpain).toISOString()} - ${new Date(oneHourFromNow).toISOString()}]`);

    // Query range should be in UTC (not UTC+1)
    const currentTimeInUTC = currentTimeUTC; // Current time in UTC
    const oneHourFromNowInUTC = currentTimeInUTC + 60 * 60 * 1000;

    // Query for events happening in the next hour in UTC time
    try {
      const eventRegistrationsSnapshot = await admin
        .firestore()
        .collection('event_registrations')
        .where('eventStartTime', '>=', admin.firestore.Timestamp.fromMillis(currentTimeInUTC))
        .where('eventStartTime', '<=', admin.firestore.Timestamp.fromMillis(oneHourFromNowInUTC))
        .get();

      if (eventRegistrationsSnapshot.empty) {
        console.log('No events found in the specified time range.');
        return null;
      }

      console.log(`Found ${eventRegistrationsSnapshot.size} events.`);

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
        } else {
          console.log(`User with ID ${userId} does not exist in the database.`);
        }
      }
    } catch (error) {
      console.error('Error obtaining event registrations:', error);
    }
  });
