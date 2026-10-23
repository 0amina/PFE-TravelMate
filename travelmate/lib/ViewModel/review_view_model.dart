import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/review_model.dart';
import 'package:travelmate/Model/user_model.dart';

class ReviewViewModel {
  ReviewModel reviewModel;

  ReviewViewModel(this.reviewModel);

   getReviewInfoFromFirestoreFromProperty(
      PropertyModel property, DocumentSnapshot snapshot) async {
    reviewModel.property = property;
    reviewModel.id = snapshot.id;
    reviewModel.text = snapshot['text'];
    reviewModel.rating = snapshot['rating'];
    String TravelerID = snapshot['travelerID'] ?? "";
    String name = snapshot['name'] ?? "";

    reviewModel.traveler = UserModel(id: TravelerID);
    loadTravelerInfo(TravelerID, name);
  }

  loadTravelerInfo(String travelerID, String name) async {
    final imageDataInBytes = await FirebaseStorage.instance
        .ref()
        .child("profile_photos")
        .child(travelerID)
        .child(travelerID + ".png")
        .getData(1024 * 1024);
    reviewModel.traveler!.photo = MemoryImage(imageDataInBytes!);
    reviewModel.traveler = UserModel(id: travelerID, name: name, photo: reviewModel.traveler!.photo);
  }

}
