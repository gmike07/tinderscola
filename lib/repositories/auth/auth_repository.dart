import 'package:firebase_auth/firebase_auth.dart' as auth;
// ignore: depend_on_referenced_packages
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:tinderscola_final/config/constants.dart';
import 'base_auth_repository.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Future<auth.User?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      return user;
    } catch (e) {
      AppConstants.showToast(e.toString());
    }
    return null;
  }

  Future<void> logInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      // https://pub.dev/documentation/firebase_auth/latest/firebase_auth/FirebaseAuth/signInWithEmailAndPassword.html
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on auth.FirebaseAuthException catch (error) {
      throw Exception(error.message);
    } catch (_) {}
  }

  @override
  Stream<auth.User?> get user => _firebaseAuth.userChanges();

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<void> verifyPhone(
      {required String phoneNumber,
      required Function(String, int?) codeSent,
      required Function(String) errorHandler,
      required Future<void> Function(PhoneAuthCredential) verifiedSuccess,
      required int? resendToken}) async {
    await _firebaseAuth.verifyPhoneNumber(
      forceResendingToken: resendToken,
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 120),
      verificationCompleted: verifiedSuccess,
      verificationFailed: (e) => errorHandler(e.code),
      codeSent: codeSent,
      codeAutoRetrievalTimeout: (String verificationId) {
        codeSent(verificationId, resendToken);
      },
    );
  }

  @override
  Future<auth.User?> verifyCode(
      {required String verificationId,
      required String smsCode,
      required Function(String) errorHandler}) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: smsCode);

      // Sign the user in (or link) with the credential
      var credential_ = await _firebaseAuth.signInWithCredential(credential);
      return credential_.user;
    } catch (e) {
      errorHandler(e.toString());
    }
    return null;
  }
}
