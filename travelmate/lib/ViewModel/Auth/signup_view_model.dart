import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';

class SignUpViewModel {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  signUp(
      email, password, name, profileImage) async {
    await _auth
        .createUserWithEmailAndPassword(
      email: email,
      password: password,
    )
        .then((result) async {
      String currentUserID = result.user!.uid;
      AppConstants.currentUser.id = currentUserID;
      AppConstants.currentUser.email = email;
      AppConstants.currentUser.password = password;
      AppConstants.currentUser.name = name;
      AppConstants.currentUser.state = null;
      AppConstants.currentUser.city = null;
      AppConstants.currentUser.phoneNumber = null;
      String? fcmToken = await _firebaseMessaging.getToken();
      String photoUrl =
          await addImageToFirebaseStorage(profileImage, currentUserID);
      await saveUserToFirestore(
          email, name, currentUserID, photoUrl, fcmToken);
    });
  }

  Future<void> saveUserToFirestore(
      email, name, id, photoUrl, String? fcmToken) async {
    Map<String, dynamic> dataMap = {
      "email": email,
      "name": name,
      "city": '',
      "state": '',
      "phoneNumber": '',
      "isHost": false,
      "myPropertiesIDs": [],
      "favPropertyIDs": [],
      "earnings": 0,
      "photoUrl": photoUrl,
      "deviceToken": fcmToken ?? '',
      "birthday": '',
    };
    await _firestore.collection('users').doc(id).set(dataMap);
  }

  Future<String> addImageToFirebaseStorage(File image, String id) async {
    Reference referenceStorage = FirebaseStorage.instance
        .ref()
        .child("profile_photos")
        .child(id)
        .child(id + ".png");
    UploadTask uploadTask = referenceStorage.putFile(image);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    AppConstants.currentUser.photo = MemoryImage(image.readAsBytesSync());
    return downloadUrl;
  }
}
