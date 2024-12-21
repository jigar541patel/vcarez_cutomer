part of 'my_prescription_bloc.dart';

@immutable
abstract class MyPrescriptionState {}

class MyPrescriptionInitial extends MyPrescriptionState {}

// class MyPrescriptionListInitial extends MyPrescriptionInitial {}

class GetProfileState extends MyPrescriptionInitial {}

class DataLoading extends MyPrescriptionInitial {}

class ErrorDataLoading extends MyPrescriptionInitial {}

class DataLoaded extends MyPrescriptionInitial {
  final MyPrescriptionModel myPrescriptionModel;

  DataLoaded(this.myPrescriptionModel);
}
