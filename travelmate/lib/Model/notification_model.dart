import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/Model/user_model.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';
import 'package:travelmate/ViewModel/reservation_view_model.dart';

class NotifModel {
  String? id;
  UserModel? traveler;
  UserModel? host;
  String? text;
  bool? readStatus;
  Timestamp? createdAt;
  String? phoneToken;
  PropertyModel? property;
  ReservationModel? reservation;

  NotifModel({
    this.id,
    this.traveler,
    this.host,
    this.text,
    this.readStatus = false,
    this.createdAt,
    this.phoneToken,
    this.property,
    this.reservation,
  });

  static Future<NotifModel> fromFirestore(DocumentSnapshot doc) async {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  PropertyModel property = PropertyModel(id: data['propertyId']);
  ReservationModel reservationn = ReservationModel(id: data['reservationId']);

  PropertyViewModel propertyVm = PropertyViewModel(property);
  ReservationViewModel reservationVm = ReservationViewModel(reservationn);

  // Attempt to get property info from Firestore
  try {
    await propertyVm.getPropertyInfoFromFirestore();
  } catch (e) {
    print("Property not found, using empty property model.");
    property = PropertyModel.empty();
  }

  // Attempt to get reservation info from Firestore
  DocumentSnapshot reservationSnapshot = await FirebaseFirestore.instance
      .collection('properties')
      .doc(property.id)
      .collection('reservations')
      .doc(reservationn.id)
      .get();

  if (reservationSnapshot.exists) {
    await reservationVm.getReservationInfoFromFirestoreFromProperty(
        property, reservationSnapshot);
  } else {
    print("Reservation not found, using empty reservation model.");
    reservationn = ReservationModel.empty();
  }

  return NotifModel(
    id: doc.id,
    traveler: reservationn.traveler,
    host: UserModel(id: data['hostId']),
    text: data['text'],
    readStatus: data['readStatus'],
    createdAt: data['createdAt'],
    phoneToken: data['phoneToken'],
    property: property,
    reservation: reservationn,
  );
}


  static Future<NotifModel> fromFirestoreFromUser(DocumentSnapshot doc) async {
  Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

  // Create PropertyModel and ReservationModel with initial data
  PropertyModel property = PropertyModel(id: data['propertyId']);
  ReservationModel reservationn = ReservationModel(id: data['reservationId']);
  UserModel travelerr = UserModel(id: data['travelerId']);

  // Create ViewModels
  PropertyViewModel propertyVm = PropertyViewModel(property);
  ReservationViewModel reservationVm = ReservationViewModel(reservationn);

  // Attempt to get property info from Firestore
  try {
    await propertyVm.getPropertyInfoFromFirestore();
  } catch (e) {
    print("Property not found, using empty property model.");
  }

  // Attempt to get reservation info from Firestore
  DocumentSnapshot reservationSnapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(travelerr.id)
      .collection('reservations')
      .doc(reservationn.id)
      .get();

  if (reservationSnapshot.exists) {
    await reservationVm.getReservationInfoFromFirestoreFromTraveler(
        travelerr, reservationSnapshot);
  } else {
    print("Reservation not found, using empty reservation model.");
  }

  return NotifModel(
    id: doc.id,
    traveler: reservationn.traveler,
    host: UserModel(id: data['hostId']),
    text: data['text'],
    readStatus: data['readStatus'],
    createdAt: data['createdAt'],
    phoneToken: data['phoneToken'],
    property: property,
    reservation: reservationn,
  );
}


  Map<String, dynamic> toMap() {
    return {
      'travelerId': traveler!.id,
      'hostId': host!.id,
      'text': text,
      'readStatus': readStatus,
      'createdAt': createdAt,
      'phoneToken': phoneToken,
      'propertyId': property?.id,
      'reservationId': reservation?.id,
    };
  }
}