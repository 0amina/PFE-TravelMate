import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/Model/FilterModel.dart';
import 'package:travelmate/View/Traveler/navpages/home.dart';
import 'package:travelmate/View/Traveler/navpages/favorites.dart';
import 'package:travelmate/View/Traveler/navpages/bookings.dart';
import 'package:travelmate/View/Traveler/navpages/inbox.dart';
import 'package:travelmate/View/Traveler/navpages/profile.dart';
import 'package:travelmate/View/Traveler/navbar.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  const HomeScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selectedIndex], // Display selected page based on index
      bottomNavigationBar: CustomBottomNavigationBar(
        selectedIndex: _selectedIndex,
        onTabChange: (index) {
          setState(() {
            _selectedIndex = index;
          });
          if (index == 0) {
            Provider.of<FilterModel>(context, listen: false).clearFilters();
          }
        },
      ),
    );
  }

  List<Widget> get _pages {
    return [
      Home(userId: widget.userId), // Pass userId to Home widget
      Favorites(),
      Bookings(),
      TravelerInbox(),
      Profile(), // Pass the current user
    ];
  }
}
