part of 'trending_medicine_list_bloc.dart';

@immutable
abstract class TrendingMedicineListEvent {}
class GetMedicineList extends TrendingMedicineListEvent {
  String strTitle;
  TrendingMedicineModel medicineListModel;
  GetMedicineList(this.strTitle,this.medicineListModel);

}


