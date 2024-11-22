import 'package:flutter/material.dart';

import 'bottom_navigation.dart';

class TopBar extends StatelessWidget {
  final String title;
  final int index;
  final Widget body;
  final bool isBack;

  const TopBar({
    required this.title,
    required this.index,
    required this.body,
    this.isBack = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: (isBack)
            ? Text(
                title,
                style: Theme.of(context).textTheme.labelMedium,
              )
            : Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).primaryColor,
        leading: (isBack)
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back,
                  color: Theme.of(context).secondaryHeaderColor,
                ),
                onPressed: () {},
              )
            : null,
      ),
      backgroundColor: Theme.of(context).secondaryHeaderColor,
      bottomNavigationBar: BottomNavigation(currentIndex: index),
      body: body,
    );
  }
}
