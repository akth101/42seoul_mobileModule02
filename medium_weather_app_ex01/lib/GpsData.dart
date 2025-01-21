import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GpsData extends ChangeNotifier {
  String _location = "";
  final String _gpsLoading = "";

  String get location => _location;
  String get gpsLoading => _gpsLoading;

  Future<void> getCurrentLocation() async {
    try {
      final startTime = DateTime.now();
      
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        // 2. 권한 요청 시간 측정
        final permRequestStart = DateTime.now();
        debugPrint('권한 요청 시작: ${DateTime.now()}');
        permission = await Geolocator.requestPermission();
        debugPrint('권한 요청 완료: ${DateTime.now().difference(permRequestStart)}');
        
        if (permission == LocationPermission.denied) {
          _location = '위치 권한이 거부되었습니다';
          notifyListeners();
          return;
        }
      }

      // 3. 실제 위치 가져오는 시간 측정
      final positionStart = DateTime.now();
      debugPrint('위치 가져오기 시작: ${DateTime.now()}');
      Position position = await Geolocator.getCurrentPosition();
      // _gpsLoading = DateTime.now().difference(positionStart);
      debugPrint('위치 가져오기 완료: ${DateTime.now().difference(positionStart)}');

      
      _location = '위도: ${position.latitude}\n경도: ${position.longitude}';
      notifyListeners();
      
      // 전체 소요 시간
      debugPrint('전체 소요 시간: ${DateTime.now().difference(startTime)}');
  }
    catch (e) {
        _location = '위치를 가져오는데 실패했습니다';
        notifyListeners();
    }
  }

}