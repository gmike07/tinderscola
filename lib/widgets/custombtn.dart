// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/widgets.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? textColor;
  final Color? beginColor;
  final Color? endColor;

  const CustomButton(
      {Key? key,
      required this.text,
      this.onPressed,
      this.textColor,
      this.beginColor,
      this.endColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: LinearGradient(
          colors: [
            beginColor ?? Theme.of(context).accentColor,
            endColor ?? Theme.of(context).primaryColor,
          ],
        ),
      ),
      child: ElevatedButton(
        onPressed: () {
          if (onPressed != null) {
            onPressed!();
          }
        },
        style: ElevatedButton.styleFrom(
          primary: Colors.transparent,
          elevation: 0,
        ),
        child: SizedBox(
          width: double.infinity,
          child: Center(
            child: CustomText(
                text: text,
                style: GoogleFonts.aBeeZee(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: textColor)),
          ),
        ),
      ),
    );
  }
}
