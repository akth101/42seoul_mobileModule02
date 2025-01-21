import 'package:flutter/material.dart';
import 'WeatherUI.dart';
import 'package:provider/provider.dart';
import 'WeatherApiData.dart';
import 'GpsData.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GpsData()),
        ChangeNotifierProvider(create: (_) => WeatherApiData()),
      ],
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const WeatherUI();
  }
}

