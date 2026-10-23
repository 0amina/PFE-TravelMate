import 'package:flutter/material.dart';
import 'package:travelmate/View/Host/navpages/home.dart';
import 'package:travelmate/View/Host/navpages/listings.dart';
import 'package:travelmate/View/Host/navpages/inbox.dart';
import 'package:travelmate/View/Host/navpages/profile.dart';
import 'package:travelmate/View/Host/navpages/AddProperty/AddProperty.dart';
import 'package:travelmate/View/Host/navbarHost.dart';

class HomeScreen extends StatefulWidget {
  final String userId;
  final int? selectedIndex; // Add selectedIndex parameter here

  const HomeScreen({Key? key, required this.userId, this.selectedIndex}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.selectedIndex ?? 0; // Use the provided selectedIndex or default to 0
  }

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
        },
      ),
    );
  }

  List<Widget> get _pages {
    return [
      Home(),
      Listings(),
      AddPropertyPage(),
      HostInbox(),
      Profile(),
    ];
  }
}
