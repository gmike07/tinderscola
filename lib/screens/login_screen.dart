// ignore_for_file: deprecated_member_use

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/screens/screens.dart';
import '/widgets/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import '/cubits/cubits.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/blocs.dart';

// ignore: must_be_immutable
class LoginScreen extends StatelessWidget {
  static const String routeName = '/signin';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? LoginScreen()
            : const MainScreen();
      },
    );
  }

  LoginScreen({Key? key}) : super(key: key);
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  String? error;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CustomAppBar(),
        body: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state.status.isSubmissionFailure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content:
                        Text(state.errorMessage ?? 'Authentication Failure'),
                  ),
                );
              }
              if (state.status.isSubmissionSuccess) {
                //Navigator.popAndPushNamed(context, HomeScreen.routeName);
              }
            },
            child: SingleChildScrollView(
              reverse: true,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 11,
                        ),
                        RichText(
                          text: TextSpan(
                              text: 'Hey there,',
                              style: GoogleFonts.aBeeZee(
                                fontSize: 19,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey,
                              ),
                              children: [
                                TextSpan(
                                  text: '\nWelcome back!',
                                  style: GoogleFonts.aBeeZee(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.1,
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            children: [
                              const EmailInput(),
                              const SizedBox(height: 20),
                              const PasswordInput(),
                              const SizedBox(height: 10),
                              Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 210.0),
                                    child: Text(
                                      'Forgot Password?',
                                      style: GoogleFonts.aBeeZee(
                                        color: Colors.grey,
                                        fontSize: 14,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    const LoginButton(),
                    const SizedBox(height: 20),
                    const SignUpButton()
                  ],
                ),
              ),
            )));
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
        buildWhen: ((previous, current) => previous.status != current.status),
        builder: (context1, state1) {
          if (state1.status == AuthStatus.authenticated) {
            Navigator.of(context1).popAndPushNamed(MainScreen.routeName);
            return Container();
          }
          return BlocBuilder<LoginCubit, LoginState>(
            buildWhen: (previous, current) => previous.status != current.status,
            builder: (context, state) {
              return state.status == FormzStatus.submissionInProgress
                  ? const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator())
                  : DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).accentColor,
                            Theme.of(context).primaryColor,
                          ],
                        ),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          state.status == FormzStatus.valid
                              ? context
                                  .read<LoginCubit>()
                                  .logInWithCredentials()
                              : ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Check your email and password: ${state.status}'),
                                  ),
                                );
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
            },
          );
        });
  }
}

class SignUpButton extends StatelessWidget {
  const SignUpButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          gradient: LinearGradient(
            colors: [
              Theme.of(context).accentColor,
              Theme.of(context).primaryColor,
            ],
          ),
        ),
        child: ElevatedButton(
          onPressed: () {
            Navigator.of(context).popAndPushNamed(SignUpScreen.routeName);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.transparent,
            elevation: 0,
          ),
          child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text('Sign Up',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ))),
          ),
        ));
  }
}

class PasswordInput extends StatelessWidget {
  const PasswordInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          onChanged: (password) {
            context.read<LoginCubit>().passwordChanged(password);
          },
          obscureText: true,
          decoration: InputDecoration(
            filled: true,
            suffixIcon: const Icon(AntIcons.lockFilled),
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: 'Password',
            errorText: state.password.invalid
                ? 'The password must contain at least 8 characters.'
                : null,
            hintStyle: GoogleFonts.aBeeZee(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return TextFormField(
          onChanged: (email) {
            context.read<LoginCubit>().emailChanged(email);
          },
          validator: (value) {
            if (value!.isEmpty) {
              return 'Email is required';
            }
            return '';
          },
          decoration: InputDecoration(
            suffixIcon: const Icon(Icons.mail),
            filled: true,
            fillColor: Colors.white,
            border: InputBorder.none,
            hintText: 'Email',
            errorText: state.email.invalid ? 'The email is invalid' : null,
            hintStyle: GoogleFonts.aBeeZee(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
        );
      },
    );
  }
}
