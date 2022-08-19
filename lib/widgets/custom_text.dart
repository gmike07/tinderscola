import 'package:flutter/material.dart';
import 'package:tinderscola_final/config/constants.dart';

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextOverflow? overflow;
  final TextAlign? textAlign;
  final bool? softWrap;
  const CustomText(
      {Key? key,
      required this.text,
      this.style,
      this.overflow,
      this.textAlign,
      this.softWrap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isHebrew = false;
    for (int i = 0; i < AppConstants.hebrewLetters.length; i++) {
      if (text.contains(AppConstants.hebrewLetters[i])) {
        isHebrew = true;
        break;
      }
    }
    if (!isHebrew) {
      return Text(text,
          style: style,
          overflow: overflow,
          textAlign: textAlign,
          softWrap: softWrap);
    } else {
      return Text(text,
          style: style,
          overflow: overflow,
          textDirection: TextDirection.rtl,
          textAlign: textAlign,
          softWrap: softWrap);
    }
  }
}
