import 'dart:async';
// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '/models/models.dart';
import '/repositories/repositories.dart';
import '/blocs/blocs.dart';
import 'package:image_picker/image_picker.dart';
part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final AuthBloc _authBloc;
  final DatabaseRepository _databaseRepository;
  final StorageRepository _storageRepository;
  //final LocationRepository _locationRepository;
  StreamSubscription? _authSubscription;

  ProfileBloc({
    required AuthBloc authBloc,
    required DatabaseRepository databaseRepository,
    required StorageRepository storageRepository,
    //required LocationRepository locationRepository,
  })  : _authBloc = authBloc,
        _databaseRepository = databaseRepository,
        _storageRepository = storageRepository,
        //_locationRepository = locationRepository,
        super(ProfileLoading()) {
    on<LoadProfile>(_onLoadProfile);
    on<EditProfile>(_onEditProfile);
    on<SaveProfile>(_onSaveProfile);
    on<UpdateUserProfile>(_onUpdateUserProfile);
    on<UpdateUserImageProfile>(_onUpdateUserImageProfile);
    on<UpdateUserCoverProfile>(_onUpdateUserCoverProfile);
    on<UpdateUserProfileImageProfile>(_onUpdateUserProfileImageProfile);
    //on<UpdateUserLocation>(_onUpdateUserLocation);

    _authSubscription = _authBloc.stream.listen((state) {
      if (state.user is AuthUserChanged) {
        if (state.user != null) {
          add(LoadProfile(userId: state.authUser!.uid));
        }
      }
    });
  }

  void _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    User user = await _databaseRepository.getUser(event.userId).first;
    emit(ProfileLoaded(user: user, editingFields: const []));
  }

  void _onEditProfile(
    EditProfile event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      ProfileLoaded loadedState = state as ProfileLoaded;
      List<String> editting = loadedState.editingFields.toList();
      if (editting.contains(event.edittingType)) {
        editting.remove(event.edittingType);
        add(SaveProfile(user: loadedState.user));
      } else {
        editting.add(event.edittingType);
      }
      emit(
        ProfileLoaded(
          user: (state as ProfileLoaded).user,
          editingFields: editting,
          //controller: (state as ProfileLoaded).controller,
        ),
      );
    }
  }

  void _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      _databaseRepository.updateUser((state as ProfileLoaded).user);
      emit(
        ProfileLoaded(
          user: (state as ProfileLoaded).user,
          editingFields: (state as ProfileLoaded).editingFields,
          //controller: (state as ProfileLoaded).controller,
        ),
      );
    }
  }

  void _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<ProfileState> emit,
  ) {
    if (state is ProfileLoaded) {
      emit(
        ProfileLoaded(
          user: event.user,
          editingFields: (state as ProfileLoaded).editingFields,
          //controller: (state as ProfileLoaded).controller,
        ),
      );
    }
  }

  // void _onUpdateUserLocation(
  //   UpdateUserLocation event,
  //   Emitter<ProfileState> emit,
  // ) async {
  //   final state = this.state as ProfileLoaded;

  //   if (event.isUpdateComplete && event.location != null) {
  //     print('Getting location with the Places API');
  //     final Location location =
  //         await _locationRepository.getLocation(event.location!.name);

  //     state.controller!.animateCamera(
  //       CameraUpdate.newLatLng(
  //         LatLng(
  //           location.lat.toDouble(),
  //           location.lon.toDouble(),
  //         ),
  //       ),
  //     );

  //     add(UpdateUserProfile(user: state.user.copyWith(location: location)));
  //   } else {
  //     emit(
  //       ProfileLoaded(
  //         user: state.user.copyWith(location: event.location),
  //         controller: event.controller ?? state.controller,
  //         isEditingOn: state.isEditingOn,
  //       ),
  //     );
  //   }
  // }

  void _onUpdateUserImageProfile(
    UpdateUserImageProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      User currentUser = (state as ProfileLoaded).user;
      await _storageRepository.uploadImage(
          currentUser, event.image, event.index);
      _databaseRepository.getUser(currentUser.id).listen((user) {
        add(UpdateUserProfile(user: user));
      });
    }
  }

  void _onUpdateUserCoverProfile(
    UpdateUserCoverProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      User currentUser = (state as ProfileLoaded).user;
      await _storageRepository.uploadCoverImage(currentUser, event.image);
      _databaseRepository.getUser(currentUser.id).listen((user) {
        add(UpdateUserProfile(user: user));
      });
    }
  }

  void _onUpdateUserProfileImageProfile(
    UpdateUserProfileImageProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      User currentUser = (state as ProfileLoaded).user;
      await _storageRepository.uploadProfileImage(currentUser, event.image);
      _databaseRepository.getUser(currentUser.id).listen((user) {
        add(UpdateUserProfile(user: user));
      });
    }
  }

  @override
  Future<void> close() async {
    _authSubscription?.cancel();
    super.close();
  }
}
