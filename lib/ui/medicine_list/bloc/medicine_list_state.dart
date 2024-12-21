part of 'medicine_list_bloc.dart';

@immutable
abstract class MedicineListState {}

class MedicineListInitial extends MedicineListState {}
class OnMedicineListLoaded extends MedicineListState {
  final String strTitle;
  final PopularMedicineModel popularMedicineModel;

  OnMedicineListLoaded(this.strTitle,this.popularMedicineModel);
}
class ErrorPopularLoading extends MedicineListState {}
