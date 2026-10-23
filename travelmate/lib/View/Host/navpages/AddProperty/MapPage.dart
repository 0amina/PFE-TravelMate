import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:travelmate/Model/places.dart';
import 'package:travelmate/View/Host/AppBar.dart';
import 'package:travelmate/View/Host/navpages/AddProperty/PropertyPhotos.dart';
import 'package:travelmate/global.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? mapController;
  Set<Marker> markers = {};
  String? selectedState;
  String? selectedCity;
  List<String> _states = [];
  List<String> _cities = [];
  LatLng _center = const LatLng(36.81897, 10.16579); // Initial center

  final Places places = Places();

  @override
  void initState() {
    super.initState();
    _loadStates();
  }

  Future<void> _loadStates() async {
    try {
      List<String> states = await places.fetchTunisiaStates();
      states = states.toSet().toList();
      states.sort();
      setState(() {
        _states = states;
        print('Loaded states: $_states');
      });
    } catch (e) {
      print('Failed to load Tunisia states: $e');
    }
  }

  Future<void> _fetchCitiesForState(String state) async {
    try {
      List<String> cities = await places.fetchTunisiaCities(state);
      cities = cities.toSet().toList();
      cities.sort();
      setState(() {
        _cities = cities;
        print('Loaded cities for state $state: $_cities');
      });
    } catch (e) {
      print('Failed to load cities for state $state: $e');
    }
  }

  Future<void> _fetchLatLngForCity(String city) async {
    try {
      LatLng? latLng = await places.fetchLatLngForCity(city);
      if (latLng != null) {
        setState(() {
          _center = latLng;
          _updateMarkerPosition(latLng);
        });
      }
    } catch (e) {
      print('Failed to load LatLng for city $city: $e');
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AddAppBar(title: "Add Property"),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 15.0,
            ),
            markers: markers,
          ),
          Positioned(
            height: 50,
            top: 35,
            left: 40,
            right: 40,
            child: GestureDetector(
              onTap: () {
                _showLocationPopup(context);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.location_searching),
                    SizedBox(width: 10),
                    Text(
                      'Enter your address',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Stack(
            children: [
              Positioned(
                bottom: 50,
                right: 50,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhotoSelectionPage(),
                      ),
                    );
                  },
                  child: Container(
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
              const Positioned(
                bottom: 25,
                right: 70,
                child: Row(
                  children: [
                    SizedBox(width: 305.0),
                    Text(
                      '2/5',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 16.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
