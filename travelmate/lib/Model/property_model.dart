import 'package:flutter/material.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/Model/review_model.dart';
import 'package:travelmate/Model/user_model.dart';

class PropertyModel {
  String? id;
  String? title;
  String? description;
  String? category;
  String? type;
  int? bedrooms;
  int? beds;
  int? bathrooms;
  List<String>? amenities;
  String? country;
  String? city;
  String? state;
  String? streetAddress;
  String? postalCode;
  double? price;
  double? rating;

  UserModel? host;
  List<String>? photos;
  List<MemoryImage>? displayImages;
  List<ReservationModel>? reservations = [];
  List<ReviewModel>? reviews = [];

  PropertyModel({this.id = "",
    this.title = "",
    this.description = "",
    this.category = "",
    this.type = "",
    this.bedrooms = 1,
    this.beds = 1,
    this.bathrooms = 1,
    this.country = "",
    this.city = "",
    this.state = "",
    this.streetAddress = "",
    this.postalCode = "",
    this.price = 0,
    this.host,
    this.displayImages,
    this.amenities = const [],
    this.photos = const [],
    this.rating = 0,
    this.reviews = const [],
    this.reservations = const [],
  });
void updateAverageRating() {
    if (reviews != null && reviews!.isNotEmpty) {
      double totalRating = reviews!.fold(0, (sum, review) => sum + (review.rating ?? 0));
      rating = totalRating / reviews!.length;
    } else {
      rating = 0;
    }
  }

  factory PropertyModel.empty() {
    return PropertyModel(id: '', title: '');
  }
  List<DateTime> getAllBookedDates() {
    List<DateTime> dates = [];
    reservations!.forEach((reservation) {
      dates.addAll(reservation.dates!);
    });
    return dates;
  }

  factory PropertyModel.fromFirestore(Map<String, dynamic> firestoreDoc) {
    return PropertyModel(
      id: firestoreDoc['id'],
      title: firestoreDoc['title'],
      description: firestoreDoc['description'],
      category: firestoreDoc['category'],
      type: firestoreDoc['type'],
      bedrooms: firestoreDoc['bedrooms'] as int?,
      beds: firestoreDoc['beds'] as int?,
      bathrooms: firestoreDoc['bathrooms'] as int?,
      amenities: List<String>.from(firestoreDoc['amenities'] ?? []),
      country: firestoreDoc['country'],
      city: firestoreDoc['city'],
      state: firestoreDoc['state'],
      streetAddress: firestoreDoc['streetAddress'],
      postalCode: firestoreDoc['postalCode'],
      price: (firestoreDoc['price'] is int) ? (firestoreDoc['price'] as int).toDouble() : firestoreDoc['price'] as double?,
      rating: (firestoreDoc['rating'] is int) ? (firestoreDoc['rating'] as int).toDouble() : firestoreDoc['rating'] as double?,
      // assuming photos are stored as a list of strings
      photos: List<String>.from(firestoreDoc['property_photos'] ?? []),
      // other properties...
    );
  }

}
