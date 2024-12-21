import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/shop_quotation_detail_model.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/verify_cf_model.dart';

import '../../../services/api/api_hitter.dart';
import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../storage/shared_pref_const.dart';
import '../model/order_accept_success_model.dart';

part 'shop_quotation_detail_event.dart';

part 'shop_quotation_detail_state.dart';

class ShopQuotationDetailBloc
    extends Bloc<ShopQuotationDetailEvent, ShopQuotationDetailState> {
  ShopQuotationDetailBloc() : super(ShopQuotationDetailInitial()) {
    on<GetQuotationDetail>((event, emit) async {
      emit(ShopQuotationDetailLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ShopQuotationDetailModel responseData = await ApiController()
          .getShopQuotationDetail(token!, event.strQuotedID);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnQuotationListLoadedState emited ");
        emit(ShopQuotationDetailLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorQuotationListLoadingState emited ");
        debugPrint("vcarez ErrorQuotationListLoadingState success " +
            responseData.success.toString());
        emit(ErrorShopQuotationDetailLoading());
      }
    });

    on<AcceptQuoteSubmitEvent>((event, emit) async {
      emit.call(AcceptQuoteSubmittingState());

      var requestBody = {
        "customer_quotation_id": event.strCustQuoteID,
        'quot_ids': event.listQuotationID,
      };
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ApiResponse responseData =
          await ApiController().acceptQuote(token!, requestBody);
      // showLoader.value = false;
      debugPrint("vcarez customer update we have is ${responseData.message}");

      if (responseData.success) {
        CommonUtils.utils.showToast(responseData.message);
        emit.call(AcceptQuoteSuccessState());
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
        emit.call(AcceptQuoteFailureState());

        // showLoader = false;
      }
    });

    on<VerifyOrderIDEvent>((event, emit) async {
      emit.call(VerifyOrderSubmittingState());

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
        emit.call(VerifyOrderSuccessState(responseData));
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
        emit.call(VerifyOrderFailureState());

        // showLoader = false;
      }
    });


    on<SaveQuoteSubmitEvent>((event, emit) async {
      emit.call(SaveOrderSubmittingState());
      // {
      //   "customer_quotation_id": 4,
      // "quot_ids":[1,2],
      // "cf_order_id": 12121,
      // "payment_method":"UPI",
      // "payment_status":0
      // }
      var loginFormData = //FormData.fromMap(
          {
        "customer_quotation_id": event.strCustQuoteID,
        "quot_ids": event.listQuotationID,
        "order_id": event.strCfOrderID,
        "payment_method": event.strPaymentMethod,
        "payment_status": event.strPaymentStatus,
      };

      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      OrderAcceptSuccessModel responseData =
          await ApiController().acceptSaveOrder(token!, loginFormData);
      // showLoader.value = false;
      debugPrint("vcarez OrderAcceptSuccessModel have is ${responseData.message}");
      debugPrint(
          "vcarez OrderAcceptSuccessModel responseData.response!.data.toString() is ${responseData.toString()}");

      if (responseData.success!) {
        CommonUtils.utils.showToast(responseData.message!);
        emit.call(SaveOrderSuccessState(responseData));
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
        emit.call(SaveOrderFailureState());

        // showLoader = false;
      }
    });
  }
}
