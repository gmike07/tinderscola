// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinderscola_final/config/constants.dart';
import 'package:tinderscola_final/repositories/database/database_repository.dart';
import '/blocs/signup/signup_bloc.dart';
import '/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/cubits.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import '/screens/screens.dart';
import '/models/models.dart';

class Phone extends StatelessWidget {
  final SignUpLoaded state;

  const Phone({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubitPhone, SignupStatePhone>(
        builder: (context, state_) {
      if (state_.enterPhone) {
        return EnterPhoneNumber(state: state);
      }
      return EnterOTP(state: state);
    });
  }
}

class EnterPhoneNumber extends StatelessWidget {
  final SignUpLoaded state;

  const EnterPhoneNumber({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  const CustomTextHeader(text: 'What\'s Your Phone Number?'),
                  const SizedBox(height: 7),
                  BlocBuilder<SignupCubitPhone, SignupStatePhone>(
                    builder: (context, state) {
                      return PhoneNumberWidget(
                        defaultCountry:
                            context.read<SignupCubitPhone>().getCountryName(),
                        onPhoneNumberChange: (val) => context
                            .read<SignupCubitPhone>()
                            .phoneNumberChanged(val),
                        onPhoneCodeChange: (country) => context
                            .read<SignupCubitPhone>()
                            .countryCodeChanged(
                                country.phoneCode, country.isoCode),
                        showError: state.status == FormzStatus.invalid,
                        priorityList: const ['IL', 'US'],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<SignupCubitPhone, SignupStatePhone>(
                      builder: (context, state) {
                    return CustomButton(
                      text: 'Verify phone number',
                      onPressed: () async {
                        if (state.status == FormzStatus.invalid) {
                          AppConstants.showToast('Check your phone number');
                        }
                        var allowedNumber = await DatabaseRepository()
                            .isAllowedNumber(context
                                .read<SignupCubitPhone>()
                                .getPhoneNumber());
                        if (!allowedNumber) {
                          AppConstants.showToast(
                              '${context.read<SignupCubitPhone>().getPhoneNumberString()} is not allowed to sign up');
                        } else {
                          context.read<SignupCubitPhone>().sendSMS(context);
                        }
                      },
                    );
                  })
                ],
              ),
            ],
          ),
        )
      ],
    );
  }
}

class EnterOTP extends StatelessWidget {
  final SignUpLoaded state;

  const EnterOTP({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SignUpScreenLayout(
        currentStep: 1,
        state: state,
        onPressed: () async {
          if (BlocProvider.of<SignupCubitPhone>(context).state.status ==
              FormzStatus.valid) {
            var success =
                await context.read<SignupCubitPhone>().validateSMS(context);
            if (success) {
              context.read<SignUpBloc>().add(
                    ContinueSignUp(
                      isSignup: true,
                      user: User.empty.copyWith(
                        // ignore: use_build_context_synchronously
                        id: context.read<SignupCubitPhone>().state.user!.uid,
                      ),
                    ),
                  );
            }
          } else {
            AppConstants.showToast('you entered a wrong verification code');
          }
        },
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                    const CustomTextHeader(text: 'Phone Number Verification'),
                    const SizedBox(height: 7),
                    CustomText(
                        text:
                            'enter the code sent to ${context.read<SignupCubitPhone>().getPhoneNumberString()}.'),
                    const SizedBox(height: 20),
                    BlocBuilder<SignupCubitPhone, SignupStatePhone>(
                      builder: (context, state) {
                        return OTPTextField(onChanged: (val) {
                          context.read<SignupCubitPhone>().setOTP(val);
                        });
                      },
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(text: 'Didn\'t receive the code?'),
                          TextButton(
                              onPressed: () {
                                context
                                    .read<SignupCubitPhone>()
                                    .sendSMS(context);
                              },
                              child: const Text('Resend',
                                  style: TextStyle(color: Colors.red)))
                        ]),
                  ],
                ),
              ],
            ),
          )
        ]);
  }
}
