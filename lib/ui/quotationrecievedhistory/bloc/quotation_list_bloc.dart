import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/model/quotation_list_history_model.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/model/quotation_recieved_list_model.dart';

import '../../../services/api/api_hitter.dart';
import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../storage/shared_pref_const.dart';

part 'quotation_list_event.dart';

part 'quotation_list_state.dart';

class QuotationListBloc extends Bloc<QuotationListEvent, QuotationListState> {
  QuotationListBloc() : super(QuotationReceivedListInitial()) {
    on<GetQuotationDetailReceivedListList>((event, emit) async {
      emit(QuotationReceivedListLoadingState());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      QuotationReceivedListModel responseData = await ApiController()
          .getQuotationHistoryDetail(token!, event.strOrderID);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnQuotationReceivedListLoadedState emited ");
        emit(OnQuotationReceivedListLoadedState(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(ErrorQuotationReceivedListLoadingState());
      }
    });

    on<GetQuotationList>((event, emit) async {
      emit(QuotationListLoadingState());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      QuotationHistoryListModel responseData =
          await ApiController().getQuotationHistoryList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnQuotationListLoadedState emited ");
        emit(OnQuotationListLoadedState(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorQuotationListLoadingState emited ");
        emit(ErrorQuotationListLoadingState());
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
  }
}
