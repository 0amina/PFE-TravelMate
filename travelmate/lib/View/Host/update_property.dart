import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/View/Host/homescreen.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';

class UpdatePropertyPage extends StatefulWidget {
  final PropertyModel property;

  const UpdatePropertyPage({required this.property, super.key});

  @override
  _UpdatePropertyPageState createState() => _UpdatePropertyPageState();
}

class _UpdatePropertyPageState extends State<UpdatePropertyPage> {
  late PropertyModel propertyModel;
  late PropertyViewModel propertyViewModel;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  bool _updatingProperty = false;
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  String? selectedState;
  String? selectedCity;
  List<String> _states = [];
  List<String> _cities = [];
  LatLng _center = const LatLng(36.81897, 10.16579);

  @override
  void initState() {
    super.initState();
    propertyModel = widget.property;
    propertyViewModel = PropertyViewModel(propertyModel);
    _titleController.text = propertyModel.title ?? '';
    _descriptionController.text = propertyModel.description ?? '';
    priceController.text = propertyModel.price?.toString() ?? '0';
    _loadStates();
  }

  Future<void> _loadStates() async {
    // Load states and handle errors if necessary
  }

  Future<void> _fetchCitiesForState(String state) async {
    // Fetch cities for the selected state and handle errors if necessary
  }

  Future<void> _fetchLatLngForCity(String city) async {
    // Fetch latLng for the selected city and handle errors if necessary
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
    _addMarker(_center, "House");
  }

  void _addMarker(LatLng position, String markerId) {
    final MarkerId _markerId = MarkerId(markerId);
    final Marker marker = Marker(
      markerId: _markerId,
      position: position,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      infoWindow: InfoWindow(title: markerId, snippet: 'Your Position'),
    );

    setState(() {
      markers.add(marker);
    });
  }

  void _updateMarkerPosition(LatLng position) {
    markers.clear();
    _addMarker(position, "House");
    mapController?.animateCamera(CameraUpdate.newLatLng(position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Update Property')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Choose Category:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CategoryButton(
                          icon: Icons.home,
                          text: 'Home',
                          fontSizee: 14,
                          width: 150,
                          height: 55,
                          isSelected: propertyModel.category == 'Home',
                          updateProperty: () {
                            setState(() {
                              propertyModel.category = 'Home';
                            });
                          },
                        ),
                        CategoryButton(
                          icon: Icons.apartment,
                          text: 'Apartment',
                          fontSizee: 14,
                          width: 150,
                          height: 55,
                          isSelected: propertyModel.category == 'Apartment',
                          updateProperty: () {
                            setState(() {
                              propertyModel.category = 'Apartment';
                            });
                          },
                        ),
                        CategoryButton(
                          icon: Icons.villa,
                          text: 'Villa',
                          fontSizee: 14,
                          width: 150,
                          height: 55,
                          isSelected: propertyModel.category == 'Villa',
                          updateProperty: () {
                            setState(() {
                              propertyModel.category = 'Villa';
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CategoryButton(
                          icon: Icons.beach_access,
                          text: 'Beach House',
                          fontSizee: 14,
                          width: 150,
                          height: 55,
                          isSelected: propertyModel.category == 'Beach House',
                          updateProperty: () {
                            setState(() {
                              propertyModel.category = 'Beach House';
                            });
                          },
                        ),
                        CategoryButton(
                          icon: Icons.business,
                          text: 'Office',
                          fontSizee: 14,
                          width: 150,
                          height: 55,
                          isSelected: propertyModel.category == 'Office',
                          updateProperty: () {
                            setState(() {
                              propertyModel.category = 'Office';
                            });
                          },
                        ),
                        CategoryButton(
                          icon: Icons.add_circle_outline,
                          text: 'Other',
                          fontSizee: 14,
                          width: 150,
                          height: 55,
                          isSelected: propertyModel.category == 'Other',
                          updateProperty: () {
                            setState(() {
                              propertyModel.category = 'Other';
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Share some basics about your place',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              StepperButton(
                title: 'Bedrooms:',
                initialValue: propertyModel.bedrooms ?? 1,
                onUpdateValue: (value) {
                  setState(() {
                    propertyModel.bedrooms = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              StepperButton(
                title: 'Bed:',
                initialValue: propertyModel.beds ?? 1,
                onUpdateValue: (value) {
                  setState(() {
                    propertyModel.beds = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              StepperButton(
                title: 'Bathroom:',
                initialValue: propertyModel.bathrooms ?? 1,
                onUpdateValue: (value) {
                  setState(() {
                    propertyModel.bathrooms = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Tell us what your place has to offer',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        AmenityButton(
                          icon: Icons.wifi,
                          text: 'Wifi',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Wifi') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Wifi') ?? false) {
                                propertyModel.amenities?.remove('Wifi');
                              } else {
                                propertyModel.amenities?.add('Wifi');
                              }
                            });
                          },
                        ),
                        AmenityButton(
                          icon: Icons.tv,
                          text: 'TV',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('TV') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('TV') ?? false) {
                                propertyModel.amenities?.remove('TV');
                              } else {
                                propertyModel.amenities?.add('TV');
                              }
                            });
                          },
                        ),
                        AmenityButton(
                          icon: Icons.wash_sharp,
                          text: 'Washer',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Washer') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Washer') ?? false) {
                                propertyModel.amenities?.remove('Washer');
                              } else {
                                propertyModel.amenities?.add('Washer');
                              }
                            });
                          },
                        ),
                        AmenityButton(
                          icon: Icons.local_parking_outlined,
                          text: 'Paid Parking',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Paid Parking') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Paid Parking') ?? false) {
                                propertyModel.amenities?.remove('Paid Parking');
                              } else {
                                propertyModel.amenities?.add('Paid Parking');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AmenityButton(
                          icon: Icons.beach_access_outlined,
                          text: 'Beach area',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Beach area') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Beach area') ?? false) {
                                propertyModel.amenities?.remove('Beach area');
                              } else {
                                propertyModel.amenities?.add('Beach area');
                              }
                            });
                          },
                        ),
                        AmenityButton(
                          icon: Icons.snowing,
                          text: 'AirConditioner',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('AirConditioner') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('AirConditioner') ?? false) {
                                propertyModel.amenities?.remove('AirConditioner');
                              } else {
                                propertyModel.amenities?.add('AirConditioner');
                              }
                            });
                          },
                        ),
                        AmenityButton(
                          icon: Icons.kitchen,
                          text: 'Kitchen',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Kitchen') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Kitchen') ?? false) {
                                propertyModel.amenities?.remove('Kitchen');
                              } else {
                                propertyModel.amenities?.add('Kitchen');
                              }
                            });
                          },
                        ),
                        AmenityButton(
                          icon: Icons.car_crash,
                          text: 'Free parking',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Free parking') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Free parking') ?? false) {
                                propertyModel.amenities?.remove('Free parking');
                              } else {
                                propertyModel.amenities?.add('Free parking');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        AmenityButton(
                          icon: Icons.sports_gymnastics_sharp,
                          text: 'Gym',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Gym') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Gym') ?? false) {
                                propertyModel.amenities?.remove('Gym');
                              } else {
                                propertyModel.amenities?.add('Gym');
                              }
                            });
                          },
                        ),
                        AmenityButton(
                          icon: Icons.snowboarding,
                          text: 'Ski',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Ski') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Ski') ?? false) {
                                propertyModel.amenities?.remove('Ski');
                              } else {
                                propertyModel.amenities?.add('Ski');
                              }
                            });
                          },
                        ),
                        AmenityButton(
                            icon: Icons.pool,
                            text: 'Pool',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            isSelected: propertyModel.amenities?.contains('Pool') ?? false,
                            updateProperty: () {
                              setState(() {
                                if (propertyModel.amenities?.contains('Pool') ?? false) {
                                  propertyModel.amenities?.remove('Pool');
                                } else {
                                  propertyModel.amenities?.add('Pool');
                                }
                              });
                            }),
                        AmenityButton(
                          icon: Icons.fire_extinguisher,
                          text: 'Fire extinguisher',
                          fontSizee: 14,
                          width: 170,
                          height: 55,
                          isSelected: propertyModel.amenities?.contains('Fire extinguisher') ?? false,
                          updateProperty: () {
                            setState(() {
                              if (propertyModel.amenities?.contains('Fire extinguisher') ?? false) {
                                propertyModel.amenities?.remove('Fire extinguisher');
                              } else {
                                propertyModel.amenities?.add('Fire extinguisher');
                              }
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _titleController,
                maxLines: 1,
                decoration: const InputDecoration(
                  hintText: 'Enter title...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  propertyModel.title = value;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Enter description...',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  propertyModel.description = value;
                },
              ),
              const SizedBox(height: 10),
              const Text(
                'Map',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 200,
                child: GoogleMap(
                  onMapCreated: _onMapCreated,
                  initialCameraPosition: CameraPosition(
                    target: _center,
                    zoom: 15.0,
                  ),
                  markers: markers,
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showLocationPopup(context);
                },
                child: const Text('Enter your address'),
              ),
              const SizedBox(height: 10),
              const Text(
                'Photos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ImageSelectionButton(
                    icon: Icons.photo_library,
                    text: 'Import',
                    fontSizee: 20,
                    width: 170,
                    height: 100,
                    onTap: () => _getImage(ImageSource.gallery),
                  ),
                  const SizedBox(width: 10),
                  ImageSelectionButton(
                    icon: Icons.camera_alt,
                    text: 'Take a Photo',
                    fontSizee: 20,
                    width: 170,
                    height: 100,
                    onTap: () => _getImage(ImageSource.camera),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Selected Photos:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: propertyModel.displayImages!.length,
                  itemBuilder: (context, index) {
                    final photo = propertyModel.displayImages![index];
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Stack(
                        children: [
                          Image(image: photo, width: 100, height: 100, fit: BoxFit.cover),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  propertyModel.displayImages!.removeAt(index);
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              const Text(
                'Pricing',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text(
                'You can change it at any time',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(color: const Color.fromARGB(45, 101, 101, 101)),
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: TextField(
                        controller: priceController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Enter price...',
                          hintStyle: TextStyle(fontSize: 24),
                        ),
                        style: const TextStyle(fontSize: 30),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          propertyModel.price = double.tryParse(value) ?? 0.0;
                        },
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'DT',
                        style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: _updatingProperty ? null : () async {
                    setState(() {
                      _updatingProperty = true;
                    });
                    bool success = await propertyViewModel.updatePropertyInfoInFirestore();
                    setState(() {
                      _updatingProperty = false;
                    });
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Property updated successfully!')),
                      );
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const HomeScreen(
                          userId: "userId",
                          selectedIndex: 1,
                        )),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Failed to update property.')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(255, 147, 99, 1),
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _updatingProperty ? const CircularProgressIndicator() : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);

    if (pickedFile != null) {
      final imageData = await pickedFile.readAsBytes();
      setState(() {
        propertyModel.displayImages!.add(MemoryImage(imageData));
      });
    }
  }

  void _showLocationPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text(
                      'Enter Location Details',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'State'),
                      items:
                          _states.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        // Update region when the value changes
                        setState(() {
                          selectedState = newValue;
                          selectedCity = null;
                          _cities = [];
                          if (newValue != null) {
                            _fetchCitiesForState(newValue).then((_) {
                              setState(() {
                                _cities = _cities;
                              });
                            });
                          }
                        });
                      },
                      value: selectedState, // Ensure the state is retained
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'City'),
                      items:
                          _cities.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedCity = newValue;
                        });
                      },
                      value: selectedCity, // Ensure the city is retained
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      decoration:
                          const InputDecoration(labelText: 'Street Address'),
                      onChanged: (value) {
                        setState(() {
                          propertyModel.streetAddress = value;
                        });
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        if (selectedCity != null) {
                          _fetchLatLngForCity(selectedCity!);
                        }
                        propertyModel.state = selectedState;
                        propertyModel.city = selectedCity;
                        Navigator.of(context).pop();
                      },
                      child: const Text('Save'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class CategoryButton extends StatefulWidget {
  final IconData? icon;
  final String text;
  final double fontSizee;
  final double width;
  final double height;
  final Function() updateProperty;
  final bool isSelected;

  CategoryButton({
    this.icon,
    required this.text,
    required this.fontSizee,
    required this.width,
    required this.height,
    required this.updateProperty,
    required this.isSelected,
  });

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.updateProperty();
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(9.0),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 25,
                      color: const Color.fromRGBO(255, 147, 99, 1),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.fontSizee,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AmenityButton extends StatefulWidget {
  final IconData? icon;
  final String text;
  final double fontSizee;
  final double width;
  final double height;
  final Function() updateProperty;
  final bool isSelected;

  AmenityButton({
    this.icon,
    required this.text,
    required this.fontSizee,
    required this.width,
    required this.height,
    required this.updateProperty,
    required this.isSelected,
  });

  @override
  _AmenityButtonState createState() => _AmenityButtonState();
}

class _AmenityButtonState extends State<AmenityButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.updateProperty();
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(9.0),
        decoration: BoxDecoration(
          color: widget.isSelected ? Colors.grey : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.icon != null) ...[
                    Icon(
                      widget.icon,
                      size: 25,
                      color: const Color.fromRGBO(255, 147, 99, 1),
                    ),
                    const SizedBox(width: 10),
                  ],
                  Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: widget.fontSizee,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageSelectionButton extends StatelessWidget {
  final IconData? icon;
  final String text;
  final double fontSizee;
  final double width;
  final double height;
  final VoidCallback onTap;

  const ImageSelectionButton({
    this.icon,
    required this.text,
    required this.fontSizee,
    required this.width,
    required this.height,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 35,
                  color: const Color.fromRGBO(255, 147, 99, 1),
                ),
                const SizedBox(height: 10), // Add spacing between icon and text
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSizee,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StepperButton extends StatefulWidget {
  final String title;
  final int initialValue;
  final Function(int) onUpdateValue;

  StepperButton({
    required this.title,
    required this.initialValue,
    required this.onUpdateValue,
  });

  @override
  _StepperButtonState createState() => _StepperButtonState();
}

class _StepperButtonState extends State<StepperButton> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  void _increment() {
    setState(() {
      _value++;
      widget.onUpdateValue(_value);
    });
  }

  void _decrement() {
    setState(() {
      _value = _value > 1 ? _value - 1 : 1;
      widget.onUpdateValue(_value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _decrement,
                icon: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 255, 146, 99),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.remove,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                '$_value',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: _increment,
                icon: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color.fromARGB(255, 255, 146, 99),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
