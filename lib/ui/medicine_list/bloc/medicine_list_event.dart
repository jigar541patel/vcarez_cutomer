part of 'medicine_list_bloc.dart';

@immutable
abstract class MedicineListEvent {}

class GetMedicineList extends MedicineListEvent {
  String strTitle;
  PopularMedicineModel medicineListModel;
  GetMedicineList(this.strTitle,this.medicineListModel);

}
