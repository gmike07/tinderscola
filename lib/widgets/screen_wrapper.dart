import 'package:flutter/material.dart';
import '/widgets/widgets.dart';

class ScreenWrapper extends StatelessWidget {
  final int selectedTab;
  final Widget child;
  final void Function(int)? onTappedBar;
  const ScreenWrapper(
      {Key? key,
      required this.selectedTab,
      required this.child,
      this.onTappedBar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: child,
      bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withAlpha(50),
                blurRadius: 5,
              ),
            ],
          ),
          child: BottomNavigation(
            selectedIndex: selectedTab,
            onTappedBar: onTappedBar,
          )),
    );
  }
}
