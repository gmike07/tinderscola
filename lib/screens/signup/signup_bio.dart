import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinderscola_final/config/constants.dart';
import '/blocs/blocs.dart';
import '/widgets/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '/models/models.dart';
import '/screens/screens.dart';

// ignore: must_be_immutable
class Bio extends StatelessWidget {
  final SignUpLoaded state;
  String currentInterest;

  Bio({Key? key, required this.state, this.currentInterest = ''})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = state.user;
    TextEditingController controller = TextEditingController();
    return SignUpScreenLayout(
      currentStep: 5,
      state: state,
      onPressed: () {
        context.read<SignUpBloc>().add(ContinueSignUp(
            user:
                state.user.copyWith(optionalInterests: state.user.interests)));
        int counter = 0;
        for (String? s in state.user.imageUrls) {
          if (s != null) {
            counter++;
          }
        }
        if (counter < 2) {
          AppConstants.showToast('please add at least 2 images');
        } else if (state.user.programName == '' ||
            state.user.programPlace == '') {
          AppConstants.showToast('please choose a program place and name');
        } else if (state.user.name.length > 30) {
          AppConstants.showToast('please choose a shorter name');
        } else if (state.user.name.isEmpty) {
          AppConstants.showToast('please choose a longer name');
        } else if (state.user.gender.isEmpty) {
          AppConstants.showToast('please select at least one gender');
        } else if (state.user.age < 10) {
          AppConstants.showToast('please enter a bigger age');
        } else {
          Navigator.of(context).popAndPushNamed(MainScreen.routeName);
        }
      },
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text('STEP 5 OF 5',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                        fontSize: 15,
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 7),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomTextHeader(text: 'Describe Yourself'),
                    const SizedBox(height: 10),
                    CustomTextField(
                      icon: Icons.person_add,
                      hint: 'Software Engineer at Google',
                      onChanged: (value) {
                        context
                            .read<SignUpBloc>()
                            .add(UpdateUser(user: user.copyWith(bio: value)));
                      },
                      // controller: controller,
                    ),
                    const SizedBox(height: 40),
                    const CustomTextHeader(text: 'Add custom interests here'),
                    const SizedBox(height: 10),
                    Row(
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
                              if (currentInterest.isNotEmpty) {
                                List<String> optionalInterests =
                                    state.user.optionalInterests!.toList();
                                List<String> interests =
                                    state.user.interests.toList();
                                optionalInterests.add(currentInterest);
                                interests.add(currentInterest);
                                controller.clear();
                                context.read<SignUpBloc>().add(UpdateUser(
                                    user: state.user.copyWith(
                                        interests: interests,
                                        optionalInterests: optionalInterests)));
                              }
                            },
                            icon: const Icon(Icons.send)),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const CustomTextHeader(
                            text: 'Select 3 or more interests'),
                        Text(
                          '${user.interests.length}/${user.optionalInterests!.length}',
                        )
                      ],
                    ),
                    Choices(
                      options: user.optionalInterests!,
                      isSelected: (interest) {
                        return user.interests.contains(interest);
                      },
                      onPressed: (interest) {
                        return () {
                          List<String> interests = user.interests.toList();
                          if (interests.contains(interest)) {
                            interests.remove(interest);
                          } else {
                            interests.add(interest);
                          }
                          context.read<SignUpBloc>().add(UpdateUser(
                              user: user.copyWith(interests: interests)));
                        };
                      },
                    )
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
