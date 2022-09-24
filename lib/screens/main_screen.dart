import 'package:tinderscola_final/widgets/widgets.dart';

import 'screens.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/blocs/blocs.dart';
import 'package:flutter/material.dart';
import '/repositories/repositories.dart';

class MainScreen extends StatefulWidget {
  static const String routeName = '/mainscreen';
  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) {
        return BlocProvider.of<AuthBloc>(context).state.status ==
                AuthStatus.unauthenticated
            ? LoginScreen()
            : MultiBlocProvider(providers: [
                BlocProvider<SwipeBloc>(
                    create: (context) => SwipeBloc(
                        authBloc: context.read<AuthBloc>(),
                        databaseRepository: context.read<DatabaseRepository>(),
                        currentUserId:
                            context.read<AuthBloc>().state.authUser!.uid)
                      ..add(LoadUsers())),
                BlocProvider<ProfileBloc>(
                    create: (context) => ProfileBloc(
                          authBloc: BlocProvider.of<AuthBloc>(context),
                          databaseRepository:
                              context.read<DatabaseRepository>(),
                          storageRepository: context.read<StorageRepository>(),
                          //locationRepository: context.read<LocationRepository>(),
                        )..add(LoadProfile(
                            userId:
                                context.read<AuthBloc>().state.authUser!.uid))),
                BlocProvider<MatchBloc>(
                    create: (context) => MatchBloc(
                          databaseRepository:
                              context.read<DatabaseRepository>(),
                        )..add(LoadMatches(
                            user: context.read<AuthBloc>().state.user!)))
              ], child: const MainScreen());
      },
    );
  }

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  void _onTappedBar(int value) {
    setState(() {
      _selectedIndex = value;
    });
    _pageController.jumpToPage(value);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenWrapper(
        onTappedBar: _onTappedBar,
        selectedTab: _selectedIndex,
        child: PageView(
          onPageChanged: (page) {
            setState(() {
              _selectedIndex = page;
            });
          },
          controller: _pageController,
          children: <Widget>[
            HomeScreen(moveToMatches: () {
              _pageController.jumpToPage(1);
              setState(() {
                _selectedIndex = 1;
              });
            }),
            const MatchesScreen(),
            const ProfileScreen()
          ],
        ));
  }
}
