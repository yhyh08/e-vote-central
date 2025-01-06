import 'package:flutter/material.dart';

import '../../routes/route.dart';

class BottomNavigation extends StatefulWidget {
  final int currentIndex;

  const BottomNavigation({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  BottomNavigationStatus createState() => BottomNavigationStatus();
}

class BottomNavigationStatus extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RouteList.dashboard);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.home,
                  color: widget.currentIndex == 0
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
                Text(
                  'Home',
                  style: TextStyle(
                    color: widget.currentIndex == 0
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RouteList.election);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.how_to_vote_rounded,
                  color: widget.currentIndex == 1
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
                Text(
                  'Election',
                  style: TextStyle(
                    color: widget.currentIndex == 1
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RouteList.result);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.bar_chart_rounded,
                  color: widget.currentIndex == 2
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
                Text(
                  'Result',
                  style: TextStyle(
                    color: widget.currentIndex == 2
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(RouteList.registerStatus);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.book_outlined,
                  color: widget.currentIndex == 3
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
                Text(
                  'Apply',
                  style: TextStyle(
                    color: widget.currentIndex == 3
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
          ),
          InkWell(
            onTap: () {
              Navigator.of(context).pushReplacementNamed(RouteList.profile);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.account_circle_outlined,
                  color: widget.currentIndex == 4
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
                Text(
                  'Account',
                  style: TextStyle(
                    color: widget.currentIndex == 4
                        ? Theme.of(context).primaryColor
                        : Theme.of(context).dividerColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
