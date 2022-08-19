// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import '/screens/screens.dart';

class BottomNavigation extends StatelessWidget {
  final int selectedIndex;
  final void Function(int)? onTappedBar;

  void Function(int) _onTappedBar(BuildContext context) {
    return (int value) {
      if (value == 0) {
        Navigator.pushNamed(context, HomeScreen.routeName);
      }
      if (value == 1) {
        Navigator.pushNamed(context, MatchesScreen.routeName);
      }
      if (value == 2) {
        Navigator.pushNamed(context, ProfileScreen.routeName);
      }
    };
  }

  const BottomNavigation(
      {Key? key, required this.selectedIndex, this.onTappedBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedIndex,
      type: BottomNavigationBarType.fixed,
      onTap: onTappedBar ?? _onTappedBar(context),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 5,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/images/connect.png',
            height: 25,
            width: 25,
            color: selectedIndex == 0
                ? Theme.of(context).accentColor
                : Colors.grey,
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Stack(
            clipBehavior: Clip.none,
            children: [
              Image.asset(
                'assets/images/chat.png',
                height: 30,
                width: 30,
                color: selectedIndex == 1
                    ? Theme.of(context).accentColor
                    : Colors.grey,
              ),
              Positioned(
                top: -1,
                right: 0,
                child: Container(
                    height: 8,
                    width: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                    )),
              )
            ],
          ),
          label: 'Chat',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.person,
            size: 25,
            color: selectedIndex == 2
                ? Theme.of(context).accentColor
                : Colors.grey,
          ),
          label: 'profile',
        ),
      ],
    );
  }
}
