import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/View/Traveler/homescreen.dart';
import 'package:travelmate/View/Auth/signin.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';
import 'package:travelmate/global.dart';

class loginViewModel {
  Future<void> signIn(
      BuildContext context, String email, String password) async {
    try {
      final result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      String currentUserID = result.user!.uid;
      print("Current user ID: $currentUserID");
      AppConstants.currentUser.id = currentUserID;
      await getUserInfoFromFirestore(currentUserID);
      await getImageFromStorage(currentUserID);
      await userViewModel.getMyPropertiesFromFirestore();
      await userViewModel.getUserReservations();
      await userViewModel.updateUserToken();

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Logged in successfully"),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen(userId: currentUserID)),
      );
    } catch (e) {
      print("Error in signIn: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Sign-in failed: ${e.toString()}'),
        ),
      );
    }
  }

  Future<void> getUserInfoFromFirestore(String userID) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();
      AppConstants.currentUser.snapshot = snapshot;
      AppConstants.currentUser.name = snapshot['name'] ?? "";
      AppConstants.currentUser.email = snapshot['email'] ?? "";
      AppConstants.currentUser.city = snapshot['city'];
      AppConstants.currentUser.state = snapshot['state'];
      AppConstants.currentUser.birthday = snapshot['birthday'];
      AppConstants.currentUser.phoneNumber = snapshot['phoneNumber'] ;
      AppConstants.currentUser.isHost = snapshot['isHost'] ?? false;
      await getfavPropertyIDsFromFirestore(userID);
    } catch (e) {
      print("Error in getUserInfoFromFirestore: $e");
      throw e;
    }
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignInScreen()),
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      print("Error in logout: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Logout failed: ${e.toString()}'),
        ),
      );
    }
  }

  Future<void> getfavPropertyIDsFromFirestore(String userID) async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userID)
          .get();
      List<dynamic> favPropertyIDs = snapshot.get('favPropertyIDs') ?? [];
      List<PropertyModel> fav = [];
      for (String propertyId in favPropertyIDs) {
        if (propertyId.isNotEmpty) {
          DocumentSnapshot propertySnapshot = await FirebaseFirestore.instance
              .collection('properties')
              .doc(propertyId)
              .get();

          if (propertySnapshot.exists) {
            PropertyModel propertyModel = PropertyModel(id: propertyId);
            PropertyViewModel propertyVM = PropertyViewModel(propertyModel);
            await propertyVM.getPropertyInfoFromFirestore();
            fav.add(propertyModel);
          }
        }
      }
      AppConstants.currentUser.favProperties = fav;
    } catch (e) {
      print("Failed to retrieve favorite properties: $e");
    }
  }

  getImageFromStorage(id) async {
    final imageDataInBytes = await FirebaseStorage.instance
        .ref()
        .child("profile_photos")
        .child(id)
        .child(id + ".png")
        .getData(1024 * 1024);
    AppConstants.currentUser.photo = MemoryImage(imageDataInBytes!);
    return AppConstants.currentUser.photo;
  }
}
