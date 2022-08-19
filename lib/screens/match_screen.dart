// import 'dart:html';
// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/widgets/widgets.dart';
import '/models/models.dart' as model;
import '/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({Key? key}) : super(key: key);

  static const String routeName = '/matchesscreen';

  // static Route route() {
  //   return MaterialPageRoute(
  //     settings: const RouteSettings(name: routeName),
  //     builder: (context) => BlocProvider<MatchBloc>(
  //       create: (context) => MatchBloc(
  //         databaseRepository: context.read<DatabaseRepository>(),
  //       )..add(LoadMatches(user: context.read<AuthBloc>().state.user!)),
  //       child: const MatchesScreen(),
  //     ),
  //   );
  // }

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const MatchesScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MatchBloc, MatchState>(builder: (context, state) {
      if (state is MatchLoading) {
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
      }
      if (state is MatchLoaded) {
        return MatchesScreenLoaded(state: state);
      }
      return const Text('Something went wrong.');
    });
  }
}

void sortMatchesWithChat(List<model.Match> matches) {
  matches.sort((m1, m2) {
    DateTime m1Time = m1.chat!.getLastMessage().dateTime;
    DateTime m2Time = m2.chat!.getLastMessage().dateTime;
    return m2Time.compareTo(m1Time);
  });
}

class MatchesScreenLoaded extends StatelessWidget {
  final MatchLoaded state;
  const MatchesScreenLoaded({Key? key, required this.state}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<model.Match> activeMatches = [];
    List<model.Match> inactiveMatches = [];
    List<model.Match> matches = state.matches.toList();
    List<model.Chat> chats = state.chats.toList();
    Map<String, Map<String, model.Chat>> chatMap = {};
    for (model.Chat chat in chats) {
      if (chatMap[chat.userId] == null) {
        chatMap[chat.userId] = {};
      }
      if (chatMap[chat.matchedUserId] == null) {
        chatMap[chat.matchedUserId] = {};
      }
      chatMap[chat.userId]![chat.matchedUserId] = chat;
      chatMap[chat.matchedUserId]![chat.userId] = chat;
    }
    for (model.Match match in matches) {
      if (chatMap.containsKey(match.matchedUser.id)) {
        model.Chat chat = chatMap[match.matchedUser.id]![match.userId]!;
        if (chat.messages.isNotEmpty) {
          activeMatches.add(match.copyWith(chat: chat));
        } else {
          inactiveMatches.add(match.copyWith(chat: chat));
        }
      } else {
        inactiveMatches.add(match);
      }
    }
    sortMatchesWithChat(activeMatches);
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    inactiveMatches.isEmpty
                        ? Container()
                        : Text('Recently Matched',
                            style: GoogleFonts.aBeeZee(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).accentColor,
                            )),
                    inactiveMatches.isEmpty
                        ? Container()
                        : _buildRecentlyMatched(context, inactiveMatches),
                    inactiveMatches.isEmpty
                        ? Container()
                        : const SizedBox(height: 20),
                    TabBar(
                        padding: EdgeInsets.zero,
                        labelPadding: EdgeInsets.zero,
                        indicatorColor: Theme.of(context).accentColor,
                        labelColor: Theme.of(context).accentColor,
                        unselectedLabelColor: Colors.grey,
                        tabs: const [
                          Tab(text: "Messages"),
                          Tab(text: "Matches")
                        ]),
                    Expanded(
                      child: TabBarView(children: [
                        activeMatches.isNotEmpty
                            ? _buildMessageOptions(context, activeMatches)
                            : Column(children: const [
                                SizedBox(height: 100),
                                CustomTextHeader(text: 'No chats yet'),
                                CustomTextHeader(text: 'Go find some matches')
                              ]),
                        inactiveMatches.isNotEmpty
                            ? _buildMessageOptions(context, inactiveMatches)
                            : Column(children: const [
                                SizedBox(height: 100),
                                CustomTextHeader(text: 'No new matches yet'),
                                CustomTextHeader(text: 'Go find some matches')
                              ])
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        )));
  }

  Widget _buildRecentlyMatched(
      BuildContext context, List<model.Match> inactiveMatches) {
    return SizedBox(
        height: 100,
        child:
            //  StreamBuilder(
            // stream: FirebaseFirestore.instance
            //     .collection('likeduser')
            //     .where('id',
            //         isEqualTo:
            //             FirebaseAuth.instance.currentUser!.uid)
            //     .where('matched', isEqualTo: true)
            //     .snapshots(),
            // builder:
            //     (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            //   if (snapshot.connectionState ==
            //       ConnectionState.waiting) {
            //     return const CircularProgressIndicator();
            //   }
            SizedBox(
          height: 100,
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount:
                  inactiveMatches.length > 4 ? 4 : inactiveMatches.length,
              itemBuilder: (context, index) {
                return Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: SizedBox(
                      child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                    ChatScreen.routeName,
                                    arguments: {
                                      'match': model.Match(
                                          userId: inactiveMatches[index].userId,
                                          matchedUser: inactiveMatches[index]
                                              .matchedUser),
                                      'user': state.user
                                    },
                                  );
                                },
                                child: UserImageSmall(
                                    height: 70,
                                    width: 70,
                                    url: inactiveMatches[index]
                                        .matchedUser
                                        .getProfilePicture()),
                              ),
                              const SizedBox(height: 5),
                              SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: CustomText(
                                    text:
                                        inactiveMatches[index].matchedUser.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.aBeeZee(
                                      color: Colors.black,
                                      fontSize: 13,
                                    ),
                                  )),
                            ],
                          )),
                    ));
              }),
        )
        //}
        );
  }

  Widget _buildMessageOptions(BuildContext context, List<model.Match> matches) {
    List<int> unread = [];
    String id = context.read<AuthBloc>().state.user!.id;
    for (model.Match match in matches) {
      if (match.chat != null) {
        unread.add(match.chat!.getUnreadMessagesCount(id));
      } else {
        unread.add(0);
      }
    }
    return ListView.builder(
        shrinkWrap: true,
        itemCount: matches.length,
        //physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
              onTap: () {
                Navigator.of(context).pushNamed(ChatScreen.routeName,
                    arguments: {'match': matches[index], 'user': state.user});
              },
              child: Row(children: [
                UserImageSmall(
                  height: 65,
                  width: 65,
                  url: matches[index].matchedUser.getProfilePicture(),
                ),
                Flexible(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OverFlowText(
                        text: matches[index].matchedUser.name,
                        style: GoogleFonts.aBeeZee(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 2),
                    matches[index].chat != null &&
                            matches[index].chat!.messages.isNotEmpty
                        ? OverFlowText(
                            text: matches[index].chat!.getLastMessage().message)
                        // overflow: TextOverflow.ellipsis,
                        // style: GoogleFonts.aBeeZee(
                        //   fontSize: 13,
                        //   fontWeight: FontWeight.normal,
                        // ))
                        : Container(),
                    const SizedBox(height: 5),
                    matches[index].chat != null &&
                            matches[index].chat!.messages.isNotEmpty
                        ? Text(
                            timeago
                                .format(matches[index]
                                    .chat!
                                    .getLastMessage()
                                    .dateTime)
                                .toString(),
                            style: GoogleFonts.aBeeZee(
                                fontSize: 12, color: Colors.grey))
                        : Container(),
                  ],
                )),
                //const Spacer(),
                const SizedBox(width: 50),
                unread[index] == 0
                    ? Container()
                    : DecoratedBox(
                        decoration: BoxDecoration(
                            border: Border.all(width: 1),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(100),
                            ),
                            color: Theme.of(context).primaryColor),
                        child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: CustomText(
                                text: unread[index].toString(),
                                style: GoogleFonts.aBeeZee(
                                    fontSize: 12, color: Colors.white)))),
              ]));
        });
  }
}

class OverFlowText extends StatelessWidget {
  final TextStyle? style;
  final String text;
  const OverFlowText({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 0.9 * constraints.maxWidth),
          child: CustomText(
              text: text,
              overflow: TextOverflow.ellipsis,
              style: style ??
                  GoogleFonts.aBeeZee(
                    fontSize: 13,
                    fontWeight: FontWeight.normal,
                  )));
    });
  }
}
