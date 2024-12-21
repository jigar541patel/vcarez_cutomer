part of 'popular_medicine_bloc.dart';

@immutable
abstract class PopularMedicineState {}

class PopularMedicineInitial extends PopularMedicineState {}
class OnPopularLoaded extends PopularMedicineState {
  final PopularMedicineModel popularMedicineModel;

  OnPopularLoaded(this.popularMedicineModel);
}
class ErrorPopularLoading extends PopularMedicineState {}
class PopularLoading extends PopularMedicineState {}

