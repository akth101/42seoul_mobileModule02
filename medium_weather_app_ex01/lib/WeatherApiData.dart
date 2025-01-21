import 'package:flutter/material.dart';

class WeatherApiData extends ChangeNotifier {
  final String _location = "";
  final String _gpsLoading = "";

  String get location => _location;
  String get gpsLoading => _gpsLoading;
  //test


}