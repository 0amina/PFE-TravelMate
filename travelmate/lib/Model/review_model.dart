import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/user_model.dart';

class ReviewModel {
  String? id;
  UserModel? traveler;
  PropertyModel? property;
  String? text;
  double? rating;
  Timestamp? createdAt = Timestamp.now();

  ReviewModel({this.id = "", this.rating = 0.0, this.text = "", this.traveler});

  addReview(PropertyModel propertyM, UserModel travelerM) {
    property = propertyM;
    traveler = travelerM;
  }

 

}
