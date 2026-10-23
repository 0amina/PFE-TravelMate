import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:travelmate/Model/FilterModel.dart';

class FilterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filters'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Provider.of<FilterModel>(context, listen: false).applyFilters();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: FilterContent(),
      ),
    );
  }
}

class FilterContent extends StatefulWidget {
  @override
  _FilterContentState createState() => _FilterContentState();
}

class _FilterContentState extends State<FilterContent> {
  List<bool> _isSelectedDescription = List.filled(6, false);
  List<bool> _isSelectedAmenities = List.filled(12, false);

  List<String> amenitiesList = [
    'Wifi', 'TV', 'Paid Parking', 'Beach area', 'AirConditioner', 'Kitchen', 'Free Parking',
    'Gym', 'Ski', 'Washer', 'Pool', 'Fire extinguisher',
  ];

  List<String> descriptionList = [
    'Home', 'Apartment', 'Villa', 'Beach House', 'Office', 'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final filterModel = Provider.of<FilterModel>(context);

    void _updateSelection(int index, List<bool> isSelectedList, bool isDescription) {
      setState(() {
        if (isDescription) {
          for (int i = 0; i < isSelectedList.length; i++) {
            isSelectedList[i] = false;
          }
          isSelectedList[index] = true;
          filterModel.setCategory(descriptionList[index]);
        } else {
          isSelectedList[index] = !isSelectedList[index];
          List<String> selectedAmenities = [];
          for (int i = 0; i < isSelectedList.length; i++) {
            if (_isSelectedAmenities[i]) {
              selectedAmenities.add(amenitiesList[i]);
            }
          }
          filterModel.setAmenities(selectedAmenities);
        }
      });
    }

    void _updatePriceRange(SfRangeValues values) {
      filterModel.setPriceRange(values.start.toDouble(), values.end.toDouble());
    }

    return ListView(
      children: [
        const SizedBox(height: 10),
        const Text('Description of Property', style: TextStyle(fontSize: 16)),
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
                      _updateSelection(0, _isSelectedDescription, true);
                    },
                    isSelected: _isSelectedDescription[0],
                  ),
                  CategoryButton(
                    icon: Icons.apartment,
                    text: 'Apartment',
                    fontSizee: 14,
                    width: 150,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(1, _isSelectedDescription, true);
                    },
                    isSelected: _isSelectedDescription[1],
                  ),
                  CategoryButton(
                    icon: Icons.villa,
                    text: 'Villa',
                    fontSizee: 14,
                    width: 150,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(2, _isSelectedDescription, true);
                    },
                    isSelected: _isSelectedDescription[2],
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
                      _updateSelection(3, _isSelectedDescription, true);
                    },
                    isSelected: _isSelectedDescription[3],
                  ),
                  CategoryButton(
                    icon: Icons.business,
                    text: 'Office',
                    fontSizee: 14,
                    width: 150,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(4, _isSelectedDescription, true);
                    },
                    isSelected: _isSelectedDescription[4],
                  ),
                  CategoryButton(
                    icon: Icons.add_circle_outline,
                    text: 'Other',
                    fontSizee: 14,
                    width: 150,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(5, _isSelectedDescription, true);
                    },
                    isSelected: _isSelectedDescription[5],
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        const Text('Amenities', style: TextStyle(fontSize: 16)),
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
                      _updateSelection(0, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[0],
                  ),
                  AmenityButton(
                    icon: Icons.tv,
                    text: 'TV',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(1, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[1],
                  ),
                  AmenityButton(
                    icon: Icons.local_parking_outlined,
                    text: 'Paid Parking',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(2, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[2],
                  ),
                  AmenityButton(
                    icon: Icons.beach_access_outlined,
                    text: 'Beach area',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(3, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[3],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AmenityButton(
                    icon: Icons.snowing,
                    text: 'AirConditioner',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(4, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[4],
                  ),
                  AmenityButton(
                    icon: Icons.kitchen,
                    text: 'Kitchen',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(5, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[5],
                  ),
                  AmenityButton(
                    icon: Icons.car_crash,
                    text: 'Free parking',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(6, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[6],
                  ),
                  AmenityButton(
                    icon: Icons.sports_gymnastics_sharp,
                    text: 'Gym',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(7, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[7],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  AmenityButton(
                    icon: Icons.snowboarding,
                    text: 'Ski',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(8, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[8],
                  ),
                  AmenityButton(
                    icon: Icons.pool,
                    text: 'Pool',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(9, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[9],
                  ),
                  AmenityButton(
                    icon: Icons.fire_extinguisher,
                    text: 'Fire extinguisher',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(10, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[10],
                  ),
                  AmenityButton(
                    icon: Icons.wash_sharp,
                    text: 'Washer',
                    fontSizee: 14,
                    width: 170,
                    height: 55,
                    updateProperty: () {
                      _updateSelection(11, _isSelectedAmenities, false);
                    },
                    isSelected: _isSelectedAmenities[11],
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rooms', style: TextStyle(fontSize: 16)),
            FilterRange(
              value: filterModel.bedrooms,
              onChanged: (value) {
                filterModel.setRooms(value);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Beds', style: TextStyle(fontSize: 16)),
            FilterRange(
              value: filterModel.beds,
              onChanged: (value) {
                filterModel.setBeds(value);
              },
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Bathrooms', style: TextStyle(fontSize: 16)),
            FilterRange(
              value: filterModel.bathrooms,
              onChanged: (value) {
                filterModel.setBathrooms(value);
              },
            ),
          ],
        ),
        const Divider(),
        const SizedBox(height: 10),
        const Text('Price range (DT)', style: TextStyle(fontSize: 16)),
        SfRangeSlider(
          min: 0.0,
          max: 3000.0,
          values: SfRangeValues(filterModel.minPrice, filterModel.maxPrice),
          interval: 500,
          showTicks: true,
          showLabels: true,
          enableTooltip: true,
          stepSize: 50,
          onChanged: _updatePriceRange,
        ),
        const Divider(),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            filterModel.applyFilters();
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 255, 146, 99),
          ),
          child: const Text(
            'Apply Filters',
            style: TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ],
    );
  }
}

class FilterRange extends StatefulWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const FilterRange({
    required this.value,
    required this.onChanged,
  });

  @override
  _FilterRangeState createState() => _FilterRangeState();
}

class _FilterRangeState extends State<FilterRange> {
  late int _value;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  void _increaseValue() {
    setState(() {
      _value++;
      widget.onChanged(_value);
    });
  }

  void _decreaseValue() {
    setState(() {
      if (_value > 0) {
        _value--;
        widget.onChanged(_value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: _decreaseValue,
        ),
        Text('$_value'),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: _increaseValue,
        ),
      ],
    );
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
  final bool isSelected;

  CategoryButton({
    this.icon,
    required this.text,
    required this.fontSizee,
    this.subtext,
    required this.width,
    required this.height,
    required this.updateProperty,
    required this.isSelected,
  });

  @override
  _CategoryButtonState createState() => _CategoryButtonState();
}

class _CategoryButtonState extends State<CategoryButton> {
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
            ],
          ),
        ),
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
