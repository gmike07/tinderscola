// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
// ignore: depend_on_referenced_packages
import 'package:formz/formz.dart';

import '/repositories/repositories.dart';

part 'signup_state.dart';

class SignupCubitPhone extends Cubit<SignupStatePhone> {
  final AuthRepository _authRepository;

  SignupCubitPhone({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(SignupStatePhone.initial());

  void phoneNumberChanged(String value) {
    print(state);

    emit(state.copyWith(
        phoneNumber: value,
        status: value.length == '528478503'.length
            ? FormzStatus.valid
            : FormzStatus.invalid));
  }

  void countryCodeChanged(String code, String name) {
    print(state);
    emit(state.copyWith(countryCode: code, countryName: name));
  }

  String getCountryName() {
    return state.countryName;
  }

  Future<void> sendSMS() async {
    if (state.status == FormzStatus.invalid) return;
    try {
      var user = await _authRepository.verifyPhone(
        phoneNumber: '+${state.countryCode}${state.phoneNumber}',
      );
    } catch (_) {
      emit(state.copyWith(status: FormzStatus.submissionFailure));
    }
  }

  void storeVerificationCode(String verificationCode) {
    emit(state.copyWith(verificationCode: verificationCode));
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
