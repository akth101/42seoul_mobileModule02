import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// WeatherApiData Class
/// 
/// Public Methods:
/// - String get input
/// - List<Map<String, dynamic>> get searchResults
/// - Future<void> fetchCityData(String value)
/// - Future<void> searchCities(String query)
/// 
/// Private Methods:
/// - void _printSearchResults()

class WeatherApiData extends ChangeNotifier {
  String _input = "";
  List<Map<String, dynamic>> _searchResults = [];

  String get input => _input;
  List<Map<String, dynamic>> get searchResults => _searchResults;

  Future<void> fetchCityData(String value) async {
    _input = value;
    debugPrint("user input: $_input");
    await searchCities(_input);
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
        final data = json.decode(response.body); //decode 메서드가 인자로 들어온 데이터를 알맞은 데이터 구조로 변환(여기서는 맵)
        _searchResults = List<Map<String, dynamic>>.from(data['results'] ?? []); //data map에서 key가 results인 얘들을 모아서 리스트로 만들어줌
        _printSearchResults(); // 결과 출력 함수 호출
        debugPrint('succeeded to fetch data from api');
      }
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _printSearchResults() {
    for (var result in _searchResults) {
      debugPrint('City: ${result['name']}, '
          'Country: ${result['country']}, '
          'Latitude: ${result['latitude']}, '
          'Longitude: ${result['longitude']}');
    }
  }
}