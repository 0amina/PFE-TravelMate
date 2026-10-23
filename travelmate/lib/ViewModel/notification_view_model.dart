import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/notification_model.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/Model/user_model.dart';

Future<void> handleBackgroundMessages(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class NotificationViewModel with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('token: $fCMToken');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessages);
  }

  Future<void> sendNotificationToHost(
      UserModel host,
      ReservationModel reservation,
      PropertyModel property,
      String message) async {
    var hostDoc =
        await FirebaseFirestore.instance.collection('users').doc(host.id).get();
    String? hostToken = hostDoc.data()?['deviceToken'];

    var notification = NotifModel(
      traveler: AppConstants.currentUser,
      host: host,
      text: message,
      createdAt: Timestamp.now(),
      phoneToken: hostToken,
      property: property,
      reservation: reservation,
    );

    await FirebaseFirestore.instance
        .collection('notifications')
        .add(notification.toMap());

    if (notification.phoneToken != null) {
      await _firebaseMessaging.sendMessage(
        to: hostToken,
        data: {
          'title': 'New Reservation',
          'body': message,
        },
      );
    }
  }

  Stream<List<NotifModel>> getHostNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('hostId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<NotifModel> notifications = [];
      for (var doc in snapshot.docs) {
        NotifModel notification = await NotifModel.fromFirestore(doc);
        if (notification.text != null &&
            notification.text!.contains('New reservation for your property')) {
          notifications.add(notification);
        }
      }
      return notifications;
    });
  }

  Stream<int> getUnreadHostNotificationsCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('hostId', isEqualTo: userId)
        .where('readStatus', isEqualTo: false)
        .snapshots()
        .asyncMap((snapshot) async {
      int count = 0;
      for (var doc in snapshot.docs) {
        NotifModel notification = await NotifModel.fromFirestore(doc);
        if (notification.text != null &&
            notification.text!.contains('New reservation for your property')) {
          count++;
        }
      }
      return count;
    });
  }

  Stream<List<NotifModel>> getTravelerNotifications(String userId) {
    return _firestore
        .collection('notifications')
        .where('travelerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<NotifModel> notifications = [];
      for (var doc in snapshot.docs) {
        NotifModel notification = await NotifModel.fromFirestoreFromUser(doc);
        if (notification.text != null &&
            notification.text!.contains('Your reservation for property')) {
          notifications.add(notification);
        }
      }
      return notifications;
    });
  }

  Stream<int> getUnreadTravelerNotificationsCount(String userId) {
    return _firestore
        .collection('notifications')
        .where('travelerId', isEqualTo: userId)
        .where('readStatus', isEqualTo: false)
        .snapshots()
        .asyncMap((snapshot) async {
      int count = 0;
      for (var doc in snapshot.docs) {
        NotifModel notification = await NotifModel.fromFirestore(doc);
        if (notification.text != null &&
            notification.text!.contains('Your reservation for property')) {
          count++;
        }
      }
      return count;
    });
  }

  Future<void> acceptReservation(NotifModel notification) async {
    var reservation = notification.reservation!;

    await FirebaseFirestore.instance
        .collection('properties')
        .doc(reservation.property!.id)
        .collection('reservations')
        .doc(reservation.id)
        .update({'status': 'accepted'});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(reservation.traveler!.id)
        .collection('reservations')
        .doc(reservation.id)
        .update({'status': 'accepted'});

    UserModel traveler = reservation.traveler!;
    String message =
        'Your reservation for property "${reservation.property!.title}" has been accepted';
    await sendNotificationToTraveler(
        traveler, message, reservation.property!, reservation);

    // Delete the notification after 10 seconds
    Future.delayed(Duration(seconds: 5), () async {
      await deleteNotification(notification.id!);
    });
  }

  Future<void> refuseReservation(NotifModel notification) async {
    var reservation = notification.reservation!;

    await FirebaseFirestore.instance
        .collection('properties')
        .doc(reservation.property!.id)
        .collection('reservations')
        .doc(reservation.id)
        .update({'status': 'refused', 'dates': []});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(reservation.traveler!.id)
        .collection('reservations')
        .doc(reservation.id)
        .update({'status': 'refused', 'dates': []});

    UserModel traveler = reservation.traveler!;

    String message =
        'Your reservation for property "${reservation.property!.title}" has been refused';

    await sendNotificationToTraveler(
        traveler, message, reservation.property!, reservation);

    // Delete the notification after 10 seconds
    Future.delayed(Duration(seconds: 5), () async {
      await deleteNotification(notification.id!);
    });
  }

  Future<void> sendNotificationToTraveler(UserModel traveler, String message,
      PropertyModel property, ReservationModel reservation) async {
    var travelerDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(traveler.id)
        .get();
    String? travelerToken = travelerDoc.data()?['deviceToken'];

    var notification = NotifModel(
      traveler: traveler,
      host: AppConstants.currentUser,
      text: message,
      createdAt: Timestamp.now(),
      phoneToken: travelerToken,
      property: property,
      reservation: reservation,
    );

    await FirebaseFirestore.instance
        .collection('notifications')
        .add(notification.toMap());

    if (notification.phoneToken != null) {
      await _firebaseMessaging.sendMessage(
        to: travelerToken,
        data: {
          'title': 'Reservation Update',
          'body': message,
        },
      );
    }
  }

  Future<void> markNotificationAsRead(NotifModel notification) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notification.id)
        .update({'readStatus': true});
    notification.readStatus = true;
    notifyListeners();
  }

  Future<void> deleteNotification(String notificationId) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(notificationId)
        .delete();
  }
}