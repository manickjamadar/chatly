import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';

admin.initializeApp();
const db = admin.firestore();
export const helloWorld = functions.https.onRequest((request, response) => {
    response.send("Hello from Firebase12!");
});

export const sendNotification = functions.firestore.document("messages/{msgId}")
    .onCreate(async (snapshot, context) => {
        try {
            const messageData = snapshot.data();
            if (!messageData) {
                console.log("message data not exists");
                return;
            }
            const receiverId = messageData["receiverId"];
            const senderId = messageData["senderId"];
            const receiverProfileSnapshot = await db.collection("profiles").doc(receiverId).get();
            const receiverProfile = receiverProfileSnapshot.data();
            const senderProfileSnapshot = await db.collection("profiles").doc(senderId).get();
            const senderProfile = senderProfileSnapshot.data();
            if (!receiverProfile || !senderProfile) {
                console.log("receiver profile or senderProfile not exists");
                return;
            }
            const pushToken = receiverProfile["pushToken"];
            if (!pushToken || pushToken === null) {
                console.log("receiver profile push token is not available");
                return;
            }
            const payload: admin.messaging.MessagingPayload = {
                notification: { body: messageData["content"], title: senderProfile["name"], image: senderProfile["avatarUrl"], },
                data: {
                    "isMessageAvailable": "true",
                    "click_action": "FLUTTER_NOTIFICATION_CLICK",
                    "mid": messageData["mid"],
                    "senderId": senderId,
                    "receiverId": receiverId
                }
            }
            await admin.messaging().sendToDevice(pushToken, payload);
        } catch (error) {
            console.log(error);
        }

    })
