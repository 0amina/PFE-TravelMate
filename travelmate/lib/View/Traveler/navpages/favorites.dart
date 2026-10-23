import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/View/Traveler/property_card.dart';

class Favorites extends StatefulWidget {
  const Favorites({Key? key}) : super(key: key);

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  @override
  void initState() {
    super.initState();
    AppConstants.currentUser.favProperties;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Adjust margin as needed
        child: ListView.builder(
          itemCount: AppConstants.currentUser.favProperties!.length,
          itemBuilder: (context, index) {
            PropertyModel property =
                AppConstants.currentUser.favProperties![index];
            return PropertyCard(
              property: property,
            );
          },
        ),
      ),
    );
  }
}