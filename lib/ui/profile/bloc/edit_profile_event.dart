part of 'edit_profile_bloc.dart';

@immutable
abstract class EditProfileEvent {
  const EditProfileEvent();

  @override
  List<Object> get props => [];
}

class GetProfileEvent extends EditProfileEvent {}

class DataLoadingEvent extends EditProfileEvent {}

class DataLoadedEvent extends EditProfileEvent {}

class UpdateProfileSubmittedEvent extends EditProfileEvent {
  final String strFullName;
  final String strPhoneNumber;
  final String strEmail;
  // final String strPassword;
  final String strLocation;

  const UpdateProfileSubmittedEvent(this.strFullName, this.strPhoneNumber,
      this.strEmail, this.strLocation);
}

