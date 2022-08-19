// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/blocs/blocs.dart';
import 'screens.dart';
import '/repositories/auth/auth_repository.dart';
import '/config/constants.dart';
import '/widgets/widgets.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);
  static const String routeName = '/splash';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          return previous.authUser != current.authUser ||
              current.authUser == null;
        },
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            Timer(
              const Duration(seconds: 1),
              () =>
                  Navigator.of(context).popAndPushNamed(SignUpScreen.routeName),
            );
          } else if (state.status == AuthStatus.authenticated) {
            Timer(
              const Duration(seconds: 1),
              () => Navigator.of(context).popAndPushNamed(MainScreen.routeName),
            );
          }
        },
        child: Scaffold(
          body: SizedBox(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AppConstants.pathToLogo,
                      height: 100, color: Theme.of(context).accentColor),
                  const SizedBox(height: 20),
                  CustomText(
                      text: AppConstants.appName,
                      style: GoogleFonts.aBeeZee(
                        fontSize: 40,
                        fontWeight: FontWeight.w500,
                      )),
                  TextButton(
                    onPressed: () {
                      RepositoryProvider.of<AuthRepository>(context).signOut();
                    },
                    child: Center(
                      child: Text(
                        'Sign Out',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
