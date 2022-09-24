import 'dart:async';

// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/blocs/blocs.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';

part 'swipe_event.dart';
part 'swipe_state.dart';

class SwipeBloc extends Bloc<SwipeEvent, SwipeState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _authSubscription;
  StreamSubscription? _databaseSubscription;

  SwipeBloc(
      {required AuthBloc authBloc,
      required DatabaseRepository databaseRepository,
      required String currentUserId})
      : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        super(SwipeLoading(currentUserId: currentUserId)) {
    on<LoadUsers>(_onLoadUsers);
    on<UpdateHome>(_onUpdateHome);
    on<SwipeLeft>(_onSwipeLeft);
    on<SwipeRight>(_onSwipeRight);
    on<SwipeLater>(_onSwipeLater);
    on<OpenChat>(_onOpenChat);
    on<OpenChatLoaded>(_onOpenChatLoaded);
    //on<ReloadSwipe>(_onReloadSwipe);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.status == AuthStatus.authenticated) {
        add(LoadUsers());
      }
    });
  }

  void _onLoadUsers(
    LoadUsers event,
    Emitter<SwipeState> emit,
  ) {
    if (_authBloc.state.user != null) {
      User currentUser = _authBloc.state.user!;
      _databaseRepository.getUsersToSwipe(currentUser).listen((users) {
        add(UpdateHome(users: users));
      });
    }
  }

  void _onUpdateHome(
    UpdateHome event,
    Emitter<SwipeState> emit,
  ) {
    if (event.users!.isNotEmpty) {
      emit(
          SwipeLoaded(users: event.users!, currentUserId: state.currentUserId));
    } else {
      emit(SwipeError(currentUserId: state.currentUserId));
    }
  }

  void _onSwipeLeft(
    SwipeLeft event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;

      List<User> users = List.from(state.users)..remove(event.user);

      _databaseRepository.updateUserSwipe(
        _authBloc.state.authUser!.uid,
        event.user.id,
        false,
      );

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users, currentUserId: state.currentUserId));
      } else {
        emit(SwipeError(currentUserId: state.currentUserId));
      }
    }
  }

  void _onSwipeRight(
    SwipeRight event,
    Emitter<SwipeState> emit,
  ) async {
    final state = this.state as SwipeLoaded;
    String userId = _authBloc.state.authUser!.uid;
    List<User> users = List.from(state.users)..remove(event.user);
    _databaseRepository.updateUserSwipe(
      userId,
      event.user.id,
      true,
    );

    if (event.user.swipeRight.contains(userId)) {
      await _databaseRepository.updateUserMatch(
        userId,
        event.user.id,
      );
      emit(SwipeMatched(user: event.user, currentUserId: state.currentUserId));
      Chat chat = Chat(
          id: '',
          userId: userId,
          matchedUserId: event.user.id,
          messages: const []);
      String id = await _databaseRepository.createChat(chat);
      await _databaseRepository.updateChat(chat.copyWith(id: id));
    } else if (users.isNotEmpty) {
      emit(SwipeLoaded(users: users, currentUserId: state.currentUserId));
    } else {
      emit(SwipeError(currentUserId: state.currentUserId));
    }
  }

  void _onSwipeLater(
    SwipeLater event,
    Emitter<SwipeState> emit,
  ) {
    if (state is SwipeLoaded) {
      final state = this.state as SwipeLoaded;

      List<User> users = List.from(state.users)..remove(event.user);

      if (users.isNotEmpty) {
        emit(SwipeLoaded(users: users, currentUserId: state.currentUserId));
      } else {
        emit(SwipeError(currentUserId: state.currentUserId));
      }
    }
  }

  void _onOpenChat(
    OpenChat event,
    Emitter<SwipeState> emit,
  ) async {
    if (state is SwipeMatched) {
      final state = this.state as SwipeMatched;
      String userId = _authBloc.state.authUser!.uid;
      _databaseSubscription = _databaseRepository
          .getChatsForUsers(state.user.id, userId)
          .listen((chat) {
        add(OpenChatLoaded(
            match: Match(userId: userId, chat: chat, matchedUser: state.user)));
      });
    }
  }

  void _onOpenChatLoaded(
    OpenChatLoaded event,
    Emitter<SwipeState> emit,
  ) async {
    emit(ChatOpened(match: event.match, currentUserId: state.currentUserId));
  }

  @override
  Future<void> close() async {
    _databaseSubscription?.cancel();
    _authSubscription?.cancel();
    super.close();
  }
}
