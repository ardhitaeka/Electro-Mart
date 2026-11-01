import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens.dart';
import 'store.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => StoreState(),
      child: const ElectroMartApp(),
    ),
  );
}

class ElectroMartApp extends StatelessWidget {
  const ElectroMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    const navy = Color(0xFF102345);
    return MaterialApp(
      title: 'ElectroMart',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF2563EB),
          primary: navy,
          surface: const Color(0xFFF7F9FC),
        ),
        scaffoldBackgroundColor: const Color(0xFFF7F9FC),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFF7F9FC),
          foregroundColor: navy,
          elevation: 0,
          centerTitle: false,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 15,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5EAF1)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFFE5EAF1)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
          ),
        ),
        cardTheme: CardThemeData(
          color: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFFEDF0F5)),
          ),
        ),
      ),
      home: const LoginScreen(),
    );
  }
}
