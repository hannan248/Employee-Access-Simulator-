import 'package:employee_access_simulator/access_simulator_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const EmployeeAccessApp());
}

class EmployeeAccessApp extends StatelessWidget {
  const EmployeeAccessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Employee Access Simulator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const AccessSimulatorScreen(),
    );
  }
}