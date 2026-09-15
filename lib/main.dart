import 'package:flutter/material.dart';
import 'pantry_screen.dart';

void main() {
  runApp(const PantryOrganizerApp());
}

class PantryOrganizerApp extends StatelessWidget {
  const PantryOrganizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pantry Organizer',
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
        ),
      ),
      home: const PantryScreen(),
    );
  }
}
