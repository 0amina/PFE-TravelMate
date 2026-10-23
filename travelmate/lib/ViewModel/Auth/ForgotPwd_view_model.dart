import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travelmate/View/Auth/ForgotPassword.dart';

class ForgotPwdViewModel {
  Future<void> forgotPassword(BuildContext context, String email) async {
    try {
      // Generate custom link
      final Uri resetLink = Uri.parse(
        'travelmate://reset-password?email=$email',
      );

      // Send password reset email with the custom link
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: email,
        actionCodeSettings: ActionCodeSettings(
          url: resetLink.toString(),
          androidPackageName: 'com.example.travelmate', // Android package name
          handleCodeInApp: true, // This must be true
          iOSBundleId: 'com.example.travelmate', // iOS bundle ID
        ),
      );
      ForgotPassword().showSuccessDialog(context);
    } catch (e) {
      print('Failed to send reset email: $e');
      ForgotPassword().showErrorDialog(context, e.toString());
    }
  }
}
