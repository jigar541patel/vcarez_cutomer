part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordState {}

class ForgotPasswordInitial extends ForgotPasswordState {}

class ForgotPasswordInvalidState extends ForgotPasswordState {}

class ForgotPasswordValidState extends ForgotPasswordState {}

class AddingDataInProgressState extends ForgotPasswordState {}

class AddingDataValidCompletedState extends ForgotPasswordState {}
class OTPSendSuccessState extends ForgotPasswordState {}

class AddingDataInValidCompletedState extends ForgotPasswordState {}
class OTPVerifiedValidCompletedState extends ForgotPasswordState {}

class ForgotPasswordErrorState extends ForgotPasswordState {
  final String errorMessage;

  ForgotPasswordErrorState(this.errorMessage);
}

// class ForgotPasswordLoadingState extends ForgotPasswordState {
//   final String strUserName;
//   final String strPassword;
//
//   ForgotPasswordLoadingState(this.strUserName, this.strPassword);
// }
