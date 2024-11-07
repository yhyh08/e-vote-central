import 'package:flutter/material.dart';

import '../../routes/route.dart';
import '../common/theme.dart';

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
      height: 65,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        color: Theme.of(context).primaryColorDark,
        boxShadow: const [boxShadow],
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
              Navigator.of(context).pushReplacementNamed(RouteList.myMap);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.location_pin,
                  color: widget.currentIndex == 1
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
                Text(
                  'Maps',
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
              Navigator.of(context).pushReplacementNamed(RouteList.booking);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.calendar_month,
                  color: widget.currentIndex == 2
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
                Text(
                  'Bookings',
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
              Navigator.of(context).pushReplacementNamed(RouteList.account);
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.settings,
                  color: widget.currentIndex == 3
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).dividerColor,
                ),
                Text(
                  'Account',
                  style: TextStyle(
                    color: widget.currentIndex == 3
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
