import 'package:flutter/material.dart';
import 'WeatherUI.dart';
import 'package:provider/provider.dart';
import 'GpsData.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => GpsData(),
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

