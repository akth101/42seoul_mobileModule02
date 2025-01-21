import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherApiData extends ChangeNotifier {
  String _input = "";
  List<Map<String, dynamic>> _searchResults = [];

  String get input => _input;
  List<Map<String, dynamic>> get searchResults => _searchResults;

  void fetchCityData(String value) {
    _input = value;
    debugPrint("user input: $_input");
    searchCities(_input);
    notifyListeners();
  }


  Future<void> searchCities(String query) async {
    // 빈 검색어는 무시
    if (query.isEmpty) {
      return;
    }

    final url = Uri.parse(
      'https://geocoding-api.open-meteo.com/v1/search?name=$query&count=5'
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _searchResults = List<Map<String, dynamic>>.from(data['results'] ?? []);
        debugPrint('succeeded to fetch data from api');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }
}