import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../dashboard/pages/home/model/trending_medicine_model.dart';

part 'trending_medicine_list_event.dart';
part 'trending_medicine_list_state.dart';

class TrendingMedicineListBloc extends Bloc<TrendingMedicineListEvent, TrendingMedicineListState> {
  TrendingMedicineListBloc() : super(TrendingMedicineListInitial()) {
    on<GetMedicineList>((event, emit) {
      // TODO: implement event handler
      emit(OnMedicineListLoaded(event.strTitle, event.medicineListModel));

    });
  }
}
