import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/Model/user_model.dart';
import 'package:travelmate/Model/property_model.dart';

class ReservationModel {
  String? id;
  PropertyModel? property;
  UserModel? traveler;
  List<DateTime>? dates = [];
  Timestamp? createdAt;
  int? nbGuests;
  double? totalPrice;
  String? paymentMethod;
  String? status;

  ReservationModel({
    this.id = "",
    this.traveler,
    this.property,
    this.dates = const [],
    this.nbGuests = 0,
    this.totalPrice = 0.0,
    this.paymentMethod = "",
    this.status = "pending",
  });

  int calculateNumberOfNights(DateTime fromDate, DateTime toDate) {
    return toDate.difference(fromDate).inDays;
  }

  createReservation(
      PropertyModel propertyM, UserModel travelerM, List<DateTime> dateM) {
    property = propertyM;
    traveler = travelerM;
    dates = dateM;
    dates!.sort();
  }

   factory ReservationModel.empty() {
    return ReservationModel(id: '', status: 'pending');
  }
}