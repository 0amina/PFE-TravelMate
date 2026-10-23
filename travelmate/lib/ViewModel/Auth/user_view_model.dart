import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/Model/user_model.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';
import 'package:travelmate/global.dart';

class UserViewModel with ChangeNotifier{
  UserModel userModel;

  UserViewModel(this.userModel);

  Future<void> updateUserToken() async {
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    if (AppConstants.currentUser.id != null && fcmToken != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AppConstants.currentUser.id)
          .update({'deviceToken': fcmToken});
      print('token: $fcmToken');
    }
  }

  Future<void> getUserReservations() async {
    if (userModel.id == null || userModel.id!.isEmpty) return;

    final userDocRef =
        FirebaseFirestore.instance.collection('users').doc(userModel.id);
    final reservationsQuery = await userDocRef.collection('reservations').get();
    final currentDate = DateTime.now();

    // Clear the existing reservations
    userModel.upcomingBookings?.clear();
    userModel.pastBookings?.clear();

    for (var reservationDoc in reservationsQuery.docs) {
      ReservationModel reservation = ReservationModel();
      reservation.id = reservationDoc.id;
      reservation.property = PropertyModel();

      try {
        reservation.property!.id = reservationDoc['propertyID'];
        reservation.status = reservationDoc['status'];

        PropertyViewModel propertyViewModel =
            PropertyViewModel(reservation.property!);
        await propertyViewModel.getPropertyInfoFromFirestore();

        List<Timestamp> timestamps =
            List<Timestamp>.from(reservationDoc['dates']);
        reservation.dates =
            timestamps.map((timestamp) => timestamp.toDate()).toList();

        if (reservation.dates == null || reservation.dates!.isEmpty) continue;
        DateTime firstDate = reservation.dates!.first;
        if ((currentDate.isBefore(firstDate) ||
                currentDate.isAtSameMomentAs(firstDate)) &&
            reservation.status == 'accepted') {
          userModel.upcomingBookings!.add(reservation);
        } else if (currentDate.isAfter(firstDate) &&
            reservation.status == 'accepted') {
          userModel.pastBookings!.add(reservation);
        }
      } catch (e) {
        print('Error in getUserReservations: $e');
      }
    }
  }

  Future<void> addReservationToMyReservation(
      ReservationModel reservation) async {
    Map<String, dynamic> data = {
      'dates': reservation.dates,
      'propertyID': reservation.property!.id!,
      'paymentMethod': reservation.paymentMethod,
      'totalPrice': reservation.totalPrice,
      'status': reservation.status
    };
    await FirebaseFirestore.instance
        .doc('users/${userModel.id}/reservations/${reservation.id}')
        .set(data);
    //userModel.upcomingBookings!.add(reservation);
  }

  Future<void> getMyPropertiesFromFirestore() async {
    try {
      if (userModel.snapshot == null) {
        throw Exception("User snapshot is null");
      }
      AppConstants.currentUser.myProperties = [];
      List<String> myPropertiesIDs =
          List<String>.from(userModel.snapshot!['myPropertiesIDs'] ?? []);
      print("myPropertiesIDs: $myPropertiesIDs");
      for (String propertyID in myPropertiesIDs) {
        PropertyModel property = PropertyModel(id: propertyID);
        PropertyViewModel propertyViewModel = PropertyViewModel(property);
        await propertyViewModel.getPropertyInfoFromFirestore();
        await propertyViewModel.getAllImagesFromStorage();
        AppConstants.currentUser.myProperties?.add(property);
      }
    } catch (e) {
      print("Error in getMyPropertiesFromFirestore: $e");
      throw e;
    }
  }

  updateUserData(
      name, state, city, phone, birthday, photo, email, context) async {
    String currentUserID = AppConstants.currentUser.id!;
    int phoneNumber = int.parse(phone.text.trim());
    try {
      String photoUrl =
          await signUpViewModel.addImageToFirebaseStorage(photo, currentUserID);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUserID)
          .update({
        'name': name.text.trim(),
        'state': state,
        'city': city,
        'phoneNumber': phoneNumber,
        'birthday': birthday.text.trim(),
        'email': email.text.trim(),
        'photoUrl': photoUrl
      });
      AppConstants.currentUser.email = email.text.trim();
      AppConstants.currentUser.name = name.text.trim();
      AppConstants.currentUser.state = state;
      AppConstants.currentUser.city = city;
      AppConstants.currentUser.phoneNumber = phoneNumber;
      AppConstants.currentUser.photo = MemoryImage(photo.readAsBytesSync());
      AppConstants.currentUser.birthday = birthday.text.trim();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Success'),
            content: const Text('Profile updated successfully'),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Failed to update account: $e');
    }
  }

  addFavouriteProperty(PropertyModel property, bool isFavourite) {
    isFavourite = true;
    for (var favProperty in userModel.favProperties!) {
      if (favProperty.id == property.id) {
        return;
      }
    }
    userModel.favProperties!.add(property);
    List<String> favPropertyIDs = [];
    userModel.favProperties!.forEach((favProperty) {
      favPropertyIDs.add(favProperty.id!);
    });
    FirebaseFirestore.instance.collection("users").doc(userModel.id).update({
      'favPropertyIDs': favPropertyIDs,
    });
  }

  removeFavouriteProperty(PropertyModel property, bool isFavourite) async {
    isFavourite = false;
    for (int i = 0; i < userModel.favProperties!.length; i++) {
      if (userModel.favProperties![i].id == property.id) {
        userModel.favProperties!.removeAt(i);
        break;
      }
    }
    List<String> favPropertyIDs = [];
    userModel.favProperties!.forEach((favProperty) {
      favPropertyIDs.add(favProperty.id!);
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(userModel.id)
        .update({
      'favPropertyIDs': favPropertyIDs,
    });
  }

  Future<void> addPropertyToMyPropertiesIDs(PropertyModel property) async {
    AppConstants.currentUser.myProperties!.add(property);
    String propertyID = property.id!;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(AppConstants.currentUser.id)
          .update({
        'myPropertiesIDs': FieldValue.arrayUnion([propertyID])
      });
      print("Successfully added property ID: $propertyID to user's properties");
    } catch (e) {
      print("Error adding property ID to user's properties: $e");
    }
  }

  bool isSameDate(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

Future<void> categorizeReservations() async {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  AppConstants.currentUser.checkingOut!.clear();
  AppConstants.currentUser.currentlyHosting!.clear();
  AppConstants.currentUser.arrivingSoon!.clear();

  for (var property in AppConstants.currentUser.myProperties ?? []) {
    PropertyViewModel propertyVM = PropertyViewModel(property);
    await propertyVM.getAllBookingsFromFirestore(); // Wait for reservations to be fetched
    print(property.reservations);
    for (var reservation in property.reservations ?? []) {
      if (reservation.dates != null && reservation.dates!.isNotEmpty) {
        print(reservation);
        DateTime firstDate = DateTime(
          reservation.dates!.first.year,
          reservation.dates!.first.month,
          reservation.dates!.first.day,
        );
        DateTime lastDate = DateTime(
          reservation.dates!.last.year,
          reservation.dates!.last.month,
          reservation.dates!.last.day,
        );
        print("First Date: $firstDate, Last Date: $lastDate");
        print("Today: $today, Tomorrow: $tomorrow, Yesterday: $yesterday");

        if (isSameDate(firstDate, tomorrow)) {
          AppConstants.currentUser.arrivingSoon!.add(reservation);
        }
        if (isSameDate(lastDate, yesterday)) {
          AppConstants.currentUser.checkingOut!.add(reservation);
        }
        if (reservation.dates!.any((date) => isSameDate(DateTime(date.year, date.month, date.day), today))) {
          AppConstants.currentUser.currentlyHosting!.add(reservation);
        }
      }
    }
  }

  print("Arriving Soon: ${AppConstants.currentUser.arrivingSoon}");
  print("Checking Out: ${AppConstants.currentUser.checkingOut}");
  print("Currently Hosting: ${AppConstants.currentUser.currentlyHosting}");
}
  
  Future<void> addBankInfo(String cardNumber, String expiryDate, String cardHolderName, String cvvCode) async {
    if (userModel.id == null || userModel.id!.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userModel.id)
          .collection('bankInfo')
          .add({
        'cardNumber': cardNumber,
        'expiryDate': expiryDate,
        'cardHolderName': cardHolderName,
        'cvvCode': cvvCode,
      });
    } catch (e) {
      print("Error in addBankInfo: $e");
    }
  }

}
