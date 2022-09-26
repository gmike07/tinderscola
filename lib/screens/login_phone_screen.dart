import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinderscola_final/config/constants.dart';
import 'package:tinderscola_final/repositories/database/database_repository.dart';
import '/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/cubits/cubits.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import '/screens/screens.dart';
import '/blocs/blocs.dart';

class LoginScreenPhone extends StatelessWidget {
  static const String routeName = '/signinphone';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider.of<AuthBloc>(context).state.status !=
                AuthStatus.authenticated
            ? AppConstants.getLoginScreen()
            : const MainScreen();
      },
    );
  }

  const LoginScreenPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status.isSubmissionFailure) {
                AppConstants.showToast(
                    state.errorMessage ?? 'Authentication Failure');
              }
              if (state.status.isSubmissionSuccess) {
                //Navigator.popAndPushNamed(context, HomeScreen.routeName);
              }
            },
            child: SingleChildScrollView(
                reverse: true,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30.0, vertical: 50),
                    child: BlocBuilder<LoginCubitPhone, LoginStatePhone>(
                        builder: (context, state_) {
                      if (state_.enterPhone) {
                        return const EnterPhoneNumber();
                      }
                      return const EnterOTP();
                    })))));
  }
}

class EnterPhoneNumber extends StatelessWidget {
  const EnterPhoneNumber({Key? key}) : super(key: key);

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
                  const CustomTextHeader(text: 'What\'s Your Phone Number?'),
                  const SizedBox(height: 7),
                  BlocBuilder<LoginCubitPhone, LoginStatePhone>(
                    builder: (context, state) {
                      return PhoneNumberWidget(
                        defaultCountry:
                            context.read<LoginCubitPhone>().getCountryName(),
                        onPhoneNumberChange: (val) => context
                            .read<LoginCubitPhone>()
                            .phoneNumberChanged(val),
                        onPhoneCodeChange: (country) => context
                            .read<LoginCubitPhone>()
                            .countryCodeChanged(
                                country.phoneCode, country.isoCode),
                        showError: state.status == FormzStatus.invalid,
                        priorityList: const ['IL', 'US'],
                      );
                    },
                  ),
                  const SizedBox(height: 30),
                  BlocBuilder<LoginCubitPhone, LoginStatePhone>(
                      builder: (context, state) {
                    return CustomButton(
                      text: 'Verify phone number to login',
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
                              // ignore: use_build_context_synchronously
                              '${context.read<SignupCubitPhone>().getPhoneNumberString()} is not allowed to sign in');
                        } else {
                          // ignore: use_build_context_synchronously
                          context.read<LoginCubitPhone>().sendSMS(context);
                        }
                      },
                    );
                  }),
                  const SizedBox(height: 20),
                  const SignUpButton()
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
  const EnterOTP({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CustomTextHeader(
                    text: 'Phone Number Verification To Login'),
                const SizedBox(height: 7),
                CustomText(
                    text:
                        'enter the code sent to ${context.read<LoginCubitPhone>().getPhoneNumberString()}.'),
                const SizedBox(height: 20),
                BlocBuilder<LoginCubitPhone, LoginStatePhone>(
                  builder: (context, state) {
                    return OTPTextField(onChanged: (val) {
                      context.read<LoginCubitPhone>().setOTP(val);
                    });
                  },
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const CustomText(text: 'Didn\'t receive the code?'),
                      TextButton(
                          onPressed: () {
                            context.read<LoginCubitPhone>().sendSMS(context);
                          },
                          child: const Text('Resend',
                              style: TextStyle(color: Colors.red)))
                    ]),
                const SizedBox(height: 20),
                const LoginButtonPhone(),
                const SizedBox(height: 20),
                const SignUpButton()
              ],
            ),
          ],
        ),
      )
    ]);
  }
}

class LoginButtonPhone extends StatelessWidget {
  const LoginButtonPhone({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              // ignore: deprecated_member_use
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: () async {
            if (BlocProvider.of<LoginCubitPhone>(context).state.status ==
                FormzStatus.valid) {
              var success =
                  await context.read<LoginCubitPhone>().validateSMS(context);
              if (success) {
                //TODO: solve this stupid solution
                Future.delayed(Duration.zero, () {
                  Navigator.of(context).popAndPushNamed(MainScreen.routeName);
                  Future.delayed(
                      const Duration(milliseconds: 100),
                      () => Navigator.of(context)
                          .popAndPushNamed(MainScreen.routeName));
                });
              }
            } else {
              AppConstants.showToast('you entered a wrong verification code');
            }
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text('Sign In',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ))),
          ),
        ));
  }
}
