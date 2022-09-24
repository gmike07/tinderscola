part of 'swipe_bloc.dart';

abstract class SwipeState extends Equatable {
  final String currentUserId;

  const SwipeState({required this.currentUserId});

  @override
  List<Object> get props => [currentUserId];
}

class SwipeLoading extends SwipeState {
  const SwipeLoading({required currentUserId})
      : super(currentUserId: currentUserId);
}

class SwipeLoaded extends SwipeState {
  final List<User> users;
  const SwipeLoaded({required this.users, required currentUserId})
      : super(currentUserId: currentUserId);

  @override
  List<Object> get props => [users, currentUserId];
}

class SwipeMatched extends SwipeState {
  final User user;
  const SwipeMatched({required this.user, required currentUserId})
      : super(currentUserId: currentUserId);

  @override
  List<Object> get props => [user];
}

class ChatOpened extends SwipeState {
  final Match match;

  const ChatOpened({required this.match, required currentUserId})
      : super(currentUserId: currentUserId);

  @override
  List<Object> get props => [match];
}

class SwipeError extends SwipeState {
  const SwipeError({required currentUserId})
      : super(currentUserId: currentUserId);
}
