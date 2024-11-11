import 'package:flutter/material.dart';

import 'bottom_navigation.dart';

class TopBar extends StatelessWidget {
  final String text;
  final int index;
  final Widget body;

  const TopBar({
    required this.text,
    required this.index,
    required this.body,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      bottomNavigationBar: BottomNavigation(currentIndex: index),
      body: body,
    );
  }
}
