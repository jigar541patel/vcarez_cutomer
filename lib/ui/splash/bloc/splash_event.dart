part of 'splash_bloc.dart';

@immutable
abstract class SplashEvent {
  const SplashEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends SplashEvent {}

class DataLoadingEvent extends SplashEvent {}

class DataLoadedEvent extends SplashEvent {}
