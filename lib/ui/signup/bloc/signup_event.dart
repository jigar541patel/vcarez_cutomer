part of 'signup_bloc.dart';

@immutable
abstract class SignupEvent {}

class SignupSubmittedEvent extends SignupEvent {
  final String strFullName;
  final String strPhoneNumber;
  final String strEmail;
  final String strPassword;
  final String strLocation;

  SignupSubmittedEvent(this.strFullName, this.strPhoneNumber, this.strEmail,
      this.strPassword, this.strLocation);
}
