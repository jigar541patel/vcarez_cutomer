part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileState {
  const EditProfileState();

  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class GetProfileState extends EditProfileState {}

class DataLoading extends EditProfileState {}

class ErrorDataLoading extends EditProfileState {}

class AddingDataValidCompletedState extends EditProfileState {}

class AddingDataInProgressState extends EditProfileState {}

class AddingDataInValidCompletedState extends EditProfileState {}

class DataLoaded extends EditProfileState {
  final ProfileModel profileModel;

  DataLoaded(this.profileModel);
}
