import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/repo/common_repo.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/popular_medicine_model.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

part 'popular_medicine_event.dart';

part 'popular_medicine_state.dart';

class PopularMedicineBloc
    extends Bloc<PopularMedicineEvent, PopularMedicineState> {
  PopularMedicineBloc() : super(PopularMedicineInitial()) {
    // on<PopularMedicineEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<GetPopularMedicineList>((event, emit) async {
      emit(PopularLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      PopularMedicineModel responseData =
          await ApiController().getPopularMedicineList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Popular Success emited ");
        emit(OnPopularLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Error Popular emited ");

        emit(ErrorPopularLoading());
      }
    });
  }
}
