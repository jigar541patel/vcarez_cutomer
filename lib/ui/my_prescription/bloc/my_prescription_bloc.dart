import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/repo/common_repo.dart';
import 'package:vcarez_new/ui/my_prescription/model/MyPrescriptionModel.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

part 'my_prescription_event.dart';

part 'my_prescription_state.dart';

class MyPrescriptionBloc
    extends Bloc<MyPrescriptionEvent, MyPrescriptionState> {
  // MyPrescriptionBloc() : super(MyPrescriptionInitial()) {
  //   on<MyPrescriptionEvent>((event, emit) {
  //
  //
  //     // TODO: implement event handler
  //   });
  // }

  MyPrescriptionBloc() : super(MyPrescriptionInitial()) {
    on<MyPrescriptionEvent>((event, emit) async {
      emit(DataLoading());
      var storage = FlutterSecureStorage();

      // String strMedicineID = event.strID.toString();
      String? token = await storage.read(key: keyUserToken);
      // debugPrint("vcarez vendor strMedicineID is $strMedicineID");

      MyPrescriptionModel responseData =
          await ApiController().getPrescriptionList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        emit(DataLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        emit(ErrorDataLoading());
      }
    });
  }
}
