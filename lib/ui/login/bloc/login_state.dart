part of 'login_bloc.dart';

@immutable
abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginInvalidState extends LoginState {}

class LoginValidState extends LoginState {}

class AddingDataInProgressState extends LoginState {}

class AddingDataValidCompletedState extends LoginState {}

class AddingDataInValidCompletedState extends LoginState {}

class LoginErrorState extends LoginState {
  final String errorMessage;

  LoginErrorState(this.errorMessage);
}

// class LoginLoadingState extends LoginState {
//   final String strUserName;
//   final String strPassword;
//
//   LoginLoadingState(this.strUserName, this.strPassword);
// }
