import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/blocs/blocs.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';
import '/models/models.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class Specifics extends StatelessWidget {
  final SignUpLoaded state;

  const Specifics({
    Key? key,
    required this.state,
  }) : super(key: key);

  final List<String> programNames = const [
    'אלפא',
    'אודיסיאה',
    'אידיאה',
    'אולימפיאדה'
  ];
  final List<String> programPlaces = const [
    'ויצמן',
    'אריאל',
    'תל חי',
    'הטכניון',
    'העברית',
    'תל אביב',
    'בר אילן',
    'בן גוריון'
  ];
  @override
  Widget build(BuildContext context) {
    User user = state.user;
    return SignUpScreenLayout(
        currentStep: 3,
        state: state,
        onPressed: () {
          context.read<SignUpBloc>().add(ContinueSignUp(user: state.user));
        },
        children: [
          SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('STEP 3 OF 5',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          fontSize: 15,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500)),
                  const SizedBox(height: 7),
                  const CustomTextHeader(text: 'In what program were you in?'),
                  const SizedBox(height: 7),
                  Choices(
                      options: programNames,
                      isSelected: (programName) {
                        return user.programName == programName;
                      },
                      onPressed: (programName) {
                        return () {
                          context.read<SignUpBloc>().add(UpdateUser(
                              user: user.copyWith(programName: programName)));
                        };
                      }),
                  const SizedBox(height: 30),
                  const CustomTextHeader(
                      text: 'Where was the program located at?'),
                  const SizedBox(height: 7),
                  Choices(
                      options: programPlaces,
                      isSelected: (programPlace) {
                        return user.programPlace == programPlace;
                      },
                      onPressed: (programPlace) {
                        return () {
                          context.read<SignUpBloc>().add(UpdateUser(
                              user: user.copyWith(programPlace: programPlace)));
                        };
                      }),
                ]),
              ],
            ),
          ))
        ]);
  }
}
