import 'package:flutter/material.dart';
import '/cubits/cubits.dart';
import '/screens/screens.dart';
import 'config/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'blocs/blocs.dart';

import 'config/constants.dart';
import 'config/theme.dart';
import 'repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider(
            create: (context) => AuthRepository(),
          ),
          RepositoryProvider(
            create: (context) => DatabaseRepository(),
          ),
          RepositoryProvider(
            create: (context) => StorageRepository(),
          ),
        ],
        child: MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) => AuthBloc(
                  authRepository: context.read<AuthRepository>(),
                  databaseRepository: context.read<DatabaseRepository>(),
                ),
              ),
              BlocProvider<SignupCubit>(
                create: (context) =>
                    SignupCubit(authRepository: context.read<AuthRepository>()),
              ),
              BlocProvider<LoginCubit>(
                create: (context) =>
                    LoginCubit(authRepository: context.read<AuthRepository>()),
              ),
            ],
            child: MaterialApp(
                localizationsDelegates: const [
                  GlobalCupertinoLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                ],
                // supportedLocales: const [
                //   Locale("he", "HE"),
                //   Locale("en", "EN"),
                // ],
                locale: const Locale("en", "EN"),
                title: AppConstants.appName,
                debugShowCheckedModeBanner: false,
                initialRoute: SplashScreen.routeName,
                onGenerateRoute: AppRouter.onGenerateRoute,
                theme: theme())));
  }
}
