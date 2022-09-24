// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '/models/models.dart';
import '/repositories/repositories.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  //final LocationRepository _locationRepository;

  SignUpBloc({
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository,
    //required LocationRepository locationRepository,
  })  : _databaseRepository = databaseRepository,
        _storageRepository = storageRepository,
        //_locationRepository = locationRepository,
        super(SignUpLoading()) {
    on<StartSignUp>(_onStartSignUp);
    on<ContinueSignUp>(_onContinueSignUp);
    on<UpdateUser>(_onUpdateUser);
    on<UpdateUserImages>(_onUpdateUserImages);
    //on<SetUserLocation>(_onSetUserLocation);
  }

  void _onStartSignUp(
    StartSignUp event,
    Emitter<SignUpState> emit,
  ) async {
    emit(
      SignUpLoaded(
        user: User.empty,
        tabController: event.tabController,
      ),
    );
  }

  void _onContinueSignUp(
    ContinueSignUp event,
    Emitter<SignUpState> emit,
  ) async {
    final state = this.state as SignUpLoaded;
    emit(SignUpLoaded(user: event.user, tabController: state.tabController));
    if (event.isSignup) {
      await _databaseRepository.createUser(event.user);
    }
    _databaseRepository.updateUser(event.user);

    if (state.tabController.index != 5) {
      state.tabController.animateTo(state.tabController.index + 1);
    }
  }

  void _onUpdateUser(
    UpdateUser event,
    Emitter<SignUpState> emit,
  ) {
    if (state is SignUpLoaded) {
      emit(
        SignUpLoaded(
            user: event.user,
            tabController: (state as SignUpLoaded).tabController),
      );
    }
  }

  void _onUpdateUserImages(
    UpdateUserImages event,
    Emitter<SignUpState> emit,
  ) async {
    if (state is SignUpLoaded) {
      User currentUser = (state as SignUpLoaded).user;
      await _storageRepository.uploadImage(
          currentUser, event.image, event.index);
      _databaseRepository.getUser(currentUser.id).listen((user) {
        add(UpdateUser(user: user));
      });
    }
  }

  // void _onSetUserLocation(
  //   SetUserLocation event,
  //   Emitter<SignUpState> emit,
  // ) async {
  //   final state = this.state as OnboardingLoaded;

  //   if (event.isUpdateComplete && event.location != null) {
  //     print('Getting location with the Places API');
  //     final Location location =
  //         await _locationRepository.getLocation(event.location!.name);

  //     state.mapController!.animateCamera(
  //       CameraUpdate.newLatLng(
  //         LatLng(
  //           location.lat.toDouble(),
  //           location.lon.toDouble(),
  //         ),
  //       ),
  //     );

  //     _databaseRepository.getUser(state.user.id!).listen((user) {
  //       add(UpdateUser(user: state.user.copyWith(location: location)));
  //     });
  //   } else {
  //     emit(
  //       OnboardingLoaded(
  //         user: state.user.copyWith(location: event.location),
  //         mapController: event.controller ?? state.mapController,
  //         tabController: state.tabController,
  //       ),
  //     );
  //   }
  // }
}
