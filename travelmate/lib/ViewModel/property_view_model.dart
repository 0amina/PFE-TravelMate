import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/Model/review_model.dart';
import 'package:travelmate/Model/user_model.dart';
import 'package:travelmate/ViewModel/reservation_view_model.dart';
import 'package:travelmate/ViewModel/review_view_model.dart';
import 'package:travelmate/global.dart';
import 'package:travelmate/ViewModel/notification_view_model.dart';

class PropertyViewModel {
  PropertyModel propertyModel;

  PropertyViewModel(this.propertyModel);

  Future<void> getPropertyInfoFromFirestore() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyModel.id)
          .get();
      if (snapshot.exists && snapshot.data() != null) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        propertyModel.title = data['title'] ?? "";
        propertyModel.description = data['description'] ?? "";
        propertyModel.category = data['category'] ?? "";
        propertyModel.type = data['type'] ?? "";
        propertyModel.bedrooms = (data['bedrooms'] ?? 1) as int;
        propertyModel.beds = (data['beds'] ?? 1) as int;
        propertyModel.bathrooms = (data['bathrooms'] ?? 1) as int;
        propertyModel.amenities = List<String>.from(data['amenities'] ?? []);
        propertyModel.country = data['country'] ?? "";
        propertyModel.city = data['city'] ?? "";
        propertyModel.state = data['state'] ?? "";
        propertyModel.streetAddress = data['streetAddress'] ?? "";
        propertyModel.postalCode = data['postalCode'] ?? "";

        // Handle price conversion
        var price = data['price'];
        if (price is int) {
          propertyModel.price = price.toDouble();
        } else if (price is double) {
          propertyModel.price = price;
        } else {
          propertyModel.price = 0.0;
        }
        // Handle rating conversion
        var rating = data['rating'];
        if (rating is int) {
          propertyModel.rating = rating.toDouble();
        } else if (rating is double) {
          propertyModel.rating = rating;
        } else {
          propertyModel.rating = 2.5;
        }
        propertyModel.photos = List<String>.from(data['property_photos'] ?? []);
        String hostID = snapshot['hostID'] ?? "";
        propertyModel.host = UserModel(id: hostID);

        await getHostFromFirestore(hostID);
        await getAllReviewsFromFirestore();
        propertyModel.updateAverageRating();
      } else {
        throw Exception("Snapshot data is null or does not exist");
      }
    } catch (e) {
      print("Error in getPropertyInfoFromFirestore: $e");
      throw e;
    }
  }

  Future<void> getAllBookingsFromFirestore() async {
    propertyModel.reservations = [];
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyModel.id)
        .collection('reservations')
        .get();
    for (var snapshot in snapshots.docs) {
      ReservationModel newReservation = ReservationModel();
      ReservationViewModel reservationVM = ReservationViewModel(newReservation);
      await reservationVM.getReservationInfoFromFirestoreFromProperty(
          propertyModel, snapshot);
      propertyModel.reservations!.add(newReservation);
    }
  }

  Future<void> makeNewBooking(List<DateTime> dates, context) async {
    Map<String, dynamic> dataMap = {
      'dates': dates,
      'name': AppConstants.currentUser.name,
      'userID': AppConstants.currentUser.id,
      'createdAt': reservationModel.createdAt,
      'numberOfGuests': reservationModel.nbGuests,
      'totalPrice': bookingPrice,
      'paymentMethod': reservationModel.paymentMethod,
      'status': 'pending',
    };

    DocumentReference ref = await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyModel.id)
        .collection('reservations')
        .add(dataMap);
    ReservationModel newReservation = ReservationModel();
    newReservation.createReservation(
        propertyModel, AppConstants.currentUser.createFromUserModel(), dates);
    newReservation.id = ref.id;
    newReservation.paymentMethod = reservationModel.paymentMethod;
    newReservation.totalPrice = bookingPrice;
    propertyModel.reservations!.add(newReservation);
    await userViewModel.addReservationToMyReservation(newReservation);
    // Send notification to the host
    UserModel host = propertyModel.host!;
    String message =
        'New reservation for your property "${propertyModel.title}"';
    await NotificationViewModel()
        .sendNotificationToHost(host, newReservation, propertyModel, message);
  }

  Future<void> getAllReviewsFromFirestore() async {
    propertyModel.reviews = [];
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyModel.id)
        .collection('reviews')
        .get();
    for (var snapshot in snapshots.docs) {
      ReviewModel newReview = ReviewModel();
      ReviewViewModel reviewVM = ReviewViewModel(newReview);
      await reviewVM.getReviewInfoFromFirestoreFromProperty(
          propertyModel, snapshot);
      propertyModel.reviews!.add(newReview);
    }
  }

  Future<void> getHostFromFirestore(String hostID) async {
    try {
      DocumentSnapshot hostSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(hostID)
          .get();
      Map<String, dynamic> hostData =
          hostSnapshot.data() as Map<String, dynamic>;
      propertyModel.host!.name = hostData['name'];
      propertyModel.host!.phoneNumber = hostData['phoneNumber'];
      final imageDataInBytes = await FirebaseStorage.instance
          .ref()
          .child("profile_photos")
          .child(hostID)
          .child(hostID + ".png")
          .getData(1024 * 1024);
      propertyModel.host!.photo = MemoryImage(imageDataInBytes!);
    } catch (e) {
      print("Error in getHostInfo: $e");
      throw e;
    }
  }

  Future<void> addReview(context) async {
    Map<String, dynamic> dataMap = {
      'name': AppConstants.currentUser.name,
      'travelerID': AppConstants.currentUser.id,
      'createdAt': reviewModel.createdAt,
      'rating': reviewModel.rating,
      'text': reviewModel.text,
    };

    DocumentReference ref = await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyModel.id)
        .collection('reviews')
        .add(dataMap);
    ReviewModel newReview = ReviewModel();
    newReview.addReview(
        propertyModel, AppConstants.currentUser.createFromUserModel());
    reviewModel.id = ref.id;
    propertyModel.reviews!.add(reviewModel);
  }

  Future<void> getAllImagesFromStorage() async {
    propertyModel.displayImages = [];
    if (propertyModel.photos == null || propertyModel.photos!.isEmpty) {
      print("No photos to retrieve.");
      return;
    }
    for (int i = 0; i < propertyModel.photos!.length; i++) {
      try {
        final imageData = await FirebaseStorage.instance
            .ref()
            .child("property_photos")
            .child(propertyModel.id!)
            .child('image${i}.png')
            .getData(1024 * 1024);
        propertyModel.displayImages!.add(MemoryImage(imageData!));
        print("Retrieved image: image${i}.png");
      } catch (e) {
        print('Error retrieving image: $e');
      }
    }
  }

  Future<bool> uploadImagesAndSetPaths() async {
    if (propertyModel.id == null || propertyModel.id!.isEmpty) {
      print("Error: propertyModel.id is null or empty");
      return false;
    }

    propertyModel.photos = [];

    for (int i = 0; i < propertyModel.displayImages!.length; i++) {
      String imagePath = 'property_photos/${propertyModel.id}/image${i}.png';
      Reference ref = FirebaseStorage.instance.ref().child(imagePath);
      try {
        UploadTask uploadTask = ref.putData(
          propertyModel.displayImages![i].bytes,
          SettableMetadata(contentType: 'image/png'),
        );
        await uploadTask.whenComplete(() {});
        String downloadUrl = await ref.getDownloadURL();
        propertyModel.photos!.add(downloadUrl);
        print("Uploaded image: $downloadUrl");
      } catch (e) {
        print('Error uploading image: $e');
        return false;
      }
    }

    // Update property_photos field in Firestore after uploading all images
    await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyModel.id)
        .update({'property_photos': propertyModel.photos});

    return true;
  }

  Future<bool> addPropertyInfoToFirestore() async {
    try {
      Map<String, dynamic> dataMap = {
        'hostID': AppConstants.currentUser.id,
        'title': propertyModel.title,
        'description': propertyModel.description,
        'category': propertyModel.category,
        'type': propertyModel.type,
        'bedrooms': propertyModel.bedrooms,
        'beds': propertyModel.beds,
        'bathrooms': propertyModel.bathrooms,
        'amenities': propertyModel.amenities,
        'country': propertyModel.country,
        'city': propertyModel.city,
        'state': propertyModel.state,
        'streetAddress': propertyModel.streetAddress,
        'postalCode': propertyModel.postalCode,
        'price': propertyModel.price,
        'rating': 3.5,
        'property_photos': [],
        'reservationIDs': [],
        'reviewsIDs': [],
      };

      DocumentReference ref = await FirebaseFirestore.instance
          .collection('properties')
          .add(dataMap);
      propertyModel.id = ref.id;
      bool uploadSuccess = await uploadImagesAndSetPaths();
      if (!uploadSuccess) return false;

      await userViewModel.addPropertyToMyPropertiesIDs(propertyModel);
      return true;
    } catch (e) {
      print("Error adding property to Firestore: $e");
      return false;
    }
  }

  Future<bool> deleteProperty() async {
    try {
      List<DateTime> bookedDates = propertyModel.getAllBookedDates();
      DateTime today = DateTime.now();

      bool hasUpcomingReservations =
          bookedDates.any((date) => date.isAfter(today));

      if (hasUpcomingReservations) {
        return Future.error(
            "It's impossible to delete the property because there are upcoming reservations for that property. If you want to delete it, keep on refusing reservations in the future.");
      }

      // Delete reservations collection
      QuerySnapshot reservationsSnapshot = await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyModel.id)
          .collection('reservations')
          .get();

      for (DocumentSnapshot reservation in reservationsSnapshot.docs) {
        await reservation.reference.delete();
      }

      // Delete the property document
      await FirebaseFirestore.instance
          .collection('properties')
          .doc(propertyModel.id)
          .delete();

      // Update the user's property IDs
      await FirebaseFirestore.instance
          .collection('users')
          .doc(AppConstants.currentUser.id)
          .update({
        'myPropertiesIDs': FieldValue.arrayRemove([propertyModel.id])
      });

      return true;
    } catch (e) {
      print('Error deleting property: $e');
      return false;
    }
  }
Future<bool> updatePropertyInfoInFirestore() async {
  try {
    Map<String, dynamic> dataMap = {
      'title': propertyModel.title,
      'description': propertyModel.description,
      'category': propertyModel.category,
      'type': propertyModel.type,
      'bedrooms': propertyModel.bedrooms,
      'beds': propertyModel.beds,
      'bathrooms': propertyModel.bathrooms,
      'amenities': propertyModel.amenities,
      'country': propertyModel.country,
      'city': propertyModel.city,
      'state': propertyModel.state,
      'streetAddress': propertyModel.streetAddress,
      'postalCode': propertyModel.postalCode,
      'price': propertyModel.price,
      'rating': propertyModel.rating,
      'property_photos': propertyModel.photos,
    };

    await FirebaseFirestore.instance
        .collection('properties')
        .doc(propertyModel.id)
        .update(dataMap);

    bool uploadSuccess = await uploadImagesAndSetPaths();
    if (!uploadSuccess) return false;

    return true;
  } catch (e) {
    print("Error updating property in Firestore: $e");
    return false;
  }
}

  updateProperty(PropertyModel property) {}
}
