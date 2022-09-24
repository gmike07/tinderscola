part of 'signup_cubit.dart';

class SignupStatePhone extends Equatable {
  final String phoneNumber;
  final String countryCode;
  final String countryName;
  final String verificationCode;
  final FormzStatus status;
  final bool enterPhone;
  final String otp;
  final auth.User? user;

  const SignupStatePhone({
    this.phoneNumber = '',
    this.countryCode = '972',
    this.countryName = 'IL',
    this.status = FormzStatus.pure,
    this.verificationCode = '',
    this.otp = '',
    this.enterPhone = true,
    this.user,
  });

  factory SignupStatePhone.initial() {
    return const SignupStatePhone(
      verificationCode: '',
      phoneNumber: '',
      countryCode: '972',
      countryName: 'IL',
      otp: '',
      status: FormzStatus.pure,
      enterPhone: true,
      user: null,
    );
  }

  @override
  List<Object?> get props => [
        countryName,
        phoneNumber,
        countryCode,
        status,
        verificationCode,
        user,
        enterPhone,
        otp,
      ];

  SignupStatePhone copyWith({
    String? phoneNumber,
    String? countryCode,
    String? countryName,
    String? verificationCode,
    FormzStatus? status,
    bool? enterPhone,
    String? otp,
    auth.User? user,
  }) {
    return SignupStatePhone(
        phoneNumber: phoneNumber ?? this.phoneNumber,
        countryCode: countryCode ?? this.countryCode,
        countryName: countryName ?? this.countryName,
        status: status ?? this.status,
        user: user ?? this.user,
        verificationCode: verificationCode ?? this.verificationCode,
        enterPhone: enterPhone ?? this.enterPhone,
        otp: otp ?? this.otp);
  }
}
