import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/currentorder/model/current_order_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/currentorder/model/current_order_model.dart';

import '../../../../../../../services/repo/common_repo.dart';
import '../../../../../../../utils/CommonUtils.dart';
import '../../../../../../storage/shared_pref_const.dart';
import '../model/current_order_model.dart';

part 'current_orders_event.dart';

part 'current_orders_state.dart';

class CurrentOrdersBloc extends Bloc<CurrentOrdersEvent, CurrentOrdersState> {
  CurrentOrdersBloc() : super(CurrentOrdersInitial()) {
    on<GetCurrentOrderList>((event, emit) async {
      emit(OnCurrentOrderLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      CurrentOrdersModel responseData =
          await ApiController().getCurrentOrderList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        emit(OnCurrentOrderLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(OnErrorCurrentOrder());
      }
    });
  }
}
