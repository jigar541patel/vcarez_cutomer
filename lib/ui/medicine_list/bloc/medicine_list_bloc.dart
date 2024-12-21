import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/popular_medicine_model.dart';

part 'medicine_list_event.dart';

part 'medicine_list_state.dart';

class MedicineListBloc extends Bloc<MedicineListEvent, MedicineListState> {
  MedicineListBloc() : super(MedicineListInitial()) {
    on<GetMedicineList>((event, emit) {
      // TODO: implement event handler
      emit(OnMedicineListLoaded(event.strTitle, event.medicineListModel));

    });
  }
}
