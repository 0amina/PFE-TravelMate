import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/Model/reservation_model.dart';
import 'package:travelmate/Model/user_model.dart';

class ReservationViewModel {
  ReservationModel reservationModel;

  ReservationViewModel(this.reservationModel);

  getReservationInfoFromFirestoreFromProperty(
      PropertyModel property, DocumentSnapshot snapshot) async {
    reservationModel.property = property;
    reservationModel.id = snapshot.id;
    List<Timestamp> timestamps = List<Timestamp>.from(snapshot['dates']);
    reservationModel.dates = [];
    timestamps.forEach((Timestamp) {
      reservationModel.dates!.add(Timestamp.toDate());
    });
    reservationModel.nbGuests = snapshot['numberOfGuests'] ?? "0";
    reservationModel.paymentMethod = snapshot['paymentMethod'] ?? "person";
    reservationModel.totalPrice = snapshot['totalPrice'] ?? "0";
    String TravelerID = snapshot['userID'] ?? "";
    String name = snapshot['name'] ?? "";
    loadTravelerInfo(TravelerID, name);
  }
Future<bool> cancelReservation() async {
  try {
    // Delete reservation document from reservation collection in user collection
    await FirebaseFirestore.instance
        .collection('users')
        .doc(AppConstants.currentUser.id)
        .collection('reservations')
        .doc(reservationModel.id)
        .delete();

    // Remove reservation document from Properties collection
    await FirebaseFirestore.instance
        .collection('properties')
        .doc(reservationModel.property!.id)
        .collection('reservations')
        .doc(reservationModel.id)
        .delete();
        
    return true;
  } catch (e) {
    print('Error deleting reservation: $e');
    return false;
  }
}
  getReservationInfoFromFirestoreFromTraveler(
      UserModel traveler, DocumentSnapshot snapshot) async {
    reservationModel.traveler = traveler;
    reservationModel.id = snapshot.id;
    List<Timestamp> timestamps = List<Timestamp>.from(snapshot['dates']);
    reservationModel.dates = [];
    timestamps.forEach((Timestamp) {
      reservationModel.dates!.add(Timestamp.toDate());
    });
    reservationModel.paymentMethod = snapshot['paymentMethod'] ?? "person";
    reservationModel.totalPrice = (snapshot['totalPrice'] ?? "0").toDouble();
  }

  loadTravelerInfo(String travelerID, String name) {
    reservationModel.traveler = UserModel(id: travelerID, name: name);
  }

}
