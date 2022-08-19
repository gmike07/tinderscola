import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const Color arrowColor = Color(0xFF00BFA5);
  // static const Color primaryLight = Color(0xFF00FFA5);
  // static const backgroundColor = Color(0xFFF5F5F5);
  // static const textfieldGrey = Color(0xFFE0E0E0);

  static const Color primary = Colors.red;
  static const Color primaryLight = Colors.red;
}

class ChatColors {
  //my messages
  static const Color myMessageColorBackground =
      Color.fromARGB(255, 255, 143, 135);
  static const Color myMessageTextColor = Colors.black;

  //matched messages
  static const Color matchedMessageColorBackground =
      Color.fromARGB(255, 253, 86, 86);
  static const Color matchedMessageTextColor = Colors.white;

  //heart data
  static const Color heartColor = AppColors.primary;
  static const double heartSize = 20;

  //button
  static const Color sendButtonBackgroundColor = AppColors.primary;
  static const Color sendButtonColor = Colors.white;

  static TextStyle nameStyle = GoogleFonts.aBeeZee(
    fontSize: 20,
    color: Colors.black,
  );
  static Color timestampColor = Colors.black;

  static TextStyle hintStyle = GoogleFonts.aBeeZee(
    color: Colors.grey,
  );
}

ThemeData theme() {
  return ThemeData(
      backgroundColor: const Color.fromARGB(255, 251, 152, 145),
      // ignore: deprecated_member_use
      accentColor: Colors.red,
      primaryColor: AppColors.primary,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      primaryColorLight: Colors.red,
      colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.red, accentColor: Colors.red)
          .copyWith(secondary: Colors.red));
}
