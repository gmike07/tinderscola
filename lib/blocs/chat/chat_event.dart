part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class LoadChat extends ChatEvent {
  final model.User user;
  const LoadChat({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateChat extends ChatEvent {
  final model.Chat chat;
  final model.User user;
  final model.User matchedUser;
  const UpdateChat(
      {required this.chat, required this.matchedUser, required this.user});

  @override
  List<Object> get props => [chat, matchedUser];
}

class SendMessage extends ChatEvent {
  final String message;
  final model.User user;
  const SendMessage({required this.message, required this.user});

  @override
  List<Object> get props => [message, user];
}
