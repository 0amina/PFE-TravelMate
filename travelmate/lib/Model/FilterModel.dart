import 'package:flutter/foundation.dart';

class FilterModel extends ChangeNotifier {
  String? _category;
  List<String>? _amenities;
  int _bedrooms = 0;
  int _bathrooms = 0;
  int _beds = 0;
  double _minPrice = 0.0;
  double _maxPrice = 3000.0;

  String? get category => _category;
  List<String>? get amenities => _amenities;
  int get bedrooms => _bedrooms;
  int get bathrooms => _bathrooms;
  int get beds => _beds;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  void setCategory(String? category) {
    _category = category;
    notifyListeners();
  }

  void setAmenities(List<String>? amenities) {
    _amenities = amenities;
    notifyListeners();
  }

  void setRooms(int bedrooms) {
    _bedrooms = bedrooms;
    notifyListeners();
  }

  void setBathrooms(int bathrooms) {
    _bathrooms = bathrooms;
    notifyListeners();
  }

  void setBeds(int beds) {
    _beds = beds;
    notifyListeners();
  }

  void setPriceRange(double minPrice, double maxPrice) {
    _minPrice = minPrice;
    _maxPrice = maxPrice;
    notifyListeners();
  }

  void applyFilters() {
    notifyListeners();
  }

  void clearFilters() {
    _category = null;
    _amenities = null;
    _bedrooms = 0;
    _bathrooms = 0;
    _beds = 0;
    _minPrice = 0.0;
    _maxPrice = 3000.0;
    notifyListeners();
  }
}
