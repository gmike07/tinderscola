import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/widgets.dart';

class CustomTextHeader extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const CustomTextHeader({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomText(
        text: text,
        style: style ??
            GoogleFonts.aBeeZee(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ));
  }
}
