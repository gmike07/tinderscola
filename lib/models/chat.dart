import 'package:equatable/equatable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/models/models.dart';

class Chat extends Equatable {
  final String id;
  final String userId;
  final String matchedUserId;
  final List<Message> messages;

  Message getLastMessage() {
    return messages[messages.length - 1];
  }

  int getUnreadMessagesCount(String id) {
    int count = 0;
    for (int i = messages.length - 1; i >= 0; i--) {
      if (!messages[i].isRead && messages[i].receiverId == userId) {
        count++;
      }
    }
    return count;
  }

  const Chat({
    required this.id,
    required this.userId,
    required this.matchedUserId,
    required this.messages,
    // required this.lastMessageDate,
  });

  static List<String> convertList(List<dynamic> lst) {
    return lst.map((item) => (item as String)).toList();
  }

  @override
  List<Object?> get props => [id, userId, matchedUserId, messages];

  // static List<Chat> chats = [
  //   Chat(
  //     id: '1',
  //     userId: '1',
  //     matchedUserId: '2',
  //     messages: Message.messages
  //         .where((message) =>
  //             (message.senderId == 1 && message.receiverId == 2) ||
  //             (message.senderId == 2 && message.receiverId == 1))
  //         .toList(),
  //     //lastMessageDate: DateTime.now(),
  //   ),
  // ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'matchedUserId': matchedUserId,
      'messages': messages.map((message) => message.toMap()).toList(),
      //'lastMessageDate': lastMessageDate,
    };
  }

  Chat copyWith(
      {String? id,
      String? userId,
      String? matchedUserId,
      List<Message>? messages}) {
    return Chat(
        id: id ?? this.id,
        userId: userId ?? this.userId,
        matchedUserId: matchedUserId ?? this.matchedUserId,
        messages: messages ?? this.messages);
  }

  static Chat fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data()! as Map<String, dynamic>;
    List<dynamic> messages = data['messages'] as List<dynamic>;
    List<Message> messagesList = messages
        .map((message) => Message.fromMap(message as Map<String, dynamic>))
        .toList();
    Chat chat = Chat(
      id: snapshot.get('id') as String,
      userId: snapshot.get('userId') as String,
      matchedUserId: snapshot.get('matchedUserId') as String,
      messages: messagesList,
      //lastMessageDate: snapshot.get('lastMessageDate') as DateTime
    );
    return chat;
  }
}
