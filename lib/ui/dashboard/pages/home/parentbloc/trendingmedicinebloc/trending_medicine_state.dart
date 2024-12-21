part of 'trending_medicine_bloc.dart';

@immutable
abstract class TrendingMedicineState {}

class TrendingMedicineInitial extends TrendingMedicineState {}
class OnTrendingLoaded extends TrendingMedicineState {
  final TrendingMedicineModel trendingMedicineModel;

  OnTrendingLoaded(this.trendingMedicineModel);
}
class ErrorTrendingLoading extends TrendingMedicineState {}
class TrendingLoading extends TrendingMedicineState {}

