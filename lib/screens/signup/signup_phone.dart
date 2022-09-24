import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '/blocs/signup/signup_bloc.dart';
//import 'package:tiki/authentications_bloc/cubits/signup_cubit.dart';
import '/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/cubits.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

class Phone extends StatelessWidget {
  final SignUpLoaded state;

  const Phone({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubitPhone, SignupStatePhone>(
        buildWhen: (previous, current) =>
            previous.phoneNumber != current.phoneNumber,
        builder: (context, state_) {
          return EnterPhoneNumber(state: state);
        });
  }
}

class EnterPhoneNumber extends StatelessWidget {
  final SignUpLoaded state;

  const EnterPhoneNumber({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
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
                    buildWhen: (previous, current) =>
                        previous.phoneNumber != current.phoneNumber,
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
                                  country.isoCode, country.name),
                          showError: state.status == FormzStatus.invalid);
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<SignupCubitPhone, SignupStatePhone>(
                      buildWhen: (previous, current) =>
                          previous.phoneNumber != current.phoneNumber,
                      builder: (context, state) {
                        return CustomButton(
                          text: 'Verify phone number',
                          onPressed: () {
                            if (state.status == FormzStatus.invalid) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Check your phone number')),
                              );
                            } else {
                              //TODO: enter verify phone number screen
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
