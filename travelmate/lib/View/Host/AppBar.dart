import 'package:flutter/material.dart';

class AddAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  AddAppBar({required this.title});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        //color: Colors.white,
        padding: EdgeInsets.only(top: 10, left: 25, right: 25), // Adjust top padding to move the app bar down
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center, // Align items vertically center
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 20,
                color: Color.fromARGB(255, 0, 0, 0),
              ),
            ),
            SizedBox(width: 20), // Add space between icon and title
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: Color.fromARGB(255, 0, 3, 36),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
