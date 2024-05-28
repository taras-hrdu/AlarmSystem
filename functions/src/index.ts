import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import {
  MessagingPayload,
  MessagingOptions,
} from "firebase-admin/lib/messaging/messaging-api";

admin.initializeApp();

export const sendNotifications = functions.firestore
.document('users/{userId}/devices/{deviceId}/events/{eventId}')
.onCreate(
    async (snapshot, context) => {
      const userId: string = context.params.userId;
      const text: string = "Received new audio";
      const title: string = 'New message';

      console.log('userId: ', userId);

      const payload: MessagingPayload = {
        notification: {
          title: title,
          body: text,
          sound: "default",
        },
        data: {
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
      };

      const options: MessagingOptions = {
        contentAvailable: true,
        priority: "high",
      };

      try {
        await admin.messaging().sendToTopic(userId, payload, options);

        console.log("Notification sent");

        return { status: 200 };
      } catch (e: any) {
        console.log(e.toString());
        return { status: 401 };
      }
    }
);
