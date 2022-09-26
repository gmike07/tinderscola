// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinderscola_final/config/constants.dart';
import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'screens.dart';
import '/repositories/repositories.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  static const String routeName = '/profilescreen';
  // static Route route() {
  //   return MaterialPageRoute(
  //     settings: const RouteSettings(name: routeName),
  //     builder: (context) {
  //       return BlocProvider.of<AuthBloc>(context).state.status ==
  //               AuthStatus.unauthenticated
  //           ? LoginScreen()
  //           : BlocProvider<ProfileBloc>(
  //               create: (context) => ProfileBloc(
  //                 authBloc: BlocProvider.of<AuthBloc>(context),
  //                 databaseRepository: context.read<DatabaseRepository>(),
  //                 storageRepository: context.read<StorageRepository>(),
  //                 //locationRepository: context.read<LocationRepository>(),
  //               )..add(
  //                   LoadProfile(
  //                       userId: context.read<AuthBloc>().state.authUser!.uid),
  //                 ),
  //               child: const ProfileScreen(),
  //             );
  //     },
  //   );
  // }

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => const ProfileScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: SingleChildScrollView(child: SingleChildScrollView(
        child:
            BlocBuilder<ProfileBloc, ProfileState>(builder: (context, state) {
      if (state is ProfileLoading) {
        return SafeArea(
            child: SingleChildScrollView(
                child: Expanded(
                    child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 150),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [CircularProgressIndicator()],
            )
          ],
        ))));
      }
      if (state is ProfileLoaded) {
        return ProfileScreenLoaded(state: state);
      }
      return const Text('Something went wrong.');
    }))));
  }
}

// ignore: must_be_immutable
class ProfileScreenLoaded extends StatelessWidget {
  final ProfileLoaded state;
  ProfileScreenLoaded({Key? key, required this.state}) : super(key: key);

  final String pictureString = 'profile picture';
  final String nameString = 'name';
  final String ageString = 'age';
  final String bioString = 'bio';

  final String genderString = 'gender';
  final String intrestedInString = 'inrestedInGender';
  final String interestString = 'interest';
  final String profileString = 'profile';
  final String coverString = 'cover';

  String currentInterest = '';

  VoidCallback onPressed(BuildContext context, int index) {
    return () async {
      ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        AppConstants.showToast("No image selected");
      } else {
        // ignore: use_build_context_synchronously
        context.read<ProfileBloc>().add(UpdateUserImageProfile(
            user: state.user, image: image, index: index));
      }
    };
  }

  VoidCallback onPressedProfile(BuildContext context) {
    return () async {
      ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        AppConstants.showToast("No image selected");
      } else {
        // ignore: use_build_context_synchronously
        context
            .read<ProfileBloc>()
            .add(UpdateUserProfileImageProfile(user: state.user, image: image));
      }
    };
  }

  VoidCallback onPressedCover(BuildContext context) {
    return () async {
      ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        AppConstants.showToast("No image selected");
      } else {
        // ignore: use_build_context_synchronously
        context
            .read<ProfileBloc>()
            .add(UpdateUserCoverProfile(user: state.user, image: image));
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    TextEditingController controller = TextEditingController();
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 25.0),
        child: Column(children: [
          const SizedBox(height: 5),
          EdittableRow(
              editType: nameString,
              state: state,
              child: !state.editingFields.contains(nameString)
                  ? CustomTextHeader(text: 'Name: ${state.user.name}')
                  : CustomTextField(
                      hint: 'John Doe',
                      icon: EvaIcons.person,
                      onChanged: (name) {
                        context.read<ProfileBloc>().add(UpdateUserProfile(
                            user: state.user.copyWith(name: name)));
                      })),
          const SizedBox(height: 5),
          EdittableRow(
              editType: ageString,
              state: state,
              child: !state.editingFields.contains(ageString)
                  ? CustomTextHeader(text: 'Age: ${state.user.age}')
                  : CustomTextField(
                      hint: '20',
                      icon: EvaIcons.percent,
                      keyboardType: TextInputType.number,
                      onChanged: (age) {
                        context.read<ProfileBloc>().add(UpdateUserProfile(
                            user: state.user.copyWith(age: int.parse(age))));
                      })),
          const SizedBox(height: 5),
          EdittableRow(
              editType: bioString,
              state: state,
              child: !state.editingFields.contains(bioString)
                  ? CustomTextHeader(text: 'Bio:\n ${state.user.bio}')
                  : CustomTextField(
                      icon: Icons.person_add,
                      hint: 'Software Engineer at Google',
                      onChanged: (bio) {
                        context.read<ProfileBloc>().add(UpdateUserProfile(
                            user: state.user.copyWith(bio: bio)));
                      })),
          const SizedBox(height: 5),
          EdittableRow(
              editType: genderString,
              state: state,
              child: const CustomTextHeader(text: 'Gender:')),
          GenderWidget(
              isSelected: (gender) {
                return state.user.gender.contains(gender);
              },
              onPressed: (gender) {
                return () {
                  if (!state.editingFields.contains(genderString)) {
                    return;
                  }
                  List<String> genders = state.user.gender.toList();
                  if (genders.contains(gender)) {
                    if (genders.length == 1) {
                      AppConstants.showToast(
                          'please select at least one gender');
                    } else {
                      genders.remove(gender);
                    }
                  } else {
                    genders.add(gender);
                  }
                  context.read<ProfileBloc>().add(UpdateUserProfile(
                      user: state.user.copyWith(gender: genders)));
                };
              },
              addFriendOption: false),
          const SizedBox(height: 5),
          EdittableRow(
              editType: intrestedInString,
              state: state,
              child: const CustomTextHeader(text: 'Gender Preferences:')),
          GenderWidget(
              isSelected: (gender) {
                return state.user.genderPreference.contains(gender);
              },
              onPressed: (gender) {
                return () {
                  if (!state.editingFields.contains(intrestedInString)) {
                    return;
                  }
                  List<String> intrestedGenders =
                      state.user.genderPreference.toList();
                  if (intrestedGenders.contains(gender)) {
                    intrestedGenders.remove(gender);
                  } else {
                    intrestedGenders.add(gender);
                  }
                  context.read<ProfileBloc>().add(UpdateUserProfile(
                      user: state.user
                          .copyWith(genderPreference: intrestedGenders)));
                };
              },
              addFriendOption: true),
          const SizedBox(height: 5),
          EdittableRow(
              editType: pictureString,
              state: state,
              child: const CustomTextHeader(text: 'Pictures:')),
          !state.editingFields.contains(pictureString)
              ? _buildPictures(context)
              : Column(
                  children: [
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CustomImageContainer(
                          imageUrl: state.user.imageUrls[0],
                          onPressed: onPressed(context, 0),
                        ),
                        CustomImageContainer(
                            imageUrl: state.user.imageUrls[1],
                            onPressed: onPressed(context, 1)),
                        CustomImageContainer(
                            imageUrl: state.user.imageUrls[2],
                            onPressed: onPressed(context, 2)),
                      ],
                    ),
                    Row(
                      children: [
                        CustomImageContainer(
                            imageUrl: state.user.imageUrls[3],
                            onPressed: onPressed(context, 3)),
                        CustomImageContainer(
                            imageUrl: state.user.imageUrls[4],
                            onPressed: onPressed(context, 4)),
                        CustomImageContainer(
                            imageUrl: state.user.imageUrls[5],
                            onPressed: onPressed(context, 5)),
                      ],
                    ),
                  ],
                ),
          const SizedBox(height: 5),
          EdittableRow(
              editType: interestString,
              onPressed: () {
                context.read<ProfileBloc>().add(UpdateUserProfile(
                    user: state.user
                        .copyWith(optionalInterests: state.user.interests)));
              },
              state: state,
              child: const CustomTextHeader(text: 'Interests:')),
          getInterestsRow(context),
          const SizedBox(height: 5),
          state.editingFields.contains(interestString)
              ? const CustomTextHeader(text: 'Add custom Interesets here')
              : Container(),
          state.editingFields.contains(interestString)
              ? const SizedBox(height: 10)
              : Container(),
          !state.editingFields.contains(interestString)
              ? Container()
              : Row(
                  children: [
                    Expanded(
                        child: HerbrewCustomTextFieldWrapper(
                      controller: controller,
                      decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          hintText: 'Add custom Interesets here',
                          hintStyle: GoogleFonts.aBeeZee(
                            fontSize: 13,
                            color: Colors.grey,
                          )),
                      onChanged: (value) {
                        currentInterest = value;
                      },
                    )),
                    IconButton(
                        onPressed: () {
                          if (currentInterest.isNotEmpty &&
                              state.editingFields.contains(interestString)) {
                            List<String> optionalInterests =
                                state.user.optionalInterests!.toList();
                            List<String> interests =
                                state.user.interests.toList();
                            optionalInterests.add(currentInterest);
                            interests.add(currentInterest);
                            controller.clear();
                            context.read<ProfileBloc>().add(UpdateUserProfile(
                                user: state.user.copyWith(
                                    interests: interests,
                                    optionalInterests: optionalInterests)));
                          }
                        },
                        icon: const Icon(Icons.send)),
                  ],
                ),
          const SizedBox(height: 5),
          EdittableRow(
              editType: profileString,
              state: state,
              child: const CustomTextHeader(text: 'Profile picture:')),
          CustomImageContainer(
              imageUrl: state.user.getProfilePicture(),
              onPressed: state.editingFields.contains(profileString)
                  ? onPressedProfile(context)
                  : null),
          const SizedBox(height: 5),
          EdittableRow(
              editType: coverString,
              state: state,
              child: const CustomTextHeader(text: 'Cover picture:')),
          CustomImageContainer(
              imageUrl: state.user.getCoverPicture(),
              onPressed: state.editingFields.contains(coverString)
                  ? onPressedCover(context)
                  : null),
          const SizedBox(height: 20),
          CustomButton(
              text: 'preview profile',
              onPressed: () {
                Navigator.of(context).pushNamed(UserScreen.routeName,
                    arguments: {
                      'user': state.user,
                      'currentUserId': state.user.id
                    });
              }),
          const SizedBox(height: 20),
          CustomButton(
              text: 'signout',
              onPressed: () {
                RepositoryProvider.of<AuthRepository>(context).signOut();
                Navigator.of(context).popAndPushNamed(MainScreen.routeName);
              }),
        ]));
  }

  Widget getInterestsRow(BuildContext context) {
    return Choices(
        options: state.user.optionalInterests!,
        isSelected: (interest) {
          return state.editingFields.contains(interestString) &&
              state.user.interests.contains(interest);
        },
        onPressed: (interest) {
          return () {
            if (!state.editingFields.contains(interestString)) {
              return;
            }
            List<String> seletctedInterest = state.user.interests.toList();
            if (seletctedInterest.contains(interest)) {
              seletctedInterest.remove(interest);
            } else {
              seletctedInterest.add(interest);
            }
            context.read<ProfileBloc>().add(UpdateUserProfile(
                user: state.user.copyWith(interests: seletctedInterest)));
          };
        });
  }

  Widget _getPicture(int index) {
    List<String> images = [];
    for (String? s in state.user.imageUrls) {
      if (s != null) {
        images.add(s);
      }
    }
    return (images.length > index)
        ? CustomImageContainer(
            imageUrl: images[index],
          )
        : Container();
  }

  Widget _buildPictures(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Wrap(
        children: [
          _getPicture(0),
          _getPicture(1),
          _getPicture(2),
          _getPicture(3),
          _getPicture(4),
          _getPicture(5),
        ],
      ),
    );
  }
}

class EdittableRow extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget child;
  final ProfileLoaded state;
  final String editType;
  const EdittableRow(
      {Key? key,
      required this.child,
      this.onPressed,
      required this.state,
      required this.editType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: child,
        ),
        IconButton(
            icon: const Icon(Icons.edit),
            color: state.editingFields.contains(editType)
                ? Theme.of(context).accentColor
                : Colors.grey,
            onPressed: () {
              context
                  .read<ProfileBloc>()
                  .add(EditProfile(edittingType: editType));

              if (onPressed != null) {
                onPressed!();
              }
            }),
      ],
    );
  }
}
