// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';
import 'package:flutter/material.dart';
import '/repositories/repositories.dart';
import '/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import '/models/models.dart';
part 'signup_state.dart';

class SignupCubitPhone extends Cubit<SignupStatePhone> {
  final AuthRepository _authRepository;

  SignupCubitPhone({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupStatePhone.initial());

  void phoneNumberChanged(String value) {
    emit(state.copyWith(
        phoneNumber: value,
        status: value.length == '528478503'.length
            ? FormzStatus.valid
            : FormzStatus.invalid));
  }

  void countryCodeChanged(String code, String name) {
    emit(state.copyWith(countryCode: code, countryName: name));
  }

  String getCountryName() {
    return state.countryName;
  }

  String getPhoneNumber() {
    return '+${state.countryCode}${state.phoneNumber}';
  }

  String getPhoneNumberString() {
    return '+${state.countryCode}-${state.phoneNumber}';
  }

  void setOTP(String val) {
    emit(state.copyWith(otp: val));
  }

  Future<void> sendSMS(BuildContext context) async {
    print('sending sms $state');
    //TODO: send SMS
    emit(state.copyWith(enterPhone: false));

    await _authRepository.verifyPhone(
        phoneNumber: getPhoneNumber(),
        codeSent: storeVerificationCode,
        errorHandler: errorHandler(context),
        verifiedSuccess: skipSMS(context));
  }

  void Function(String) errorHandler(BuildContext context) {
    return (String s) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(s)));
    };
  }

  void storeVerificationCode(String verificationCode, int? resendToken) {
    emit(state.copyWith(verificationCode: verificationCode));
  }

  Future<void> Function(PhoneAuthCredential credential) skipSMS(
      BuildContext context) {
    return (credential) async {
      try {
        var credential_ =
            await auth.FirebaseAuth.instance.signInWithCredential(credential);
        emit(state.copyWith(
            status: FormzStatus.submissionSuccess, user: credential_.user));
        // ignore: use_build_context_synchronously
        if (BlocProvider.of<SignupCubitPhone>(context).state.status ==
            FormzStatus.submissionSuccess) {
          // ignore: use_build_context_synchronously
          context.read<SignUpBloc>().add(
                ContinueSignUp(
                  isSignup: true,
                  user: User.empty.copyWith(
                    // ignore: use_build_context_synchronously
                    id: credential_.user!.uid,
                  ),
                ),
              );
        }
      } catch (_) {
        emit(state.copyWith(status: FormzStatus.submissionFailure));
      }
    };
  }

  Future<void> validateSMS(BuildContext context) async {
    try {
      var user = await _authRepository.verifyCode(
          verificationId: state.verificationCode,
          smsCode: state.otp,
          errorHandler: errorHandler(context));
      emit(state.copyWith(status: FormzStatus.submissionSuccess, user: user));
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }
}
  //TODO: implement sign up with phone
  // Future<void> signUpWithCredentials() async {
  //   if (!state.status.isValidated) return;
  //   emit(state.copyWith(status: FormzStatus.submissionInProgress));
  //   try {
  //     var user = await _authRepository.signUp(
  //       email: state.email.value,
  //       password: state.password.value,
  //     );
  //     emit(state.copyWith(status: FormzStatus.submissionSuccess, user: user));
  //   } catch (_) {
  //     emit(state.copyWith(status: FormzStatus.submissionFailure));
  //   }
  // }
