import 'package:flutter/material.dart';

import 'common/theme.dart';
import 'routes/route.dart';
import 'screens/home/dashboard.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      // home: const SplashScreen(),
      home: const Dashboard(),
      onGenerateRoute: RouteGenerator.generateRoute,
    );
  }
}
