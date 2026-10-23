import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'package:travelmate/View/theme/theme.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabChange;

  const CustomBottomNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onTabChange,
  }) : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
       padding: EdgeInsets.all(6.0),
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: MyTheme.lightColorScheme.primary,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0,horizontal:6.0),
          child: GNav(
            backgroundColor: MyTheme.lightColorScheme.primary,
            color: Colors.white,
            activeColor: MyTheme.lightColorScheme.primary,
            tabBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
            gap: 8,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(
                icon: LineIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: LineIcons.list,
                text: 'Listings',
              ),
              GButton(
                icon: Icons.add,
                text: '',
              ),
              GButton(
                icon: LineIcons.inbox,
                text: 'Inbox',
              ),
              GButton(
                icon: LineIcons.user,
                text: 'Profile',
              ),
            ],
            selectedIndex: widget.selectedIndex,
            onTabChange: widget.onTabChange,
          ),
        ),
      ),
    );
  }
}
