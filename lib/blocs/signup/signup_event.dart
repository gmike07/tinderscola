part of 'signup_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class StartSignUp extends SignUpEvent {
  final User user;
  final TabController tabController;

  const StartSignUp({
    required this.user,
    required this.tabController,
  });

  @override
  List<Object?> get props => [user, tabController];
}

class ContinueSignUp extends SignUpEvent {
  final User user;
  final bool isSignup;

  const ContinueSignUp({
    required this.user,
    this.isSignup = false,
  });

  @override
  List<Object?> get props => [user, isSignup];
}

class UpdateUser extends SignUpEvent {
  final User user;

  const UpdateUser({required this.user});

  @override
  List<Object?> get props => [user];
}

class UpdateDirection extends SignUpEvent {
  final double direction;

  const UpdateDirection({required this.direction});

  @override
  List<Object?> get props => [direction];
}

class SetUserLocation extends SignUpEvent {
  // final Location? location;
  // final GoogleMapController? controller;
  final bool isUpdateComplete;

  const SetUserLocation({
    // this.location,
    // this.controller,
    this.isUpdateComplete = false,
  });

  @override
  List<Object?> get props => [/*location, controller,*/ isUpdateComplete];
}

class UpdateUserImages extends SignUpEvent {
  final User? user;
  final XFile image;
  final int index;

  const UpdateUserImages({this.user, required this.image, required this.index});

  @override
  List<Object?> get props => [user, image, index];
}
