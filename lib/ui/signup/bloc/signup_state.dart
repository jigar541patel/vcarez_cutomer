part of 'signup_bloc.dart';

@immutable
abstract class SignupState {}

class SignupInitial extends SignupState {}

class SignupInvalidState extends SignupState {}

class SignupValidState extends SignupState {}
// class AddingDataInProgressState extends SignupState {}
// class AddingDataCompletedState extends SignupState {}
class AddingDataInProgressState extends SignupState {}

class AddingDataValidCompletedState extends SignupState {}

class AddingDataInValidCompletedState extends SignupState {}

class SignupErrorState extends SignupState {
  final String errorMessage;

  SignupErrorState(this.errorMessage);
}

// class LoginLoadingState extends SignupState {
//   final String strUserName;
//   final String strPassword;
//
//   LoginLoadingState(this.strUserName, this.strPassword);
// }
