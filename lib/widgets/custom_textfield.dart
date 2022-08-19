import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/widgets.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
  final Function(String)? onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  const CustomTextField(
      {Key? key,
      required this.hint,
      required this.icon,
      this.onChanged,
      this.keyboardType,
      this.errorText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HerbrewCustomTextFieldWrapper(
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hint,
        errorText: errorText,
        suffixIcon: Icon(icon),
        hintStyle: GoogleFonts.aBeeZee(
          fontSize: 13,
          color: Colors.grey,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
