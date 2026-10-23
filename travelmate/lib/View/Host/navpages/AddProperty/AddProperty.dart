import 'package:flutter/material.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/View/Host/navpages/AddProperty/MapPage.dart';
import 'package:travelmate/global.dart';

class AddPropertyPage extends StatefulWidget {
  const AddPropertyPage({super.key});

  @override
  _AddPropertyPageState createState() => _AddPropertyPageState();
}

class _AddPropertyPageState extends State<AddPropertyPage> {
  @override
  void initState() {
    super.initState();
    propertyModel = PropertyModel();
    propertyModel.amenities = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 80),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Category:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                StepperButton(
                  title: 'Bedrooms:',
                  initialValue: 1,
                  onUpdateValue: (value) {
                    setState(() {
                      propertyModel.bedrooms = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                StepperButton(
                  title: 'Bed:',
                  initialValue: 1,
                  onUpdateValue: (value) {
                    setState(() {
                      propertyModel.beds = value;
                    });
                  },
                ),
                const SizedBox(height: 10),
                StepperButton(
                  title: 'Bathroom:',
                  initialValue: 1,
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
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
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
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Wifi');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Wifi'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.tv,
                            text: 'TV',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('TV');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('TV'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.wash_sharp,
                            text: 'Washer',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Washer');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Washer'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.local_parking_outlined,
                            text: 'Paid Parking',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Paid Parking');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Paid Parking'.capitalize()),
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
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Beach area');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Beach area'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.snowing,
                            text: 'AirConditioner',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('AirConditioner');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('AirConditioner'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.kitchen,
                            text: 'Kitchen',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Kitchen');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Kitchen'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.car_crash,
                            text: 'Free parking',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Free parking');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Free parking'.capitalize()),
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
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Gym');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Gym'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.snowboarding,
                            text: 'Ski',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Ski');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Ski'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.pool,
                            text: 'Pool',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Pool');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Pool'.capitalize()),
                          ),
                          AmenityButton(
                            icon: Icons.fire_extinguisher,
                            text: 'Fire extinguisher',
                            fontSizee: 14,
                            width: 170,
                            height: 55,
                            updateProperty: () {
                              setState(() {
                                _toggleAmenity('Fire extinguisher');
                              });
                            },
                            isSelected: propertyModel.amenities!
                                .contains('Fire extinguisher'.capitalize()),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                Positioned(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MapPage()),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(270, 5, 5, 5),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color.fromRGBO(255, 147, 99, 1),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: const Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const Row(
                  children: [
                    const SizedBox(
                      width: 305.0,
                    ),
                    Text('1/5',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16.0)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _toggleAmenity(String amenity) {
    String capitalizedAmenity = amenity.capitalize();
    if (propertyModel.amenities!.contains(capitalizedAmenity)) {
      propertyModel.amenities!.remove(capitalizedAmenity);
    } else {
      propertyModel.amenities!.add(capitalizedAmenity);
    }
  }
}

class CategoryButton extends StatefulWidget {
  final IconData? icon;
  final String text;
  final double fontSizee;
  final String? subtext;
  final double width;
  final double height;
  final Function() updateProperty;

  CategoryButton({
    this.icon,
    required this.text,
    required this.fontSizee,
    this.subtext,
    required this.width,
    required this.height,
    required this.updateProperty,
  });

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
  bool _isClicked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isClicked = !_isClicked;
        });
        widget.updateProperty();
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(9.0),
        decoration: BoxDecoration(
          color: _isClicked ? Colors.grey : Colors.white,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.subtext != null) ...[
                    const SizedBox(height: 5),
                    Text(
                      widget.subtext!,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
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
  late bool _isClicked;

  @override
  void initState() {
    super.initState();
    _isClicked = widget.isSelected;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isClicked = !_isClicked;
          widget.updateProperty();
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        margin: const EdgeInsets.all(6.0),
        padding: const EdgeInsets.all(9.0),
        decoration: BoxDecoration(
          color: _isClicked ? Colors.grey : Colors.white,
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
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
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

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
