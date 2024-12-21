import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/payment/model/create_order_model.dart';

import '../../../services/api/api_hitter.dart';
import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../storage/shared_pref_const.dart';

part 'payment_event.dart';

part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentInitial()) {
    on<CreateOrderSubmittedEvent>((event, emit) async {
      // TODO: implement event handler

      emit.call(CreateOrderInProgressState());

      var requestBody = {
        "order_amount": event.strAmount,
      };
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      CreateOrderModel responseData =
          await ApiController().createOrderSession(token!, requestBody);
      // showLoader.value = false;
      debugPrint("vcarez customer update we have is ${responseData.message}");

      if (responseData.success!) {

        emit.call(CreateOrderCompletedState(responseData));
      } else {
        // CommonUtils.utils.showToast(
        //     // responseData.status as int+
        //     responseData.message as String);

        CommonUtils.utils.showToast(responseData.message!);

        emit.call(CreateOrderInValidCompletedState());

        // showLoader = false;
      }
    });
  }
}
