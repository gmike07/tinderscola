import 'package:flutter/material.dart';
import '/blocs/signup/signup_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:google_fonts/google_fonts.dart';
//import 'package:tiki/authentications_bloc/cubits/signup_cubit.dart';
import '/screens/signup/signup.dart';
import '/repositories/repositories.dart';
import '/blocs/blocs.dart';
import '/cubits/cubits.dart';
import '/widgets/widgets.dart';
import '/models/models.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class SignUpScreen extends StatelessWidget {
  static const String routeName = '/onboarding';

  const SignUpScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => MultiBlocProvider(providers: [
              BlocProvider<SignUpBloc>(
                create: (context) => SignUpBloc(
                  databaseRepository: context.read<DatabaseRepository>(),
                  storageRepository: context.read<StorageRepository>(),
                  // locationRepository: context.read<LocationRepository>(),
                ),
              ),
              BlocProvider<SignupCubit>(
                  create: (context) => SignupCubit(
                        authRepository: context.read<AuthRepository>(),
                      ))
            ], child: const SignUpScreen()));
  }

  static const List<Tab> tabs = <Tab>[
    Tab(text: 'Start'),
    Tab(text: 'Email'),
    Tab(text: 'Demographics'),
    Tab(text: 'Pictures'),
    Tab(text: 'Biography'),
    Tab(text: 'Location')
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Builder(builder: (BuildContext context) {
        final TabController tabController = DefaultTabController.of(context)!;
        context
            .read<SignUpBloc>()
            .add(StartSignUp(user: User.empty, tabController: tabController));
        return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: const CustomAppBar(),
            body:
                BlocBuilder<SignUpBloc, SignUpState>(builder: (context, state) {
              if (state is SignUpLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is SignUpLoaded) {
                return TabBarView(
                    //physics: NeverScrollableScrollPhysics(),
                    children: [
                      Start(state: state),
                      Email(state: state),
                      BasicData(state: state),
                      Specifics(state: state),
                      Pictures(state: state),
                      Bio(state: state),
                    ]);
              }
              return const Text('Something went wrong.');
            }));
      }),
    );
  }
}

class SignUpScreenLayout extends StatelessWidget {
  final List<Widget> children;
  final int currentStep;
  final VoidCallback? onPressed;
  final SignUpLoaded state;

  const SignUpScreenLayout({
    Key? key,
    required this.children,
    required this.currentStep,
    required this.state,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: constraints.maxWidth,
              minHeight: constraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...children,
                  const Spacer(),
                  Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        height: 75,
                        width: 0.9 * constraints.maxWidth,
                        child: Column(
                          children: [
                            StepProgressIndicator(
                              totalSteps: 5,
                              currentStep: currentStep,
                              selectedColor: Theme.of(context).primaryColor,
                              unselectedColor:
                                  Theme.of(context).backgroundColor,
                            ),
                            const SizedBox(height: 10),
                            CustomButton(
                              text: currentStep < 5 ? 'NEXT STEP' : 'DONE',
                              onPressed: onPressed,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
