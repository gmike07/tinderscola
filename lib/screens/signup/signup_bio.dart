import 'package:flutter/material.dart';
//import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '/blocs/blocs.dart';
//import 'package:tiki/authentications_bloc/cubits/signup_cubit.dart';
import '/widgets/widgets.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '/models/models.dart';
import '/screens/screens.dart';

class Bio extends StatelessWidget {
  final SignUpLoaded state;

  const Bio({
    Key? key,
    required this.state,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    User user = state.user;
    TextEditingController controller = TextEditingController();
    return SignUpScreenLayout(
      currentStep: 5,
      state: state,
      onPressed: () {
        context.read<SignUpBloc>().add(ContinueSignUp(user: state.user));
        if (state.user.imageUrls.length < 2) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('please add at least 2 images')),
          );
        } else if (state.user.programName == '' ||
            state.user.programPlace == '') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('please choose a program place and name')),
          );
        } else if (state.user.name.length > 30) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('please choose a shorter name')),
          );
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
                    const CustomTextHeader(text: 'Add custom Interests here'),
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
                            context.read<SignUpBloc>().add(UpdateUser(
                                user: user.copyWith(currentInterest: value)));
                          },
                        )),
                        IconButton(
                            onPressed: () {
                              List<String> optionalInterests =
                                  user.optionalInterests!.toList();
                              optionalInterests.add(user.currentInterest!);
                              context.read<SignUpBloc>().add(UpdateUser(
                                  user: user.copyWith(
                                      optionalInterests: optionalInterests)));
                              controller.clear();
                            },
                            icon: const Icon(Icons.send))
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
