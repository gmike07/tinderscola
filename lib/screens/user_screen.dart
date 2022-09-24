// ignore_for_file: library_private_types_in_public_api, deprecated_member_use

import 'package:antdesign_icons/antdesign_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinderscola_final/repositories/database/database_repository.dart';
import 'package:tinderscola_final/widgets/youtube_player.dart';
import '/animations/fadeinanimation.dart';
import '/models/user.dart';
import '/widgets/widgets.dart';

// ignore: must_be_immutable
class UserScreen extends StatelessWidget {
  static const String routeName = '/userscreen';
  final String currentUserId;
  final User user;
  final bool showButtons;
  final VoidCallback onLeftSwipe;
  final VoidCallback onRightSwipe;
  final VoidCallback onLaterSwipe;
  UserScreen(
      {Key? key,
      required this.user,
      required this.showButtons,
      required this.onLeftSwipe,
      required this.onRightSwipe,
      required this.onLaterSwipe,
      required this.currentUserId})
      : super(key: key);

  static Route route(
      {required User user,
      required bool showButtons,
      required VoidCallback onLeftSwipe,
      required VoidCallback onRightSwipe,
      required VoidCallback onLaterSwipe,
      required String currentUserId}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => UserScreen(
        currentUserId: currentUserId,
        user: user,
        showButtons: showButtons,
        onLaterSwipe: onLaterSwipe,
        onLeftSwipe: onLeftSwipe,
        onRightSwipe: onRightSwipe,
      ),
    );
  }

  double? lat;
  double? meters = 400;
  double? long;
  double distance = 0;
  TapDownDetails? tapDownDetails;
  // void getMilesAway() {
  //   final double distanceinmeters = Geolocator.distanceBetween(
  //     widget.user.geopoint!.latitude,
  //     widget.user.geopoint!.longitude,
  //     lat ?? 0,
  //     long ?? 0,
  //   );
  //   setState(() {
  //     meters = 1000000 / 1609.344;
  //   });
  //   print(widget.user.geopoint!.latitude);
  // }

  // void getCurrentUserLocation() {
  //   Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
  //       .then((position) {
  //     setState(() {
  //       lat = position.latitude;
  //       long = position.longitude;
  //     });
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  //   //getCurrentUserLocation();
  //   //getMilesAway();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 2,
              child: Stack(
                children: [
                  _buildImageProfile(context),
                  !showButtons
                      ? Container()
                      : Align(
                          alignment: Alignment.bottomCenter,
                          // child: BlocBuilder<SwipeBloc, SwipeState>(
                          //   builder: (context, state) {
                          //     if (state is SwipeLoading) {
                          //       return const Center(
                          //         child: CircularProgressIndicator(),
                          //       );
                          //     }
                          //     if (state is SwipeLoaded) {
                          child: _buildImageButtons(context), //       );
                          //     } else {
                          //       return const Text('Something went wrong.');
                          //     }
                          //   },
                          // ),
                        ),
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CustomText(
                              text: user.name,
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 28,
                                fontWeight: FontWeight.w600,
                              )),
                          const SizedBox(width: 7),
                          CustomText(
                              text: "${user.age}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.aBeeZee(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                              ))
                        ],
                      )),
                  const SizedBox(height: 5),
                  _buildProgramPlace(context),
                  const SizedBox(height: 5),
                  _buildProgramName(context),
                  const SizedBox(height: 15),
                  _buildPictures(context),
                  const Divider(),
                  const SizedBox(height: 15),
                  Text(
                    'About Me',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  CustomText(
                    text: user.bio,
                    style: GoogleFonts.aBeeZee(
                      color: const Color.fromARGB(136, 0, 0, 0),
                      fontSize: 15,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 15),
                  CustomText(
                    text: 'My interests',
                    style: GoogleFonts.aBeeZee(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildInterests(context),
                  const Divider(),
                  _buildShareWidget(context),
                  const SizedBox(height: 15),
                  _buildReport(context)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getPicture(int index) {
    List<String> images = [];
    for (String? s in user.imageUrls) {
      if (s != null) {
        images.add(s);
      }
    }
    return (images.length > index)
        ? CustomImageContainer(
            imageUrl: images[index],
          )
        : Container();
  }

  Widget _buildPictures(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Wrap(
        children: [
          _getPicture(0),
          _getPicture(1),
          _getPicture(2),
          _getPicture(3),
          _getPicture(4),
          _getPicture(5),
        ],
      ),
    );
  }

  Widget _buildProgramName(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          'assets/images/briefcase.png',
          height: 20,
          color: const Color.fromARGB(136, 0, 0, 0),
        ),
        const SizedBox(width: 7),
        CustomText(
          text: user.programName,
          style: GoogleFonts.aBeeZee(
            color: const Color.fromARGB(136, 0, 0, 0),
          ),
        ),
      ],
    );
  }

  Widget _buildImageButtons(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 60.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                onLeftSwipe();
                Navigator.of(context).pop();
              },
              child: ChoiceButton(
                height: 60,
                hasGradient: false,
                width: 60,
                color: Theme.of(context).accentColor,
                icon: Icons.clear_rounded,
                size: 25,
              ),
            ),
            GestureDetector(
              onTap: () {
                onRightSwipe();
                Navigator.of(context).pop();
              },
              child: ChoiceButton(
                height: 80,
                width: 80,
                hasGradient: true,
                color: Colors.white,
                linear1: Theme.of(context).accentColor,
                linear2: Theme.of(context).colorScheme.primary,
                icon: Icons.favorite,
                size: 35,
              ),
            ),
            GestureDetector(
                onTap: () {
                  onLaterSwipe();
                  Navigator.of(context).pop();
                },
                child: ChoiceButton(
                  height: 60,
                  width: 60,
                  hasGradient: false,
                  color: Theme.of(context).accentColor,
                  icon: CupertinoIcons.clock,
                  size: 25,
                )),
          ],
        ).fadeInList(7, true));
  }

  Widget _buildImageProfile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(user.getCoverPicture()),
          ),
        ),
      ),
    );
  }

  Widget _buildProgramPlace(BuildContext context) {
    return Row(
      children: [
        const Icon(
          AntIcons.homeOutlined,
          size: 18,
          color: Color.fromARGB(136, 0, 0, 0),
        ),
        const SizedBox(
          width: 7,
        ),
        CustomText(
          text: 'Studied in ${user.programPlace}',
          style: GoogleFonts.aBeeZee(
            color: const Color.fromARGB(136, 0, 0, 0),
          ),
        ),
      ],
    );
  }

  Widget _buildInterests(BuildContext context) {
    return Wrap(
        children: user.interests
            .map(
              (interest) => Padding(
                padding: const EdgeInsets.only(right: 11.0, bottom: 10),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: Border.all(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(30)),
                  height: 30,
                  width: 90,
                  child: Center(
                      child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: CustomText(
                      text: interest,
                      style: GoogleFonts.aBeeZee(
                        color: Colors.black,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  )),
                ),
              ),
            )
            .toList());
  }

  Widget _buildShareWidget(BuildContext context) {
    if (currentUserId == user.id) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      Text(
                        'Share',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'I am not going to program a share feature, fuck that!',
                        style: GoogleFonts.aBeeZee(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      const CustomYoutubePlayer(
                          url: 'https://www.youtube.com/watch?v=dQw4w9WgXcQ')
                    ]),
                  ),
                ),
              );
            });
      },
      child: CustomText(
        text: 'Share ${user.name} Profile',
        style: GoogleFonts.aBeeZee(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReport(BuildContext context) {
    if (currentUserId == user.id) {
      return Container();
    }
    return GestureDetector(
      onTap: () {
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height / 1.5,
                  width: MediaQuery.of(context).size.width / 1.2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Report',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 30),
                          CustomText(
                            text:
                                'Are you sure that you want to report ${user.name}?\n We won\'t tell them.',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              Flexible(
                                  child: CustomButton(
                                text: 'NO',
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              )),
                              const SizedBox(width: 20),
                              Flexible(
                                  child: CustomButton(
                                text: 'YES',
                                onPressed: () {
                                  DatabaseRepository d = DatabaseRepository();
                                  d.unmatchUsers(currentUserId, user.id);
                                  d.reportUser(currentUserId, user.id);
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                              ))
                            ],
                          )
                        ]),
                  ),
                ),
              );
            });
      },
      child: CustomText(
        text: 'Report ${user.name}',
        style: GoogleFonts.aBeeZee(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).accentColor,
        ),
      ),
    );
  }
}
