part of 'category_medicine_list_bloc.dart';

@immutable
abstract class CategoryMedicineListEvent {}

class GetCategoryMedicineList extends CategoryMedicineListEvent {
  String strCategoryID;
  String strTitle;

  GetCategoryMedicineList(this.strTitle,this.strCategoryID);
}
