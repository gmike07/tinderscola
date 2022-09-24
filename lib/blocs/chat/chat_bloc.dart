import 'package:equatable/equatable.dart';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import '/models/models.dart' as model;
import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

import '/repositories/repositories.dart';
part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _databaseSubscription;

  ChatBloc(
      {required model.Match match,
      required DatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository,
        super(ChatLoading(match: match)) {
    on<LoadChat>((event, emit) async {
      String id = '';
      if (match.chat == null || match.chat!.id == '') {
        if (match.chat != null) {
          id = await _databaseRepository.createChat(match.chat!);
          add(UpdateChat(
              user: event.user,
              chat: match.chat!.copyWith(id: id),
              matchedUser: match.matchedUser));
        } else {
          model.Chat chat = model.Chat(
            id: '',
            userId: match.userId,
            matchedUserId: match.matchedUser.id,
            messages: const [],
          );
          id = await _databaseRepository.createChat(chat);
          await _databaseRepository.updateChat(chat.copyWith(id: id));
        }
      } else {
        id = match.chat!.id;
      }
      _databaseSubscription = _databaseRepository.getChat(id).listen((chat) {
        add(UpdateChat(
            user: event.user, chat: chat, matchedUser: match.matchedUser));
      });
    });
    on<UpdateChat>((event, emit) async {
      await _databaseRepository.updateChat(event.chat);
      emit(ChatLoaded(
          user: event.user, chat: event.chat, matchedUser: event.matchedUser));
      if (event.chat.messages.isNotEmpty) {
        model.Message lastMessage = event.chat.getLastMessage();
        if (!lastMessage.isRead && lastMessage.receiverId == event.user.id) {
          List<model.Message> messages = event.chat.messages.toList();
          for (int i = messages.length - 1; i >= 0; i--) {
            if (messages[i].receiverId != event.user.id) {
              break;
            }
            if (messages[i].isRead) {
              break;
            }
            messages[i] = messages[i].copyWith(isRead: true);
          }
          add(UpdateChat(
              chat: event.chat.copyWith(messages: messages),
              matchedUser: event.matchedUser,
              user: event.user));
        }
      }
    });
    on<SendMessage>((event, emit) async {
      ChatLoaded state = this.state as ChatLoaded;
      await _databaseRepository.sendMessage(
          state.chat,
          model.Message(
              senderId: state.chat.userId,
              receiverId: state.chat.matchedUserId,
              message: event.message,
              dateTime: DateTime.now(),
              timeString: DateFormat('jm').format(DateTime.now()),
              isLiked: false,
              isRead: false));
      // ChatLoaded state = this.state as ChatLoaded;
      // List<model.Message> messages = state.chat.messages;
      // messages.add(model.Message(
      //     senderId: state.chat.userId,
      //     receiverId: state.chat.matchedUserId,
      //     message: event.message,
      //     dateTime: DateTime.now(),
      //     timeString: DateFormat('jm').format(DateTime.now()),
      //     isLiked: false,
      //     isRead: false));
      // add(UpdateChat(
      //     user: event.user,
      //     chat: state.chat.copyWith(messages: messages),
      //     matchedUser: state.matchedUser));
      // add(UpdateChat(
      //     chat: state.chat.copyWith(messages: messages),
      //     matchedUser: match.matchedUser));
    });
  }

  @override
  Future<void> close() async {
    _databaseSubscription?.cancel();
    super.close();
  }
}
