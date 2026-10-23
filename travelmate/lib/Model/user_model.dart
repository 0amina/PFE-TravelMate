import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/Model/property_model.dart';

class UserModel {
  String? id;
  String? email;
  String? password;
  String? name;
  String? state;
  String? city;
  int? phoneNumber;
  String? birthday;
  MemoryImage? photo;

  bool? isHost = false;

  DocumentSnapshot? snapshot;

  List<ReservationModel>? upcomingBookings;
  List<ReservationModel>? pastBookings;
  List<PropertyModel>? myProperties;
  List<PropertyModel>? favProperties;
  List<ReservationModel>? checkingOut = [];
  List<ReservationModel>? currentlyHosting  = [];
  List<ReservationModel>? arrivingSoon  = [];

  UserModel({
    this.id = "",
    this.email = "",
    this.password = "",
    this.name = "",
    this.state,
    this.city,
    this.phoneNumber,
    this.photo,
    this.favProperties = const [],
    this.myProperties = const [],
  }) {
    isHost = false;
    upcomingBookings = [];
    pastBookings = [];
  }

  UserModel createFromUserModel() {
    return UserModel(
      id: AppConstants.currentUser.id,
      name: AppConstants.currentUser.name,
      photo: AppConstants.currentUser.photo,
    );
  }
}
