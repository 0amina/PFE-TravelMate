import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Places {
  Future<List<String>> fetchTunisiaStates() async {
    final response = await http.get(Uri.parse(
        'http://api.geonames.org/searchJSON?q=tunisia&maxRows=1000&username=haddadamamouranim&featureClass=P'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['geonames'];
      List<String> states = data
          .where((item) => item['countryCode'] == 'TN')
          .map<String>((item) => item['adminName1'].toString())
          .toList();
      return states;
    } else {
      throw Exception('Failed to load states');
    }
  }

  Future<List<String>> fetchTunisiaCities(String stateName) async {
    final response = await http.get(Uri.parse(
        'http://api.geonames.org/searchJSON?q=$stateName&maxRows=1000&username=haddadamamouranim&featureClass=P'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['geonames'];
      List<String> cityNames = data
          .where((item) => item['countryCode'] == 'TN')
          .map<String>((item) => item['name'].toString())
          .toList();
      return cityNames;
    } else {
      throw Exception('Failed to load cities for state $stateName');
    }
  }

  Future<LatLng?> fetchLatLngForCity(String cityName) async {
    final response = await http.get(Uri.parse(
        'http://api.geonames.org/searchJSON?q=$cityName&maxRows=1&username=haddadamamouranim&featureClass=P'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['geonames'];
      if (data.isNotEmpty) {
        final lat = double.parse(data[0]['lat']);
        final lng = double.parse(data[0]['lng']);
        return LatLng(lat, lng);
      }
    } else {
      throw Exception('Failed to load LatLng for city $cityName');
    }
    return null;
  }
}
