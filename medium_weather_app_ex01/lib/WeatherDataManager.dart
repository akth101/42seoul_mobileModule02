//시간별 날씨
class HourlyWeather {
  final DateTime time;
  final double temperature;
  final int weathercode;
  final double windspeed;

  HourlyWeather({
    required this.time,
    required this.temperature,
    required this.weathercode,
    required this.windspeed,
  });
}

// 일별 날씨
class DailyWeather {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final int weathercode;
  final double windspeed;

  DailyWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.weathercode,
    required this.windspeed,
  });
}

// 전체 날씨 데이터를 관리
class WeatherData {
  final Map<String, dynamic> current;
  final Map<String, dynamic> hourly;
  final Map<String, dynamic> daily;

  WeatherData({
    required this.current,
    required this.hourly,
    required this.daily,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    return WeatherData(
      current: json['current'],
      hourly: json['hourly'],
      daily: json['daily'],
    );
  }
}