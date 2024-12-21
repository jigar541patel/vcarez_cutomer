part of 'medicine_detail_bloc.dart';

@immutable
abstract class MedicineDetailEvent {}

class GetMedicineDetailEvent extends MedicineDetailEvent {
  String strID;
  String strType;

  GetMedicineDetailEvent(this.strID, this.strType);
}

class UpdateMedicineQuantityEvent extends MedicineDetailEvent {
  int intQuantity;

  UpdateMedicineQuantityEvent(this.intQuantity);
}

class AddToCartMedicineEvent extends MedicineDetailEvent {
  final String? strMedicineID;
  final String? strMedicineUrl;
  final String? strMedicineName;
  final String? strMedicineType;
  final String? strMedicineMrp;
  final String? strMedicinePackaging;
  final String? strMedicinePackInfo;
  final String? strQuantity;

  AddToCartMedicineEvent(
      this.strMedicineID,
      this.strMedicineName,
      this.strMedicineUrl,
      this.strMedicineType,
      this.strMedicineMrp,
      this.strMedicinePackaging,
      this.strMedicinePackInfo,this.strQuantity);
}
