import 'package:flutter/material.dart';


class LocationData extends ChangeNotifier {
  String _location = "";
  final String _geo = "Geolocation";
  int _flag = 0;

  String get location => _location;
  String get geo => _geo;
  int get flag => _flag;

  void fixLocation(String value) {
    _location = value;
    debugPrint("changed location in provider: $_location");
    notifyListeners();
  }

  void fixGeoLocation() {
    if (_location != "Geolocation") {
      _location = "Geolocation";
      _flag = 1;
    }
    else if (_flag == 0) {
      _location = "Geolocation";
      _flag = 1;
    } else {
      _location = "";
      _flag = 0;
    }
    notifyListeners();
  }
}