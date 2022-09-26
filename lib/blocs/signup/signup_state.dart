part of 'signup_bloc.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object?> get props => [];
}

class SignUpLoading extends SignUpState {}

class SignUpLoaded extends SignUpState {
  final User user;
  final TabController tabController;
  final double direction;
  //final GoogleMapController? mapController;
  const SignUpLoaded(
      {required this.user, required this.tabController, this.direction = 0
      //this.mapController,
      });

  @override
  List<Object?> get props =>
      [user, tabController, direction]; //,mapController];
}
