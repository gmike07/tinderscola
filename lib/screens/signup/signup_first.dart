import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '/blocs/blocs.dart';
import '/widgets/widgets.dart';
import '/config/constants.dart';
import '/screens/screens.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';

class Start extends StatelessWidget {
  final SignUpLoaded state;

  const Start({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/animations/onboaring_love.json',
                ),
              ),
              const SizedBox(height: 50),
              Text('Welcome to ${AppConstants.appName}'.toUpperCase(),
                  style: GoogleFonts.aBeeZee(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                  )),
              const SizedBox(height: 20),
              Text(
                '${AppConstants.appName} is a meme platform that became a reality!\n'
                'The platform helps you find new friends and connect with people who share your interests and passions with you.',
                style: GoogleFonts.aBeeZee(fontSize: 15),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
                },
                child: RichText(
                    text: TextSpan(children: [
                  TextSpan(
                    text: 'Already have an account? ',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 15,
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    text: 'Sign in',
                    style: GoogleFonts.aBeeZee(
                      color: Theme.of(context).primaryColor,
                      fontSize: 15,
                    ),
                  ),
                ])),
              ),
              const SizedBox(height: 10),
              CustomButton(
                text: 'GET STARTED',
                onPressed: () {
                  context
                      .read<SignUpBloc>()
                      .add(ContinueSignUp(user: state.user));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
