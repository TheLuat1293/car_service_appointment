import 'package:flutter/material.dart';
import 'package:car_service_appointment/screens/start_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const StartScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
