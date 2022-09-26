import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinderscola_final/config/constants.dart';

import '/blocs/signup/signup_bloc.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/signup/signup_cubit.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import '/models/models.dart';

class Email extends StatelessWidget {
  final SignUpLoaded state;

  const Email({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignUpScreenLayout(
      currentStep: 1,
      state: state,
      onPressed: () async {
        if (BlocProvider.of<SignupCubit>(context).state.status ==
            FormzStatus.valid) {
          await context.read<SignupCubit>().signUpWithCredentials();
          // ignore: use_build_context_synchronously
          if (BlocProvider.of<SignupCubit>(context).state.status ==
              FormzStatus.submissionSuccess) {
            // ignore: use_build_context_synchronously
            context.read<SignUpBloc>().add(
                  ContinueSignUp(
                    isSignup: true,
                    user: User.empty.copyWith(
                      // ignore: use_build_context_synchronously
                      id: context.read<SignupCubit>().state.user!.uid,
                    ),
                  ),
                );
          }
        } else {
          AppConstants.showToast('Check your email and password');
        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('STEP 1 OF 5',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.roboto(
                              fontSize: 15,
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const CustomTextHeader(text: 'What\'s Your Email Address?'),
                  const SizedBox(height: 7),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.email != current.email,
                    builder: (context, state) {
                      return CustomTextField(
                        hint: 'JohnDoe@gmail.com',
                        icon: Icons.email,
                        errorText: state.email.invalid
                            ? 'The email is invalid.'
                            : null,
                        onChanged: (value) {
                          context.read<SignupCubit>().emailChanged(value);
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  const CustomTextHeader(text: 'Choose a Password'),
                  const SizedBox(height: 7),
                  BlocBuilder<SignupCubit, SignupState>(
                    buildWhen: (previous, current) =>
                        previous.password != current.password,
                    builder: (context, state) {
                      return CustomTextField(
                        icon: EvaIcons.lock,
                        hint: '********',
                        errorText: state.password.invalid
                            ? 'The password must contain at least 8 characters \n'
                                'at least one letter and one number.'
                            : null,
                        onChanged: (value) {
                          context.read<SignupCubit>().passwordChanged(value);
                        },
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}
