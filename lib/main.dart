import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PaniPuriApp());
}

class PaniPuriApp extends StatelessWidget {
  const PaniPuriApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pani, Puri & Paps | The Funky Street Food',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true),
      home: const HomeScreen(),
    );
  }
}
