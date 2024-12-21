part of 'category_list_bloc.dart';

@immutable
abstract class CategoryListState {}

class CategoryListInitial extends CategoryListState {}
class OnCategoryLoaded extends CategoryListState {
  final CategoriesListModel categoriesListModel;

  OnCategoryLoaded(this.categoriesListModel);
}
class ErrorCategoryLoading extends CategoryListState {}

