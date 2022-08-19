part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String userId;

  const LoadProfile({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class EditProfile extends ProfileEvent {
  final String edittingType;

  const EditProfile({
    required this.edittingType,
  });

  @override
  List<Object?> get props => [edittingType];
}

class SaveProfile extends ProfileEvent {
  final User user;

  const SaveProfile({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class UpdateUserProfile extends ProfileEvent {
  final User user;

  const UpdateUserProfile({
    required this.user,
  });

  @override
  List<Object?> get props => [user];
}

class UpdateUserImageProfile extends ProfileEvent {
  final User? user;
  final XFile image;
  final int index;
  const UpdateUserImageProfile({
    this.user,
    required this.image,
    required this.index,
  });

  @override
  List<Object?> get props => [user, image, index];
}

class UpdateUserProfileImageProfile extends ProfileEvent {
  final User? user;
  final XFile image;
  const UpdateUserProfileImageProfile({this.user, required this.image});

  @override
  List<Object?> get props => [user, image];
}

class UpdateUserCoverProfile extends ProfileEvent {
  final User? user;
  final XFile image;
  const UpdateUserCoverProfile({this.user, required this.image});

  @override
  List<Object?> get props => [user, image];
}

class UpdateUserLocation extends ProfileEvent {
  // final Location? location;
  // final GoogleMapController? controller;
  final bool isUpdateComplete;

  const UpdateUserLocation({
    // this.location,
    // this.controller,
    this.isUpdateComplete = false,
  });

  @override
  List<Object?> get props => [/*location, controller,*/ isUpdateComplete];
}

// class UpdateUserImages extends OnboardingEvent {
//   final User? user;
//   final XFile image;

//   const UpdateUserImages({
//     this.user,
//     required this.image,
//   });

//   @override
//   List<Object?> get props => [user, image];
// }
