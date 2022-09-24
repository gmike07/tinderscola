// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:tinderscola_final/config/constants.dart';

class GenderWidget extends StatelessWidget {
  final Function isSelected;
  final Function onPressed;
  final bool addFriendOption;
  const GenderWidget(
      {Key? key,
      required this.isSelected,
      required this.onPressed,
      required this.addFriendOption})
      : super(key: key);

  static IconData getGenderIcon(BuildContext context, String gender) {
    if (gender == 'male') {
      return Icons.male;
    }
    if (gender == 'female') {
      return Icons.female;
    }
    if (gender == 'transgender') {
      return Icons.transgender;
    }
    return Icons.person_add_alt;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> icons = [];
    for (var gender in AppConstants.genders) {
      icons.add(_buildIcon(context, getGenderIcon(context, gender),
          isSelected: isSelected(gender), onPressed: onPressed(gender)));
    }
    if (addFriendOption) {
      icons.add(_buildIcon(context, getGenderIcon(context, 'friend'),
          isSelected: isSelected('friend'), onPressed: onPressed('friend')));
    }
    return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: icons);
  }

  Widget _buildIcon(BuildContext context, IconData icon,
      {required bool isSelected, required VoidCallback onPressed}) {
    return Container(
        margin: const EdgeInsets.all(5),
        padding: const EdgeInsets.all(5),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: !isSelected
              ? Colors.white
              : const Color.fromARGB(255, 232, 232, 232),
          border: Border.all(
              color: Colors.black, // Set border color
              width: 2.0), // Set border width
          borderRadius: const BorderRadius.all(Radius.circular(5.0)),
        ),
        child: IconButton(
          icon: Icon(icon, size: 25, color: Theme.of(context).accentColor),
          onPressed: onPressed,
        ));
  }
}
