part of 'splash_bloc.dart';

@immutable
abstract class SplashState {}

class SplashInitial extends SplashState {}
class DataLoading extends SplashState {}

class ErrorDataLoading extends SplashState {}
class TokenExpired extends SplashState {}

class DataLoaded extends SplashState {
  final ProfileModel profileModel;

  DataLoaded(this.profileModel);
}
