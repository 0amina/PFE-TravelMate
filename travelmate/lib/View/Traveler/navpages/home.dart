import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:travelmate/Model/FilterModel.dart';
import 'package:travelmate/Model/app_constants.dart';
import 'package:travelmate/Model/property_model.dart';
import 'package:travelmate/View/Traveler/filtrepage.dart';
import 'package:travelmate/View/Traveler/property_card.dart';
import 'package:travelmate/ViewModel/notification_view_model.dart';
import 'package:travelmate/ViewModel/property_view_model.dart';
import 'dart:async';
import 'package:travelmate/View/Traveler/notification.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.userId}) : super(key: key);

  final String userId;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<PropertyModel> properties = [];
  String selectedSortOption = 'Most Recent';
  late PageController _pageController;
  Timer? _debounce;
  int _currentPage = 0;
  final _pageSize = 8;
  late TextEditingController _searchController;
  String _searchQuery = '';
  NotificationViewModel notifVM = NotificationViewModel();

  // List of sort options
  final List<String> sortOptions = [
    'Most Recent',
    'Price: Low to High',
    'Price: High to Low'
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _searchController = TextEditingController();
  }

  void nextPage() {
    if (_currentPage <
        (_filterAndSortProperties(properties).length / _pageSize).ceil() - 1) {
      _pageController.animateToPage(_currentPage + 1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      _pageController.animateToPage(_currentPage - 1,
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _search(String query) {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _searchQuery = query.toLowerCase();
      });
    });
  }

Stream<List<PropertyModel>> _propertyStream(FilterModel filterModel) {
  final filters = {
    'category': filterModel.category,
    'amenities': filterModel.amenities,
    'minPrice': filterModel.minPrice,
    'maxPrice': filterModel.maxPrice,
    'bedrooms': filterModel.bedrooms,
    'beds': filterModel.beds,
    'bathrooms': filterModel.bathrooms,
  };

  return FirebaseFirestore.instance
      .collection('properties')
      .snapshots()
      .asyncMap((snapshot) async {
    List<Future<PropertyModel>> propertyFutures =
        snapshot.docs.map((doc) async {
      PropertyModel property = PropertyModel(id: doc.id);
      PropertyViewModel propertyVM = PropertyViewModel(property);
      await propertyVM.getPropertyInfoFromFirestore();
      return property;
    }).toList();
    return await Future.wait(propertyFutures);
  }).map((properties) {
    return properties.where((property) {
      if (filters['category'] != null && filters['category'] != property.category) {
        return false;
      }
      if (filters['amenities'] != null) {
        for (String amenity in filters['amenities'] as List<String>) {
          if (!property.amenities!.contains(amenity)) {
            return false;
          }
        }
      }
      if (filters['minPrice'] != null && filters['maxPrice'] != null) {
        if (property.price! < (filters['minPrice'] as num) || property.price! > (filters['maxPrice'] as num)) {
          return false;
        }
      }
      if (filters['bedrooms'] != null && property.bedrooms! < (filters['bedrooms'] as num)) {
        return false;
      }
      if (filters['beds'] != null && property.beds! < (filters['beds'] as num)) {
        return false;
      }
      if (filters['bathrooms'] != null && property.bathrooms! < (filters['bathrooms'] as num)) {
        return false;
      }
      return true;
    }).toList();
  });
}

 List<PropertyModel> _filterAndSortProperties(List<PropertyModel> properties) {
  List<PropertyModel> filteredProperties = properties.where((property) {
    return (property.city != null && property.city!.toLowerCase().contains(_searchQuery)) ||
           (property.state != null && property.state!.toLowerCase().contains(_searchQuery));
  }).toList();

  if (selectedSortOption == 'Price: Low to High') {
    filteredProperties.sort((a, b) {
      if (a.price == null && b.price == null) return 0;
      if (a.price == null) return 1;
      if (b.price == null) return -1;
      return a.price!.compareTo(b.price!);
    });
  } else if (selectedSortOption == 'Price: High to Low') {
    filteredProperties.sort((a, b) {
      if (a.price == null && b.price == null) return 0;
      if (a.price == null) return 1;
      if (b.price == null) return -1;
      return b.price!.compareTo(a.price!);
    });
  }

  // "Most Recent" option doesn't need explicit sorting since Firestore provides the default order
  return filteredProperties;
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            width: 350.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30.0),
              border: Border.all(color: Colors.grey),
            ),
            child: TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: const InputDecoration(
                hintText: 'Search by City or State...',
                border: InputBorder.none,
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              CupertinoIcons.slider_horizontal_3,
              color: Color.fromARGB(255, 255, 146, 99),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FilterPage()),
              );
            },
          ),
          StreamBuilder<int>(
            stream: notifVM.getUnreadTravelerNotificationsCount(
                AppConstants.currentUser.id!),
            builder: (context, snapshot) {
              int unreadCount = snapshot.data ?? 0;
              return Stack(
                children: [
                  IconButton(
                    icon: const Icon(
                      CupertinoIcons.bell,
                      color: Color.fromARGB(255, 255, 146, 99),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const NotificationPage()),
                      );
                    },
                  ),
                  if (unreadCount > 0)
                    Positioned(
                      right: 11,
                      top: 11,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 14,
                          minHeight: 14,
                        ),
                        child: Text(
                          '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add margin here
        child: Consumer<FilterModel>(
          builder: (context, filterModel, child) {
            return StreamBuilder<List<PropertyModel>>(
              stream: _propertyStream(filterModel),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching properties'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No properties found'));
                }

                final properties = snapshot.data!;
                final filteredAndSortedProperties =
                    _filterAndSortProperties(properties);

                return _buildPropertyList(filteredAndSortedProperties);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildPropertyList(List<PropertyModel> properties) {
    final propertiesToShow = properties;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              DropdownButton<String>(
                value: selectedSortOption,
                onChanged: (String? newValue) {
                  if (newValue != null && sortOptions.contains(newValue)) {
                    setState(() {
                      selectedSortOption = newValue;
                    });
                  }
                },
                items: sortOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: (propertiesToShow.length / _pageSize).ceil(),
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (BuildContext context, int pageIndex) {
              final start = pageIndex * _pageSize;
              final end = (pageIndex + 1) * _pageSize;
              final pageProperties = propertiesToShow.sublist(
                  start,
                  end < propertiesToShow.length
                      ? end
                      : propertiesToShow.length);

              return ListView.builder(
                itemCount: pageProperties.length,
                itemBuilder: (BuildContext context, int index) {
                  final property = pageProperties[index];
                  return PropertyCard(
                    property: property,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
