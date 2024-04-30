import 'package:flutter/material.dart';
import 'package:ueek_tempo/screens/forecast.screen.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const ForecastScreen(),
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromRGBO(31, 33, 40, 1),
        cardTheme: const CardTheme(
          color: Color.fromRGBO(41, 44, 53, 1),
        ),
        textTheme: Theme.of(context).textTheme.apply(
          bodyColor: const Color.fromRGBO(175, 175, 176, 1),
          displayColor: const Color.fromRGBO(175, 175, 176, 1),
          fontFamily: 'Mukta',
        ),
      ),
    );
  }
}
