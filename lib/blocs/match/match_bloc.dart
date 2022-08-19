import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '/models/models.dart';
import '/repositories/repositories.dart';

part 'match_event.dart';
part 'match_state.dart';

class MatchBloc extends Bloc<MatchEvent, MatchState> {
  final DatabaseRepository _databaseRepository;
  StreamSubscription? _databaseSubscription;

  MatchBloc({
    required DatabaseRepository databaseRepository,
  })  : _databaseRepository = databaseRepository,
        super(MatchLoading()) {
    on<LoadMatches>(_onLoadMatches);
    on<UpdateMatches>(_onUpdateMatches);

    on<UpdateChats>(_onUpdateChats);
  }

  void _onLoadMatches(
    LoadMatches event,
    Emitter<MatchState> emit,
  ) async {
    _databaseSubscription =
        _databaseRepository.getMatches(event.user).listen((matchedUsers) {
      add(UpdateMatches(user: event.user, matchedUsers: matchedUsers));
    });
  }

  void _onUpdateMatches(
    UpdateMatches event,
    Emitter<MatchState> emit,
  ) {
    if (event.matchedUsers.isEmpty) {
      emit(MatchLoaded(user: event.user));
    } else {
      _databaseSubscription =
          _databaseRepository.getChats(event.user).listen((chats) {
        add(UpdateChats(
            chats: chats, matchedUsers: event.matchedUsers, user: event.user));
      });
    }
  }

  void _onUpdateChats(
    UpdateChats event,
    Emitter<MatchState> emit,
  ) {
    emit(MatchLoaded(
        user: event.user, matches: event.matchedUsers, chats: event.chats));
  }

  @override
  Future<void> close() async {
    _databaseSubscription?.cancel();
    super.close();
  }
}
