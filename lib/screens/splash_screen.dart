import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../routes/route.dart';
import '../gen/assets.gen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<bool> checkUserLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  void initState() {
    super.initState();
    initialization();
  }

  // delay for show splash screen
  initialization() async {
    final bool isLoggedIn = await checkUserLoginStatus();

    if (isLoggedIn) {
      await Future.microtask(() {
        if (mounted) nextPage();
      });
    } else {
      await Future.delayed(const Duration(milliseconds: 3500), () {
        if (mounted) nextPage();
      });
    }
  }

  // after splash screen show
  void nextPage() {
    Navigator.of(context).pushReplacementNamed(RouteList.welcome);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Assets.images.logo.image(
                    width: MediaQuery.of(context).size.width / 1.5,
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 60, vertical: 10),
                    child: LinearProgressIndicator(
                      backgroundColor: Theme.of(context).primaryColorLight,
                      color: Theme.of(context).primaryColor,
                      minHeight: 5,
                    ),
                  ),
                  Text(
                    "Loading...",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
