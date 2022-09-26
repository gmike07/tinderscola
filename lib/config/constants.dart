import 'package:flutter/material.dart';
import '/screens/screens.dart';

class AppConstants {
  static const bool useOTP = true;
  static const int limitQuery = 5;
  static const String appName = 'Tinderscola';
  static const String appVersion = '1.0.0';
  static const String pathToLogo = 'assets/images/ascola.png';
  static const List<String> genders = ['male', 'female', 'transgender'];
  static const String hebrewLetters = 'אבגדהוזחטיכךלמםנןסעפףצץקרשת';
  static final GlobalKey<ScaffoldMessengerState> snackbarKey =
      GlobalKey<ScaffoldMessengerState>();
  static const List<String> interests = [
    'Coding',
    'Design',
    'Music',
    'Dancing',
    'Reading',
    'Cooking',
    'Traveling',
    'Photography',
    'Fashion',
    'Art',
    'Sports',
    'Gaming',
    'Fitness',
    'Nature',
    'Technology',
    'Writing',
    'Hiking',
  ];

  static void showToast(String s) {
    AppConstants.snackbarKey.currentState
        ?.showSnackBar(SnackBar(content: Text(s)));
  }

  static void routeToLogin(BuildContext context) {
    if (useOTP) {
      Navigator.of(context).popAndPushNamed(LoginScreenPhone.routeName);
    } else {
      Navigator.of(context).popAndPushNamed(LoginScreen.routeName);
    }
  }

  static Widget getLoginScreen() {
    return useOTP ? const LoginScreenPhone() : LoginScreen();
  }
}
