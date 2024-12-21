part of 'forgot_password_bloc.dart';

@immutable
abstract class ForgotPasswordEvent {}

class DataTextChangedEvent extends ForgotPasswordEvent {
  final String strEmail;

  DataTextChangedEvent(this.strEmail);
}

class DataSubmittedEvent extends ForgotPasswordEvent {
  final String strEmail;

  DataSubmittedEvent(this.strEmail);
}

class OtpSubmittedEvent extends ForgotPasswordEvent {
  final String strEmail;
  final String strNewPassword;
  final String strOtp;

  OtpSubmittedEvent( this.strEmail, this.strNewPassword,this.strOtp);
}
