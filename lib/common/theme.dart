import 'package:flutter/material.dart';

final ThemeData theme = ThemeData.light().copyWith(
  scaffoldBackgroundColor: const Color(0xFF7A1CAC),
  secondaryHeaderColor: Colors.white,
  primaryColorLight: const Color(0xFFDDE0F8),
  primaryColorDark: Colors.black,
  primaryColor: const Color(0xFFAD49E1),
  dialogBackgroundColor: const Color(0xFF3E3E3E),
  dividerColor: const Color.fromARGB(255, 209, 209, 209),
  highlightColor: const Color(0xFF1C1C1C),
  hintColor: const Color(0xFFFF4154),
  focusColor: Colors.green[400],
  shadowColor: Colors.grey.withOpacity(0.1),
  splashColor: Colors.white,
  iconTheme: const IconThemeData(
    color: Color(0xFF808080),
    size: 20,
  ),
  textTheme: const TextTheme(
    displayLarge: TextStyle(
      fontSize: 36,
      color: Colors.black,
      height: 1.2,
    ),
    displayMedium: TextStyle(
      fontSize: 34,
      color: Colors.black,
      height: 1.2,
      fontWeight: FontWeight.w800,
    ),
    displaySmall: TextStyle(
      fontSize: 32,
      color: Colors.black,
    ),
    headlineLarge: TextStyle(
      fontSize: 26,
      color: Color(0xFF949494),
      fontWeight: FontWeight.w700,
    ),
    headlineMedium: TextStyle(
      fontSize: 26,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    headlineSmall: TextStyle(
      fontSize: 20,
      color: Color(0xFF1C1C1C),
      fontWeight: FontWeight.bold,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      color: Color(0xFF949494),
    ),
    titleMedium: TextStyle(
      fontSize: 18,
      color: Colors.black,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: TextStyle(
      fontSize: 16,
      color: Colors.black,
      fontWeight: FontWeight.bold,
    ),
    labelLarge: TextStyle(
      fontSize: 20,
      color: Color(0xFF4F4F4F),
    ),
    labelMedium: TextStyle(
      fontSize: 18,
      color: Colors.white,
      fontWeight: FontWeight.w700,
    ),
    labelSmall: TextStyle(
      fontSize: 12,
      color: Color(0xFFAAAAAA),
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: Color(0xFF1C1C1C),
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      color: Color(0xFFAD49E1),
    ),
  ).apply(fontFamily: 'SF Pro Display'),
);

// final boxDeco = BoxDecoration(
//   border: Border.all(color: Colors.black),
//   borderRadius: BorderRadius.circular(15),
// );

// const boxShadow = BoxShadow(
//   color: Color.fromARGB(22, 0, 0, 28),
//   spreadRadius: 2,
//   blurRadius: 15,
//   offset: Offset(0, 2),
// );

// 0xFFD0A2F7
// 0xFFDCBFFF
// 0xFFEBD3F8
// 0xFFF1EAFF
// 0xFFF6DEF6
// 0xFF910A67

// 0xFF6d31ed