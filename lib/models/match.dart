import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'models.dart';

class Match extends Equatable {
  final String userId;
  final User matchedUser;
  final Chat? chat;

  const Match({
    required this.userId,
    required this.matchedUser,
    this.chat,
  });

  static Match fromSnapshot(
    DocumentSnapshot snap,
    String userId,
  ) {
    Match match = Match(
      userId: userId,
      matchedUser: User.fromSnapshot(snap),
    );
    return match;
  }

  Match copyWith({
    String? userId,
    User? matchedUser,
    Chat? chat,
  }) {
    return Match(
      userId: userId ?? this.userId,
      matchedUser: matchedUser ?? this.matchedUser,
      chat: chat ?? this.chat,
    );
  }

  @override
  List<Object?> get props => [userId, matchedUser, chat];

  // static List<Match> matches = [
  //   Match(
  //     userId: '1',
  //     matchedUser: User.users[1],
  //     chat: Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '2')
  //             .toList()
  //             .isNotEmpty
  //         ? Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '2')
  //             .toList()[0]
  //         : Chat(
  //             id: '0',
  //             userId: '1',
  //             matchedUserId: '2', messages: [],
  //             //lastMessageDate: DateTime.now()
  //           ),
  //   ),
  //   Match(
  //     userId: '1',
  //     matchedUser: User.users[2],
  //     chat: Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '3')
  //             .toList()
  //             .isNotEmpty
  //         ? Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '3')
  //             .toList()[0]
  //         : Chat(
  //             id: '0',
  //             userId: '1',
  //             matchedUserId: '3', messages: [],
  //             //lastMessageDate: DateTime.now()
  //           ),
  //   ),
  //   Match(
  //     userId: '1',
  //     matchedUser: User.users[3],
  //     chat: Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '4')
  //             .toList()
  //             .isNotEmpty
  //         ? Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '4')
  //             .toList()[0]
  //         : Chat(
  //             id: '0',
  //             userId: '1',
  //             matchedUserId: '4', messages: [],
  //             //lastMessageDate: DateTime.now()
  //           ),
  //   ),
  //   Match(
  //     userId: '1',
  //     matchedUser: User.users[4],
  //     chat: Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '5')
  //             .toList()
  //             .isNotEmpty
  //         ? Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '5')
  //             .toList()[0]
  //         : Chat(
  //             id: '0',
  //             userId: '1',
  //             matchedUserId: '5', messages: [],
  //             //lastMessageDate: DateTime.now()
  //           ),
  //   ),
  //   Match(
  //     userId: '1',
  //     matchedUser: User.users[5],
  //     chat: Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '6')
  //             .toList()
  //             .isNotEmpty
  //         ? Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '6')
  //             .toList()[0]
  //         : Chat(
  //             id: '0',
  //             userId: '1',
  //             matchedUserId: '6', messages: [],
  //             //lastMessageDate: DateTime.now()
  //           ),
  //   ),
  //   Match(
  //     userId: '1',
  //     matchedUser: User.users[6],
  //     chat: Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '7')
  //             .toList()
  //             .isNotEmpty
  //         ? Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '7')
  //             .toList()[0]
  //         : Chat(
  //             id: '0',
  //             userId: '1',
  //             matchedUserId: '7', messages: [],
  //             //lastMessageDate: DateTime.now()
  //           ),
  //   ),
  //   Match(
  //     userId: '1',
  //     matchedUser: User.users[7],
  //     chat: Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '8')
  //             .toList()
  //             .isNotEmpty
  //         ? Chat.chats
  //             .where((chat) => chat.userId == '1' && chat.matchedUserId == '8')
  //             .toList()[0]
  //         : Chat(
  //             id: '0',
  //             userId: '1',
  //             matchedUserId: '8',
  //             messages: [],
  //             //lastMessageDate: DateTime.now()
  //           ),
  //   ),
  // ];
}
