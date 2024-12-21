import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/api/api_hitter.dart';

import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/strings.dart';

part 'forgot_password_event.dart';

part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc() : super(ForgotPasswordInitial()) {
    // on<ForgotPasswordEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<DataSubmittedEvent>((event, emit) async {
      debugPrint("vcarez customer login submit bloc called ");

      emit.call(AddingDataInProgressState());

      var requestBody = {
        "email": event.strEmail,
      };

      ApiResponse responseData =
          await ApiController().forgotPassword(requestBody);
      // showLoader.value = false;
      debugPrint(
          "vcarez customer we have is " + responseData.success.toString());  debugPrint(
          "vcarez customer we message have is " + responseData.message.toString());

      if (responseData.success) {
        if (responseData.success) {
          // LoginModel loginModel = responseData;
          CommonUtils.utils.showToast(responseData.message);
          emit.call(AddingDataValidCompletedState());
          emit.call(OTPSendSuccessState());
        }else
          {
            emit.call(AddingDataInValidCompletedState());
            CommonUtils.utils.showToast(
              // responseData.status as int+
                responseData.message as String);
          }
      } else {
        emit.call(AddingDataInValidCompletedState());
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
      }
    });
    on<OtpSubmittedEvent>((event, emit) async {
      debugPrint("vcarez customer login submit bloc called ");

      emit.call(AddingDataInProgressState());

      var requestBody = {
        "email": event.strEmail,
        "new_password": event.strNewPassword,
        "otp": event.strOtp,
      };
      // {
      //   "email":"rabiul.deuglo@gmail.com",
      // "new_password":"123456",
      // "otp":"1234"
      // }
      ApiResponse responseData =
          await ApiController().verifyOtpPassword(requestBody);
      // showLoader.value = false;
      debugPrint("vcarez customer we have is $responseData");

      if (responseData.success) {
        // LoginModel loginModel = responseData;
        CommonUtils.utils.showToast(responseData.message);
        emit.call(OTPVerifiedValidCompletedState());
      } else {
        emit.call(AddingDataInValidCompletedState());
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
      }
    });
  }
}
