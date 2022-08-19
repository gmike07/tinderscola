// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/widgets/widgets.dart';

class CustomTextContainer extends StatelessWidget {
  final String text;
  final bool isSelected;
  final VoidCallback onPressed;

  const CustomTextContainer(
      {Key? key,
      required this.text,
      required this.onPressed,
      this.isSelected = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
          right: 5,
        ),
        child: Stack(
          children: [
            Container(
              height: 95,
              width: MediaQuery.of(context).size.width / 1 - 10,
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 3),
                    blurRadius: 10,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 3),
                    blurRadius: 10,
                  )
                ],
              ),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: CustomText(
                      text: text,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.aBeeZee(
                        fontSize: 15,
                        color: Colors.black,
                      )),
                ),
              ),
            ),
            Visibility(
              visible: isSelected,
              child: Positioned(
                  bottom: 3,
                  right: 10,
                  child: Icon(
                    Icons.verified,
                    color: Theme.of(context).accentColor,
                    size: 15,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
