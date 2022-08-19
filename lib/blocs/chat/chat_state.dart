part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatLoading extends ChatState {
  final model.Match match;
  const ChatLoading({required this.match});

  @override
  List<Object> get props => [match];
}

class ChatLoaded extends ChatState {
  final model.Chat chat;
  final model.User matchedUser;
  final model.User user;
  const ChatLoaded(
      {required this.chat, required this.matchedUser, required this.user});

  @override
  List<Object> get props => [chat, matchedUser, user];
}
