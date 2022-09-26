import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '/animations/liked.dart';
import '/config/theme.dart';
import '/models/models.dart';
import 'package:flutter/cupertino.dart';
import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
import '/screens/screens.dart';

class UserCard extends StatefulWidget {
  final User user;
  final SwipeLoaded state;
  const UserCard({Key? key, required this.user, required this.state})
      : super(key: key);

  @override
  State<UserCard> createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  bool isAnimating = false;
  bool isLiked = false;
  double meters = 0;
  bool isDisliked = false;
  double? lat;
  double? long;
  double distance = 0;
  TapDownDetails? tapDownDetails;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    List<String> images = [];
    for (String? s in widget.user.imageUrls) {
      if (s != null) {
        images.add(s);
      }
    }
    List<Widget> nameAndGenders = [
      CustomText(
        text: widget.user.name,
        style: GoogleFonts.aBeeZee(
            fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      const SizedBox(width: 5)
    ];
    for (String g in widget.user.gender) {
      nameAndGenders.add(Icon(GenderWidget.getGenderIcon(context, g),
          size: 20, color: Colors.white));
      nameAndGenders.add(const SizedBox(width: 5));
    }
    if (widget.user.searchesForFriends) {
      nameAndGenders.add(Icon(GenderWidget.getGenderIcon(context, 'friend'),
          size: 20, color: Colors.white));
      nameAndGenders.add(const SizedBox(width: 5));
    }
    return Hero(
        tag: 'user_card',
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0, left: 20, right: 20),
          child: Stack(
            children: [
              SizedBox(
                height: size.height / 1.4,
                width: size.width,
                child: Stack(children: [
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            offset: const Offset(0, 3),
                            spreadRadius: 4,
                            blurRadius: 10),
                      ],
                      image: DecorationImage(
                          image: NetworkImage(widget.user.getCoverPicture()),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                      child: Wrap(
                    direction: Axis.horizontal,
                    children: List.generate(
                        images.length - 1,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                height: 4,
                                width: 45,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                              ),
                            )),
                  )),
                  Container(
                      decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  )),
                  Positioned(
                    bottom: 10,
                    left: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: nameAndGenders),
                        Row(
                          children: [
                            CustomText(
                              text: '${widget.user.age.toString()}, ',
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            CustomText(
                              text:
                                  "${widget.user.programName}, ${widget.user.programPlace}",
                              style: GoogleFonts.aBeeZee(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            )
                          ],
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 68,
                          width: MediaQuery.of(context).size.width,
                          child: GridView.count(
                            padding: const EdgeInsets.only(right: 90),
                            shrinkWrap: true,
                            childAspectRatio: 18 / 6,
                            crossAxisCount: 3,
                            children: widget.user.interests.map((interest) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                    width: 45,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      color: Colors.white,
                                    ),
                                    child: Center(
                                        child: CustomText(
                                      text: interest,
                                      style: GoogleFonts.aBeeZee(
                                        fontSize: 12,
                                      ),
                                    ))),
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const SizedBox(height: 10),
                        _buildBottomButtons(context, widget.state)
                      ],
                    ),
                  )
                ]),
              ),
              Positioned(
                left: 50,
                right: 50,
                top: 50,
                bottom: 50,
                child: Opacity(
                  opacity: isAnimating ? 1 : 0,
                  child: HeartAnimationWidget(
                    onEnd: () {
                      setState(() {
                        isAnimating = false;
                      });
                    },
                    duration: const Duration(milliseconds: 700),
                    isAnimation: isAnimating,
                    child: Container(
                      height: 20,
                      width: 20,
                      color: Colors.transparent,
                      child: Lottie.asset(
                        'assets/animations/love.json',
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 50,
                right: 50,
                top: 50,
                bottom: 50,
                child: Opacity(
                  opacity: isDisliked ? 1 : 0,
                  child: HeartAnimationWidget(
                    onEnd: () {
                      setState(() {
                        isDisliked = false;
                      });
                    },
                    duration: const Duration(milliseconds: 700),
                    isAnimation: isDisliked,
                    child: SvgPicture.asset(
                      'assets/svgs/close_icon.svg',
                      height: 55,
                      width: 55,
                      fit: BoxFit.scaleDown,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
    // }
    // return Container();
    //   },
    // );
  }

  Widget _buildBottomButtons(BuildContext context, SwipeLoaded state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
              onTap: onLaterSwipe(context, state),
              child: const ChoiceButton(
                height: 60,
                width: 60,
                hasGradient: false,
                isSvg: true,
                path: 'assets/svgs/refresh_icon.svg',
                color: AppColors.arrowColor,
                icon: CupertinoIcons.arrow_clockwise,
                size: 25,
              )),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              //isDisliked = true;
              setState(() {
                isDisliked = true;
              });
              onLeftSwipe(context, state)();
            },
            child: ChoiceButton(
              height: 60,
              isSvg: true,
              hasGradient: false,
              linear1: Colors.red.withOpacity(.8),
              linear2: Colors.redAccent,
              path: 'assets/svgs/close_icon.svg',
              width: 60,
              color: Colors.white,
              icon: Icons.clear_rounded,
              size: 25,
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
            onTap: () {
              setState(() {
                isAnimating = true;
                isLiked = true;
              });
              onRightSwipe(context, state)();
            },
            child: const ChoiceButton(
              hasGradient: false,
              isSvg: true,
              height: 60,
              width: 60,
              path: 'assets/svgs/like_icon.svg',
              color: Colors.white,
              icon: Icons.favorite,
              size: 25,
            ),
          ),
          const SizedBox(width: 15),
          GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(UserScreen.routeName, arguments: {
                  'user': state.users[0],
                  'currentUserId': state.currentUserId,
                  'showButtons': true,
                  'onLeftSwipe': onLeftSwipe(context, state),
                  'onRightSwipe': onRightSwipe(context, state),
                  'onLaterSwipe': onLaterSwipe(context, state)
                });
              },
              child: const ChoiceButton(
                height: 60,
                width: 60,
                hasGradient: false,
                isSvg: false,
                path: '',
                color: Color.fromARGB(255, 0, 159, 191),
                icon: Icons.info,
                size: 25,
              )),
          const SizedBox(width: 15),
        ],
      ),
    );
  }
}

class UserImagesSmall extends StatelessWidget {
  final User user;
  final int index;
  const UserImagesSmall({
    Key? key,
    required this.user,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> images = [];
    for (String? s in user.imageUrls) {
      if (s != null) {
        images.add(s);
      }
    }
    return Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(images[index]),
            )));
  }
}
