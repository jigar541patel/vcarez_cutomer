part of 'add_prescription_bloc.dart';

@immutable
abstract class AddPrescriptionEvent {}

class DataLoadingEvent extends AddPrescriptionEvent {}

class DataLoadedEvent extends AddPrescriptionEvent {}

class UploadPrescriptionEvent extends AddPrescriptionEvent {
  final String deliveryType;
  final String deliveryAddress;
  final bool isUploadPrescription;
  final String wholeItemPrescription;
  final String specificItemDetails;
  final List<Map<String, String>> listOfMedicineColumns;
  final int alternativeType;
  final double? latitude;
  final double? longitude;

  // final String strPassword;
  final File? prescriptionImage;

  UploadPrescriptionEvent(
      this.isUploadPrescription,
      this.listOfMedicineColumns,
      this.deliveryType,
      this.alternativeType,
      this.deliveryAddress,
      this.wholeItemPrescription,
      this.specificItemDetails,
      this.prescriptionImage,
      this.latitude,
      this.longitude);
}

class MedicineDataAddDeleteEvent extends AddPrescriptionEvent {
  final List<Map<String, String>> listOfMedicineColumns;

  MedicineDataAddDeleteEvent(this.listOfMedicineColumns);
}

class GetAddressListEvent extends AddPrescriptionEvent {}

class OpenDialogAddressEvent extends AddPrescriptionEvent {
//  final List<Map<String, String>> listOfMedicineColumns;
//   OpenDialogAddressEvent();
}

// class MedicineDataDeletedEvent extends AddPrescriptionEvent {
//   final List<Map<String, String>> listOfMedicineColumns;
//
//   MedicineDataDeletedEvent(this.listOfMedicineColumns);
// }
