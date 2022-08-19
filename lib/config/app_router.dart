import 'package:flutter/material.dart';
import '/screens/screens.dart';
import '/models/models.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    // ignore: avoid_print
    print('The Route is: ${settings.name}');

    switch (settings.name) {
      // case '/':
      //   return MainScreen.route();
      case MainScreen.routeName:
        return MainScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case UserScreen.routeName:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return UserScreen.route(
          user: args['user'] as User,
          showButtons: args['showButtons'] ?? false,
          onLaterSwipe: args['onLaterSwipe'] ?? () {},
          onRightSwipe: args['onRightSwipe'] ?? () {},
          onLeftSwipe: args['onLeftSwipe'] ?? () {},
        );
      case SignUpScreen.routeName:
        return SignUpScreen.route();
      case LoginScreen.routeName:
        return LoginScreen.route();
      case SplashScreen.routeName:
        return SplashScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case MatchesScreen.routeName:
        return MatchesScreen.route();
      case ChatScreen.routeName:
        Map<String, dynamic> args = settings.arguments as Map<String, dynamic>;
        return ChatScreen.route(
            user: args['user'] as User, match: args['match'] as Match);
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(appBar: AppBar(title: const Text('error'))),
      settings: const RouteSettings(name: '/error'),
    );
  }
}
