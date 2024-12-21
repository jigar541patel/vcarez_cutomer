part of 'trending_medicine_list_bloc.dart';

@immutable
abstract class TrendingMedicineListState {}

class TrendingMedicineListInitial extends TrendingMedicineListState {}
class OnMedicineListLoaded extends TrendingMedicineListState {
  final String strTitle;
  final TrendingMedicineModel popularMedicineModel;

  OnMedicineListLoaded(this.strTitle,this.popularMedicineModel);
}
class ErrorPopularLoading extends TrendingMedicineListState {}
