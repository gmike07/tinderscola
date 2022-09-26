import 'package:firebase_auth/firebase_auth.dart' as auth;
// ignore: depend_on_referenced_packages
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

abstract class BaseAuthRepository {
  Stream<auth.User?> get user;
  Future<auth.User?> signUp({
    required String email,
    required String password,
  });
  Future<void> verifyPhone(
      {required String phoneNumber,
      required Function(String, int?) codeSent,
      required Function(String) errorHandler,
      required Future<void> Function(PhoneAuthCredential) verifiedSuccess,
      required int? resendToken});
  Future<void> signOut();
  Future<auth.User?> verifyCode(
      {required String verificationId,
      required String smsCode,
      required Function(String) errorHandler});
}
