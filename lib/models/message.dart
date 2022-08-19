import 'package:equatable/equatable.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Message extends Equatable {
  final String senderId;
  final String receiverId;
  final String message;
  final DateTime dateTime;
  final String timeString;
  final bool isRead;
  final bool isLiked;

  const Message(
      {required this.senderId,
      required this.receiverId,
      required this.message,
      required this.dateTime,
      required this.timeString,
      required this.isLiked,
      required this.isRead});

  static Message fromMap(Map<String, dynamic> map) {
    return Message(
      senderId: map['senderId'] as String,
      receiverId: map['receiverId'] as String,
      message: map['message'] as String,
      dateTime: DateTime.parse(map['dateTime']),
      timeString: map['timeString'] as String,
      isLiked: map['isLiked'] as bool,
      isRead: map['isRead'] as bool,
    );
  }

  @override
  List<Object?> get props => [
        senderId,
        receiverId,
        message,
        dateTime,
        timeString,
        isLiked,
        isRead,
      ];

  Map<String, dynamic> toMap() {
    return {
      'senderId': senderId,
      'receiverId': receiverId,
      'message': message,
      'dateTime': dateTime.toIso8601String(),
      'timeString': timeString,
      'isLiked': isLiked,
      'isRead': isRead,
    };
  }

  Message copyWith(
      {String? senderId,
      String? receiverId,
      String? message,
      DateTime? dateTime,
      String? timeString,
      bool? isLiked,
      bool? isRead}) {
    return Message(
        senderId: senderId ?? this.senderId,
        receiverId: receiverId ?? this.receiverId,
        message: message ?? this.message,
        dateTime: dateTime ?? this.dateTime,
        timeString: timeString ?? this.timeString,
        isLiked: isLiked ?? this.isLiked,
        isRead: isRead ?? this.isRead);
  }

  static Message fromSnapshot(DocumentSnapshot snapshot) {
    Message message = Message(
        senderId: snapshot.get('senderId'),
        receiverId: snapshot.get('receiverId'),
        message: snapshot.get('message'),
        dateTime: snapshot.get('dateTime') as DateTime,
        timeString: snapshot.get('timeString') as String,
        isLiked: false,
        isRead: false);
    return message;
  }

  // static List<Message> messages = [
  //   Message(
  //       senderId: '1',
  //       receiverId: '2',
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime.now())),
  // ];

  // static List<Message> messages = [
  //   Message(
  //       senderId: '1',
  //       receiverId: '2',
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '2',
  //       receiverId: '1',
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '1',
  //       receiverId: '2',
  //       message: 'I\'m good, as well. Thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '1',
  //       receiverId: '3',
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '3',
  //       receiverId: '1',
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '1',
  //       receiverId: '5',
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '5',
  //       receiverId: '1',
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '1',
  //       receiverId: '6',
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '6',
  //       receiverId: '1',
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '1',
  //       receiverId: '7',
  //       message: 'Hey, how are you?',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  //   Message(
  //       senderId: '7',
  //       receiverId: '1',
  //       message: 'I\'m good, thank you.',
  //       dateTime: DateTime.now(),
  //       timeString: DateFormat('jm').format(DateTime(2020, 1, 1, 1, 1, 1))),
  // ];
}
