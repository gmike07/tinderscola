import 'package:flutter/material.dart';
import '/config/constants.dart';

class HerbrewCustomTextFieldWrapper extends StatefulWidget {
  final String? hint;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final InputDecoration? decoration;
  const HerbrewCustomTextFieldWrapper(
      {Key? key,
      this.hint,
      this.controller,
      this.keyboardType,
      this.onChanged,
      this.decoration})
      : super(key: key);

  TextDirection getDirection(String text) {
    for (int i = 0; i < AppConstants.hebrewLetters.length; i++) {
      if (text.contains(AppConstants.hebrewLetters[i])) {
        return TextDirection.rtl;
      }
    }
    return TextDirection.ltr;
  }

  @override
  State<HerbrewCustomTextFieldWrapper> createState() =>
      _HerbrewCustomTextFieldWrapperState();
}

class _HerbrewCustomTextFieldWrapperState
    extends State<HerbrewCustomTextFieldWrapper> {
  final ValueNotifier<TextDirection> _textDir =
      ValueNotifier(TextDirection.ltr);
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<TextDirection>(
        valueListenable: _textDir,
        builder: (context, value, child) => TextField(
              textDirection: _textDir.value,
              decoration: widget.decoration,
              controller: widget.controller,
              keyboardType: widget.keyboardType,
              onChanged: (input) {
                final dir = widget.getDirection(input);
                if (_textDir.value != dir) {
                  _textDir.value = dir;
                }

                if (widget.onChanged != null) {
                  widget.onChanged!(input);
                }
              },
            ));
  }
}
// // ignore: must_be_immutable
// class HerbrewCustomTextFieldWrapper extends StatelessWidget {
//   final String? hint;
//   final TextEditingController? controller;
//   final TextInputType? keyboardType;
//   final void Function(String)? onChanged;
//   TextDirection textDirection = TextDirection.ltr;
//   final InputDecoration? decoration;
//   HerbrewCustomTextFieldWrapper(
//       {Key? key,
//       this.hint,
//       this.controller,
//       this.keyboardType,
//       this.onChanged,
//       this.decoration})
//       : super(key: key);

//   TextDirection getDirection(String text) {
//     for (int i = 0; i < AppConstants.hebrewLetters.length; i++) {
//       if (text.contains(AppConstants.hebrewLetters[i])) {
//         return TextDirection.rtl;
//       }
//     }
//     return TextDirection.ltr;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       textDirection: textDirection,
//       decoration: decoration,
//       controller: controller,
//       keyboardType: keyboardType,
//       onChanged: (input) {
//         final dir = getDirection(input);
//         if (dir != textDirection) {
//           textDirection = dir;
//           // ignore: unused_element
//           setState() {}
//         }
//       },
//     );
//   }
// }
