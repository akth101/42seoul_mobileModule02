import 'package:flutter/material.dart';

class WeatherApiData extends ChangeNotifier {
  String _input = "";
  String _gpsLoading = "";

  String get input => _input;
  String get gpsLoading => _gpsLoading;
  //test

  void fetchCityData(String value) {
    _input = value;
    debugPrint("user input: $_input");
    
    notifyListeners();
  }

}