import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '/screens/screens.dart';
//import 'package:tiki/authentications_bloc/cubits/signup_cubit.dart';
import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '/models/models.dart';

class BasicData extends StatelessWidget {
  final SignUpLoaded state;

  const BasicData({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = state.user;
    return SignUpScreenLayout(
      currentStep: 2,
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('STEP 2 OF 5',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 7),
                    const CustomTextHeader(text: 'What\'s your name?'),
                    const SizedBox(height: 7),
                    CustomTextField(
                      hint: 'John Doe',
                      icon: EvaIcons.person,
                      onChanged: (value) {
                        context
                            .read<SignUpBloc>()
                            .add(UpdateUser(user: user.copyWith(name: value)));
                      },
                    ),
                    const SizedBox(height: 30),
                    const CustomTextHeader(text: 'What\'s your age?'),
                    const SizedBox(height: 7),
                    CustomTextField(
                      hint: '20',
                      icon: EvaIcons.percent,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        context.read<SignUpBloc>().add(UpdateUser(
                            user: user.copyWith(age: int.parse(value))));
                      },
                    ),
                    const SizedBox(height: 30),
                    const CustomTextHeader(text: 'What\'s your gender?'),
                    const SizedBox(height: 7),
                    GenderWidget(
                        isSelected: (gender) {
                          return user.gender == gender;
                        },
                        onPressed: (gender) {
                          return () {
                            context.read<SignUpBloc>().add(UpdateUser(
                                user: user.copyWith(gender: gender)));
                          };
                        },
                        addFriendOption: false),
                    const SizedBox(height: 30),
                    const CustomTextHeader(text: 'What do yo search for?'),
                    const SizedBox(height: 7),
                    GenderWidget(
                        isSelected: (gender) {
                          if (gender == 'friend') {
                            return user.searchesForFriends;
                          }
                          return user.genderPreference.contains(gender);
                        },
                        onPressed: (gender) {
                          return () {
                            if (gender == 'friend') {
                              context.read<SignUpBloc>().add(UpdateUser(
                                  user: user.copyWith(
                                      searchesForFriends:
                                          !user.searchesForFriends)));
                              return;
                            }
                            List<String> preferences =
                                user.genderPreference.toList();
                            if (preferences.contains(gender)) {
                              preferences.remove(gender);
                            } else {
                              preferences.add(gender);
                            }
                            context.read<SignUpBloc>().add(UpdateUser(
                                user: user.copyWith(
                                    genderPreference: preferences)));
                          };
                        },
                        addFriendOption: true),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
