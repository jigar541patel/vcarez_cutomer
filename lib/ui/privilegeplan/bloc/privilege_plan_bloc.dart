import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../../services/api/api_hitter.dart';
import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../shopquotationdetail/model/verify_cf_model.dart';
import '../../storage/shared_pref_const.dart';
import '../model/buy_plan_success_model.dart';
import '../model/privilege_plan_model.dart';

part 'privilege_plan_event.dart';

part 'privilege_plan_state.dart';

class PrivilegePlanBloc extends Bloc<PrivilegePlanEvent, PrivilegePlanState> {
  PrivilegePlanBloc() : super(PrivilegePlanInitial()) {
    on<GetPrivilegePlanEvent>((event, emit) async {
      emit(PrivilegePlanLoading());
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      PrivilegePlanModel responseData =
          await ApiController().getPrivilegePlanList(token!);

      if (responseData.success!) {
        emit(PrivilegePlanDataLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        emit(ErrorPrivilegePlanLoading());
      }
    });

    on<BuySubscriptionSubmittedEvent>((event, emit) async {
      emit.call(BuySubscriptionLoadingState());

      var requestBody = {
        "plan_id": event.planID,
        "purchase_token": event.planPurchaseToken,
      };
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      BuyPlanSuccessModel responseData =
          await ApiController().buySubscription(token!, requestBody);
      debugPrint("vcarez customer update we have is ${responseData.message}");

      if (responseData.success!) {
        CommonUtils.utils.showToast(responseData.message!);
        emit.call(BuySubscriptionSuccessState(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message!);
        emit.call(BuySubscriptionErrorState());
      }
    });

    on<VerifyPlanOrderIDEvent>((event, emit) async {
      emit.call(VerifyPlanOrderSubmittingState());

      var loginFormData = FormData.fromMap({
        "order_id": event.strOrderID,
      });

      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      VerifyCFModel responseData =
          await ApiController().verifyCFOrder(token!, loginFormData);
      // showLoader.value = false;
      debugPrint("vcarez VerifyOrderIDEvent have is ${responseData.message}");
      debugPrint(
          "vcarez VerifyOrderIDEvent responseData.response!.data.toString() is ${responseData.toString()}");

      if (responseData.success!) {
        CommonUtils.utils.showToast(responseData.message!);
        emit.call(VerifyPlanOrderSuccessState(responseData));
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
        emit.call(VerifyPlanOrderFailureState());

        // showLoader = false;
      }
    });
  }
}
