// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tinderscola_final/config/constants.dart';

import '/screens/screens.dart';
import '/widgets/widgets.dart';
import '/blocs/blocs.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import '/models/models.dart';
import 'package:image_picker/image_picker.dart';

class Pictures extends StatelessWidget {
  final SignUpLoaded state;

  const Pictures({
    Key? key,
    required this.state,
  }) : super(key: key);

  VoidCallback onPressed(BuildContext context, User user, int index) {
    return () async {
      ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image == null) {
        AppConstants.showToast("No image selected");
      } else {
        context
            .read<SignUpBloc>()
            .add(UpdateUserImages(user: user, image: image, index: index));
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    User user = state.user;
    return SignUpScreenLayout(
        currentStep: 4,
        state: state,
        onPressed: () {
          context.read<SignUpBloc>().add(ContinueSignUp(user: user));
        },
        children: [
          SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('STEP 4 OF 5',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.roboto(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 7),
                      ],
                    ),
                    const CustomTextHeader(
                        text: 'Add 2 or More Pictures Of Yourself'),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        CustomImageContainer(
                            imageUrl: user.imageUrls[0],
                            onPressed: onPressed(context, user, 0)),
                        CustomImageContainer(
                            imageUrl: user.imageUrls[1],
                            onPressed: onPressed(context, user, 1)),
                        CustomImageContainer(
                            imageUrl: user.imageUrls[2],
                            onPressed: onPressed(context, user, 2)),
                      ],
                    ),
                    Row(
                      children: [
                        CustomImageContainer(
                            imageUrl: user.imageUrls[3],
                            onPressed: onPressed(context, user, 3)),
                        CustomImageContainer(
                            imageUrl: user.imageUrls[4],
                            onPressed: onPressed(context, user, 4)),
                        CustomImageContainer(
                            imageUrl: user.imageUrls[5],
                            onPressed: onPressed(context, user, 5)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ))
        ]);
  }
}
