part of 'home_bloc.dart';

@immutable
abstract class HomeEvent {}

class GetCurrentLocationName extends HomeEvent {}
class GetHomeCartListEvent extends HomeEvent {}

class AddToCartMedicineEvent extends HomeEvent {
  final String? strMedicineID;
  final String? strMedicineUrl;
  final String? strMedicineName;
  final String? strMedicineType;
  final String? strMedicineMrp;
  final String? strMedicinePackaging;
  final String? strMedicinePackInfo;

  AddToCartMedicineEvent(
      this.strMedicineID,
      this.strMedicineName,
      this.strMedicineUrl,
      this.strMedicineType,
      this.strMedicineMrp,
      this.strMedicinePackaging,
      this.strMedicinePackInfo);
}
