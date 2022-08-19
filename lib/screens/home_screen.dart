// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
//import 'package:latlng/latlng.dart';
import 'package:lottie/lottie.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import '/blocs/blocs.dart';
// import '/profile.dart';
//import '/providers/userdata.dart';
//import '/respositories/bloc/swipebloc_bloc.dart';
import '/widgets/widgets.dart';
import '/models/models.dart';
import 'screens.dart';

VoidCallback onLeftSwipe(BuildContext context, SwipeLoaded state) {
  return () {
    print('left swiped');
    context.read<SwipeBloc>().add(SwipeLeft(user: state.users[0]));
  };
}

VoidCallback onRightSwipe(BuildContext context, SwipeLoaded state) {
  return () {
    print('right swiped');
    context.read<SwipeBloc>().add(SwipeRight(user: state.users[0]));
  };
}

VoidCallback onLaterSwipe(BuildContext context, SwipeLoaded state) {
  return () {
    print('later swiped');
    context.read<SwipeBloc>().add(SwipeLater(user: state.users[0]));
  };
}

// ignore: must_be_immutable
class HomeScreen extends StatelessWidget {
  static const String routeName = '/homescreen';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => HomeScreen(),
    );
  }
  // static Route route() {
  //   return MaterialPageRoute(
  //     settings: const RouteSettings(name: routeName),
  //     builder: (context) {
  //       print('bloc status is');
  //       print(BlocProvider.of<AuthBloc>(context).state.status);
  //       return BlocProvider.of<AuthBloc>(context).state.status ==
  //               AuthStatus.unauthenticated
  //           ? LoginScreen()
  //           : BlocProvider<SwipeBloc>(
  //               create: (context) => SwipeBloc(
  //                 authBloc: context.read<AuthBloc>(),
  //                 databaseRepository: context.read<DatabaseRepository>(),
  //               )..add(LoadUsers()),
  //               child: HomeScreen(),
  //             );
  //     },
  //   );
  // }

  HomeScreen({Key? key, this.moveToMatches}) : super(key: key);
  final bool isLike = false;
  final bool isHeart = false;
  TapDownDetails? detailes;
  final VoidCallback? moveToMatches;
  User? user;
  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return BlocBuilder<SwipeBloc, SwipeState>(
        bloc: BlocProvider.of<SwipeBloc>(context),
        builder: (context, state) {
          if (state is SwipeLoading) {
            return SafeArea(
                child: SingleChildScrollView(
                    child: Expanded(
                        child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 150),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()],
                )
              ],
            ))));
          } else if (state is SwipeLoaded) {
            return SafeArea(
                child:
                    SingleChildScrollView(child: HomePageLoaded(state: state)));
          }
          if (state is SwipeMatched) {
            return SafeArea(
                child: SingleChildScrollView(
                    child: SwipeMatchedHomeScreen(
                        state: state, moveToMatches: moveToMatches)));
          }
          if (state is SwipeError) {
            return SafeArea(
                child: SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 200),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CustomTextHeader(text: 'There aren\'t any more users.')
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    CustomTextHeader(
                        text: 'Come back later to see more people.')
                  ],
                )
              ],
            )));
          } else if (state is ChatOpened) {
            Navigator.of(context)
                .pushNamed(ChatScreen.routeName, arguments: state.match);
            context.read<SwipeBloc>().add(LoadUsers());

            return Container();
            // context.read<SwipeBloc>().add(SwipeLater());

          } else {
            return const Center(child: Text('Something went wrong.'));
          }
        });
  }

  bool get wantKeepAlive => true;
}

class HomePageLoaded extends StatelessWidget {
  final SwipeLoaded state;
  const HomePageLoaded({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25.0),
      child: Column(
        children: [
          InkWell(
              onDoubleTap: () {
                Navigator.of(context)
                    .pushNamed(UserScreen.routeName, arguments: {
                  'user': state.users[0],
                  'showButtons': true,
                  'onLeftSwipe': onLeftSwipe(context, state),
                  'onRightSwipe': onRightSwipe(context, state),
                  'onLaterSwipe': onLaterSwipe(context, state)
                });
              },
              child: Draggable<User>(
                data: state.users[0],
                feedback: UserCard(user: state.users[0], state: state),
                childWhenDragging: (state.users.length > 1)
                    ? UserCard(user: state.users[1], state: state)
                    : Container(),
                onDragEnd: (drag) {
                  if (drag.velocity.pixelsPerSecond.dx < 0 &&
                      drag.offset.dx < -100) {
                    onLeftSwipe(context, state)();
                  } else if (drag.offset.dx > 100) {
                    onRightSwipe(context, state)();
                    Future.delayed(const Duration(seconds: 2), () {
                      Lottie.asset('assets/animations/love.json');
                    });
                  }
                },
                child: UserCard(user: state.users[0], state: state),
              )),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class SwipeMatchedHomeScreen extends StatelessWidget {
  const SwipeMatchedHomeScreen(
      {Key? key, required this.state, this.moveToMatches})
      : super(key: key);

  final VoidCallback? moveToMatches;
  final SwipeMatched state;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
            alignment: Alignment.center,
            child: CustomTextHeader(
              text: 'Congrats, it\'s a match!',
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )),
        const SizedBox(height: 20),
        Align(
            alignment: Alignment.center,
            child: CustomTextHeader(
              text: 'You and ${state.user.name} have liked each other!',
              style: GoogleFonts.aBeeZee(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            )),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).accentColor,
                      Theme.of(context).primaryColor,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(
                      context.read<AuthBloc>().state.user!.imageUrls[0]!),
                ),
              ),
            ),
            const SizedBox(width: 30),
            ClipOval(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).accentColor,
                      Theme.of(context).primaryColor,
                    ],
                  ),
                ),
                padding: const EdgeInsets.all(5),
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage: NetworkImage(state.user.getProfilePicture()),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 50),
        CustomButton(
          text: 'SEND A MESSAGE',
          textColor: Colors.white,
          onPressed: () {
            if (moveToMatches != null) {
              moveToMatches!();
            }
          },
          beginColor: Theme.of(context).accentColor,
          endColor: Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 10),
        CustomButton(
          text: 'BACK TO SWIPING',
          textColor: Colors.white,
          onPressed: () {
            context.read<SwipeBloc>().add(LoadUsers());
          },
          beginColor: Theme.of(context).accentColor,
          endColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
