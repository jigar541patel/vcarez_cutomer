part of 'login_bloc.dart';

@immutable
abstract class LoginEvent {}

class LoginTextChangedEvent extends LoginEvent {
  final String strEmail;
  final String strPassword;

  LoginTextChangedEvent(this.strEmail, this.strPassword);
}

class LoginSubmittedEvent extends LoginEvent {
  final String strEmail;
  final String strPassword;

  LoginSubmittedEvent(this.strEmail, this.strPassword);
}
