part of 'category_medicine_list_bloc.dart';

@immutable
abstract class CategoryMedicineListState {}

class CategoryMedicineListInitial extends CategoryMedicineListState {}
class OnCategoryProductLoaded extends CategoryMedicineListState {
  final CategoryProductListModel categoryProductListModel;

  OnCategoryProductLoaded(this.categoryProductListModel);
}
class ErrorCategoryProductLoading extends CategoryMedicineListState {}
class CategoryProductLoading extends CategoryMedicineListState {}
