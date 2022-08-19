import 'package:flutter/material.dart';
import 'widgets.dart';

class Choices extends StatelessWidget {
  final double? height;
  final double? width;
  final bool Function(String) isSelected;
  final VoidCallback Function(String) onPressed;
  final List<String> options;
  const Choices(
      {Key? key,
      this.height,
      this.width,
      required this.isSelected,
      required this.onPressed,
      required this.options})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height ?? MediaQuery.of(context).size.height / 4,
      width: width ?? double.infinity,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        child: GridView.count(
          shrinkWrap: true,
          childAspectRatio: 21 / 11,
          mainAxisSpacing: 10,
          crossAxisCount: 3,
          children: options.map((option) {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: CustomTextContainer(
                  isSelected: isSelected(option),
                  onPressed: onPressed(option),
                  text: option),
            );
          }).toList(),
        ),
      ),
    );
  }
}
