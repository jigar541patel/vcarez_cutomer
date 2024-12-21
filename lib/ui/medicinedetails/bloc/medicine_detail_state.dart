part of 'medicine_detail_bloc.dart';

@immutable
abstract class MedicineDetailState {}

class MedicineDetailInitial extends MedicineDetailState {}

class OnMedicineLoaded extends MedicineDetailState {
  final MedicineDetailModel medicineDetailModel;

  OnMedicineLoaded(this.medicineDetailModel);
}

class OnUpdateQuantitySuccessState extends MedicineDetailState {
  final int intQuantity;

  OnUpdateQuantitySuccessState(this.intQuantity);
}

class ErrorMedicineLoading extends MedicineDetailState {}

class MedicineDataLoading extends MedicineDetailState {}

class AddToCartDetailSubmittingState extends MedicineDetailState {}

class AddToCartDetailSuccessState extends MedicineDetailState {}

class AddToCartFailureState extends MedicineDetailState {}
