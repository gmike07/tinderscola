// ignore_for_file: prefer_const_constructors, deprecated_member_use
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/models/models.dart';
import 'screens.dart';
import '/repositories/repositories.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/widgets/widgets.dart';
import '/config/theme.dart';
import '/blocs/blocs.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({Key? key}) : super(key: key);

  static const String routeName = '/chat';

  static Route route({required User user, required Match match}) {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ChatBloc>(
        create: (context) => ChatBloc(
          match: match,
          databaseRepository: context.read<DatabaseRepository>(),
        )..add(LoadChat(user: user)),
        child: ChatScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatBloc, ChatState>(builder: (context, state) {
      if (state is ChatLoading) {
        return Scaffold(
            body: SafeArea(
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
        )))));
      }
      if (state is ChatLoaded) {
        return ChatScreenLoaded(state: state);
      }
      return const Text('Something went wrong.');
    });
  }
}

class ChatScreenLoaded extends StatefulWidget {
  final ChatLoaded state;
  static const String routeName = '/chat';
  const ChatScreenLoaded({Key? key, required this.state}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ChatScreenLoadedState createState() => _ChatScreenLoadedState();
}

class _ChatScreenLoadedState extends State<ChatScreenLoaded> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Color(0xFFF4F4F4),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          actions: const [
            Icon(
              Icons.more_vert_outlined,
              color: Colors.black,
            )
          ],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            color: Colors.black,
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: GestureDetector(
              onTap: () {
                Navigator.of(context).pushNamed(UserScreen.routeName,
                    arguments: {'user': widget.state.matchedUser});
              },
              child: SizedBox(
                child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Expanded(
                        child: Row(children: [
                      CircleAvatar(
                          radius: 27,
                          backgroundImage: NetworkImage(
                              widget.state.matchedUser.getProfilePicture())),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CustomText(
                            text: widget.state.matchedUser.name,
                            style: ChatColors.nameStyle,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ]))),
              ))),
      body: widget.state.chat.messages.isEmpty
          ? Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                        child: _FirstMeeting(
                            me: widget.state.user,
                            matchedUser: widget.state.matchedUser))),
                Spacer(),
                ChatContainer(state: widget.state, notifyParent: refresh)
              ],
            )
          : Column(
              children: [
                Expanded(
                    child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.state.chat.messages.length,
                  reverse: false,
                  controller: _scrollController,
                  itemBuilder: (context, index) {
                    return ListTile(
                        title: _Message(
                            message: widget.state.chat.messages[index],
                            state: widget.state,
                            currentUserId: widget.state.user.id,
                            index: index));
                  },
                )),
                ChatContainer(state: widget.state, notifyParent: refresh)
              ],
            ),
    );
  }

  void refresh() {
    setState(() {
      if (widget.state.chat.messages.length > 1) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 300),
        );
      }
    });
  }
}

// ignore: must_be_immutable
class ChatContainer extends StatelessWidget {
  final ChatLoaded state;
  final Function() notifyParent;
  ChatContainer({Key? key, required this.state, required this.notifyParent})
      : super(key: key);
  String text = '';

  @override
  Widget build(BuildContext context) {
    var controller = TextEditingController();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     height: 30,
              //     width: 30,
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColorLight,
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     child: Icon(
              //       Icons.camera_alt_outlined,
              //       color: Colors.white,
              //       size: 20,
              //     ),
              //   ),
              // ),
              // const SizedBox(width: 5),
              // GestureDetector(
              //   onTap: () {},
              //   child: Container(
              //     height: 30,
              //     width: 30,
              //     decoration: BoxDecoration(
              //       color: Theme.of(context).primaryColorLight,
              //       borderRadius: BorderRadius.circular(30),
              //     ),
              //     child: Icon(
              //       Icons.mic_none,
              //       color: Colors.white,
              //       size: 20,
              //     ),
              //   ),
              // ),
              SizedBox(width: 15),
              Expanded(
                child: HerbrewCustomTextFieldWrapper(
                  controller: controller,
                  decoration: InputDecoration(
                      hintText: "Type a message...",
                      hintStyle: ChatColors.hintStyle,
                      border: InputBorder.none),
                  onChanged: (value) {
                    text = value;
                  },
                ),
              ),
              SizedBox(width: 15),
              FloatingActionButton(
                onPressed: () {
                  if (text != '') {
                    context
                        .read<ChatBloc>()
                        .add(SendMessage(message: text, user: state.user));
                    notifyParent();
                    controller.clear();
                  }
                },
                backgroundColor: ChatColors.sendButtonBackgroundColor,
                elevation: 0,
                child: Icon(
                  Icons.send,
                  color: ChatColors.sendButtonColor,
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FirstMeeting extends StatelessWidget {
  const _FirstMeeting({Key? key, required this.me, required this.matchedUser})
      : super(key: key);

  final User me;
  final User matchedUser;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
        Column(
          children: [
            Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                  matchedUser.getProfilePicture()))),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(me.getProfilePicture()))),
                    ),
                  ],
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  top: 0,
                  bottom: 0,
                  child: Container(
                    height: 20,
                    width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                          width: 3, color: Theme.of(context).accentColor),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: SizedBox(
                      height: 25,
                      width: 25,
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Center(
                          child: Image.asset(
                            'assets/images/connect.png',
                            color: Theme.of(context).accentColor,
                            width: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CustomText(
              text:
                  "You Connected with ${matchedUser.name}, \n Message them now!",
              textAlign: TextAlign.center,
              style: GoogleFonts.aBeeZee(
                color: Colors.grey,
                fontSize: 15,
              ),
            )
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message(
      {Key? key,
      required this.message,
      required this.currentUserId,
      required this.state,
      required this.index})
      : super(key: key);
  final ChatLoaded state;
  final Message message;
  final String currentUserId;
  final int index;

  @override
  Widget build(BuildContext context) {
    bool isFromCurrentUser = message.senderId == currentUserId;
    AlignmentGeometry alignment =
        isFromCurrentUser ? Alignment.topRight : Alignment.topLeft;
    Color color = isFromCurrentUser
        ? ChatColors.myMessageColorBackground
        : ChatColors.matchedMessageColorBackground;
    TextStyle? textStyle = isFromCurrentUser
        ? Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: ChatColors.myMessageTextColor)
        : Theme.of(context)
            .textTheme
            .headline6!
            .copyWith(color: ChatColors.matchedMessageTextColor);
    TextStyle? textStyle2 =
        textStyle.copyWith(fontSize: 10.0, color: ChatColors.timestampColor);

    Widget like = isFromCurrentUser
        ? Row(mainAxisAlignment: MainAxisAlignment.end, children: [
            Icon(Icons.favorite,
                color: ChatColors.heartColor, size: ChatColors.heartSize),
            Text(message.timeString, style: textStyle2),
          ])
        : Row(mainAxisAlignment: MainAxisAlignment.start, children: [
            Text(message.timeString, style: textStyle2),
            Icon(Icons.favorite,
                color: ChatColors.heartColor, size: ChatColors.heartSize)
          ]);
    return CustomContainer(
        isFromCurrentUser: isFromCurrentUser,
        child: GestureDetector(
            onDoubleTap: () {
              if (isFromCurrentUser) {
                return;
              }
              List<Message> messages = state.chat.messages.toList();
              messages[index] =
                  messages[index].copyWith(isLiked: !messages[index].isLiked);
              context.read<ChatBloc>().add(UpdateChat(
                  chat: state.chat.copyWith(messages: messages),
                  matchedUser: state.matchedUser,
                  user: state.user));
            },
            child: Column(children: [
              Align(
                  alignment: alignment,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      color: color,
                    ),
                    child: CustomText(
                      text: message.message,
                      style: textStyle,
                    ),
                  )),
              message.isLiked
                  ? like
                  : Align(
                      alignment: alignment,
                      child: Text(message.timeString, style: textStyle2))
            ])));
  }
}

class CustomContainer extends StatelessWidget {
  final Widget child;
  final bool isFromCurrentUser;
  const CustomContainer(
      {Key? key, required this.isFromCurrentUser, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isFromCurrentUser) {
      return Container(padding: const EdgeInsets.only(left: 70), child: child);
    }
    return Container(padding: const EdgeInsets.only(right: 70), child: child);
  }
}
