import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'WeatherDataManager.dart';

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
  WeatherData? weatherData;


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
        debugPrint('succeeded to fetch [city data] from api');
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
          'Longitude: ${result['longitude']} '
          'admin1: ${result['admin1']}'
          );
    }
  }

  Future<void> fetchWeather(double lat, double lon) async {
    final response = await http.get(Uri.parse(
      'https://api.open-meteo.com/v1/forecast?'
      'latitude=$lat&longitude=$lon'
      '&current=temperature_2m,weathercode,windspeed_10m'
      '&hourly=temperature_2m,weathercode,windspeed_10m'
      '&daily=temperature_2m_max,temperature_2m_min,weathercode,windspeed_10m_max'
      '&timezone=auto'
    ));
    if (response.statusCode == 200) {
      debugPrint('succeeded to fetch [weather data] from api');
      final decodedData = jsonDecode(response.body);
      _debugWeatherData(decodedData);  // 디버그 출력 추가
      weatherData = WeatherData.fromJson(decodedData);
      notifyListeners();
    }
  }

  void _debugWeatherData(Map<String, dynamic> data) {
    debugPrint('\n=== Weather Data Debug ===');
    debugPrint('Current:');
    debugPrint('  Temperature: ${data['current']['temperature_2m']}');
    debugPrint('  WeatherCode: ${data['current']['weathercode']}');
    debugPrint('  WindSpeed: ${data['current']['windspeed_10m']}');
    
    debugPrint('\nHourly (first 3 entries):');
    for (var i = 0; i < 3; i++) {
      debugPrint('  ${data['hourly']['time'][i]}: '
          '${data['hourly']['temperature_2m'][i]}°C, '
          'Code: ${data['hourly']['weathercode'][i]}, '
          'Wind: ${data['hourly']['windspeed_10m'][i]}');
    }
    
    debugPrint('\nDaily (first 3 days):');
    for (var i = 0; i < 3; i++) {
      debugPrint('  ${data['daily']['time'][i]}: '
          'Max: ${data['daily']['temperature_2m_max'][i]}°C, '
          'Min: ${data['daily']['temperature_2m_min'][i]}°C');
    }
    debugPrint('========================\n');
  }
}

// {
//   "latitude": 52.52,
//   "longitude": 13.419,
//   "timezone": "Europe/Berlin",
//   "current": {
//     "temperature_2m": 15.3,
//     "weathercode": 1,
//     "windspeed_10m": 5.2
//   },
//   "hourly": {
//     "time": ["2024-01-21T00:00", "2024-01-21T01:00", ...],
//     "temperature_2m": [13.2, 12.8, ...],
//     "weathercode": [1, 1, ...],
//     "windspeed_10m": [4.3, 4.5, ...]
//   },
//   "daily": {
//     "time": ["2024-01-21", "2024-01-22", ...],
//     "temperature_2m_max": [16.2, 15.8, ...],
//     "temperature_2m_min": [8.1, 7.5, ...],
//     "weathercode": [1, 2, ...],
//     "windspeed_10m_max": [8.2, 7.9, ...]
//   }
// }