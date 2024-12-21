import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/repo/common_repo.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/trending_medicine_model.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

part 'trending_medicine_event.dart';

part 'trending_medicine_state.dart';

class TrendingMedicineBloc
    extends Bloc<TrendingMedicineEvent, TrendingMedicineState> {
  TrendingMedicineBloc() : super(TrendingMedicineInitial()) {
    // on<PopularMedicineEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<GetTrendingMedicineList>((event, emit) async {
      emit(TrendingLoading());
      var storage = const FlutterSecureStorage();
      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      TrendingMedicineModel responseData =
          await ApiController().getTrendingMedicineList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        emit(OnTrendingLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(ErrorTrendingLoading());
      }
    });
  }
}
