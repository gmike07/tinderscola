part of 'match_bloc.dart';

abstract class MatchState extends Equatable {
  const MatchState();

  @override
  List<Object> get props => [];
}

class MatchLoading extends MatchState {}

class MatchLoaded extends MatchState {
  final List<Match> matches;
  final List<Chat> chats;
  final User user;

  const MatchLoaded(
      {this.matches = const <Match>[],
      this.chats = const <Chat>[],
      required this.user});

  @override
  List<Object> get props => [matches, chats, user];
}

class MatchUnavailable extends MatchState {}
