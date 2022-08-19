part of 'match_bloc.dart';

abstract class MatchEvent extends Equatable {
  const MatchEvent();

  @override
  List<Object> get props => [];
}

class LoadMatches extends MatchEvent {
  final User user;

  const LoadMatches({required this.user});

  @override
  List<Object> get props => [user];
}

class UpdateMatches extends MatchEvent {
  final List<Match> matchedUsers;
  final User user;

  const UpdateMatches({required this.user, required this.matchedUsers});

  @override
  List<Object> get props => [matchedUsers];
}

class UpdateChats extends MatchEvent {
  final List<Match> matchedUsers;
  final List<Chat> chats;
  final User user;
  const UpdateChats(
      {required this.chats, required this.matchedUsers, required this.user});

  @override
  List<Object> get props => [matchedUsers];
}
