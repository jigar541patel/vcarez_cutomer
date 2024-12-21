part of 'add_prescription_bloc.dart';

@immutable
abstract class AddPrescriptionState {}

class AddPrescriptionInitial extends AddPrescriptionState {}

class AddingDataValidCompletedState extends AddPrescriptionState {}

class RouteMyPrescriptionCompletedState extends AddPrescriptionState {}

class AddingDataInProgressState extends AddPrescriptionState {}

class AddingDataInValidCompletedState extends AddPrescriptionState {}

class MedicineDataAdded extends AddPrescriptionState {
  final List<Map<String, String>> listOfMedicineColumns;

  MedicineDataAdded(this.listOfMedicineColumns);
}

class OnAddressLoading extends AddPrescriptionState {}

class OnAddressLoaded extends AddPrescriptionState {
  //final
  AddressListModel addressListModel;

  OnAddressLoaded(this.addressListModel);
}

class ErrorAddressLoading extends AddPrescriptionState {}

class MedicineDataDeleted extends AddPrescriptionState {
  final List<Map<String, String>> listOfMedicineColumns;

  MedicineDataDeleted(this.listOfMedicineColumns);
}
