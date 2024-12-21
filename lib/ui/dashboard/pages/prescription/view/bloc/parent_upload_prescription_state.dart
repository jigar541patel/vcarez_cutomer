part of 'parent_upload_prescription_bloc.dart';

@immutable
abstract class ParentUploadPrescriptionState {}

class ParentUploadPrescriptionInitial extends ParentUploadPrescriptionState {}
class OnLocationLoadedState extends ParentUploadPrescriptionState {
  final String? strLocation;

  OnLocationLoadedState(this.strLocation);
}
