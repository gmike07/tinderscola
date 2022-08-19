// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomTextButton extends StatelessWidget {
  final Widget widget;
  bool isPressed = false;
  final Function? onPressed;
  CustomTextButton({Key? key, required this.widget, this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: widget),
      IconButton(
          icon: const Icon(Icons.edit),
          color: isPressed ? Theme.of(context).accentColor : Colors.grey,
          onPressed: () {
            isPressed = !isPressed;
            if (onPressed != null) {
              onPressed!();
            }
          })
    ]);
  }
}
