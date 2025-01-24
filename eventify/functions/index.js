/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const { onRequest } = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

// Execute this function every 1 minute
exports.sendEventReminderNotification = functions.pubsub.schedule('every 10 minute').onRun(async (context) => {
    const currentTime = new Date().getTime();
    const oneHourBeforeEvent = 60 * 60 * 1000;

    // Obtain all event registrations that are 1 hour before the event
    const eventRegistrationsSnapshot = await admin.firestore()
        .collection('event_registrations')
        .where('eventStartTime', '<=', currentTime + oneHourBeforeEvent)
        .get();

    eventRegistrationsSnapshot.forEach(async (doc) => {
        const registration = doc.data();
        const userId = registration.userId;
        const eventId = registration.eventId;

        // Obtain the user's FCM token
        const userSnapshot = await admin.firestore()
            .collection('users')
            .doc(userId.toString())
            .get();

        if (userSnapshot.exists) {
            const userData = userSnapshot.data();
            const fcmToken = userData.fcmToken;

            // Send the push notification to the user
            const message = {
                notification: {
                    title: 'Remember! The event is going to start soon!',
                    body: `The event is going to start in 1 hour. ¡Don't miss it!`,
                },
                token: fcmToken,
            };

            try {
                await admin.messaging().send(message);
                console.log(`Notification sent to the user: ${userId}`);
            } catch (error) {
                console.error('Error sending the notification:', error);
            }
        }
    });
});