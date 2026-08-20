import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ContactManagementApp());
}

class ContactManagementApp extends StatefulWidget {
  const ContactManagementApp({super.key});

  @override
  State<ContactManagementApp> createState() => _ContactManagementAppState();
}

class _ContactManagementAppState extends State<ContactManagementApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void setDarkMode(bool enabled) {
    setState(() {
      _themeMode = enabled ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF4B4BEA);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contact Management App',
      themeMode: _themeMode,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE1E1E1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primary, width: 1.4),
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          brightness: Brightness.dark,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: primary,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: HomeScreen(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: setDarkMode,
      ),
    );
  }
}
