import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ResetPwdViewModel {
  final String resetCode;

  ResetPwdViewModel(this.resetCode);
  Future<void> resetPassword(BuildContext context, pwd) async {
    try {
      // Reset password using reset code and new password
      await FirebaseAuth.instance.confirmPasswordReset(
        code: resetCode,
        newPassword: pwd,
      );
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Password Reset Successful'),
            content: Text('Your password has been reset successfully.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Failed to reset password: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(e.toString()),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
