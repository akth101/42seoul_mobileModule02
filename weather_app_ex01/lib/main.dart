import 'package:flutter/material.dart';
import 'WeatherUI.dart';
import 'package:provider/provider.dart';
import 'LocationData.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => LocationData(),
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

