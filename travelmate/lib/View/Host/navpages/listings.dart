import 'package:flutter/material.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/View/Host/propertyCalendar.dart';
import 'package:travelmate/View/Host/update_property.dart'; // Import the UpdatePropertyPage
import 'package:travelmate/ViewModel/property_view_model.dart';
class Listings extends StatefulWidget {
  const Listings({super.key});

  @override
  State<Listings> createState() => _ListingsState();
}

class _ListingsState extends State<Listings> {
  @override
  void initState() {
    super.initState();
    AppConstants.currentUser.myProperties;
  }

  Future<void> deletePost(int index) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this post?'),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  PropertyModel propertyModel =
                      AppConstants.currentUser.myProperties![index];
                  PropertyViewModel propertyViewModel =
                      PropertyViewModel(propertyModel);

                  bool success = await propertyViewModel.deleteProperty();
                  if (success) {
                    setState(() {
                      AppConstants.currentUser.myProperties!.removeAt(index);
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Property deleted successfully')),
                    );
                  }
                } catch (err) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(err.toString())),
                  );
                  print('Error deleting post: $err');
                }
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Listings',
          style: TextStyle(color: Color.fromARGB(255, 9, 9, 9)),
        ),
      ),
      body: AppConstants.currentUser.myProperties == null ||
              AppConstants.currentUser.myProperties!.isEmpty
          ? const Center(
              child: Text('No properties available'),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: AppConstants.currentUser.myProperties!.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (_, index) {
                      final propertyM =
                          AppConstants.currentUser.myProperties![index];
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: SizedBox(
                                  width: 170,
                                  height: 140,
                                  child: propertyM.photos != null &&
                                          propertyM.photos!.isNotEmpty
                                      ? Image.network(
                                          propertyM.photos!.first,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/splashback.png',
                                          fit: BoxFit.cover,
                                        ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      propertyM.title ?? 'No title available',
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      '${propertyM.city ?? 'No city available'}, ${propertyM.state ?? 'No country available'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Price: dt${propertyM.price ?? '0'}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CalendarPage(
                                              property: propertyM,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const Row(
                                        children: [
                                          Text(
                                            'reserved dates',
                                            style: TextStyle(
                                              fontSize: 18,
                                              color: Color.fromARGB(
                                                  255, 255, 146, 99),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Icon(Icons.calendar_today,
                                              color: Color.fromARGB(
                                                  255, 255, 146, 99),
                                              size: 20),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit_note_outlined),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdatePropertyPage(
                                            property: propertyM,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_outline_sharp),
                                    onPressed: () {
                                      deletePost(index);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
