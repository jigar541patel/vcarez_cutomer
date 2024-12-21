import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/signup/model/signup_model.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';

import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/strings.dart';

part 'signup_event.dart';

part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  bool showLoader = false;

  SignupBloc() : super(SignupInitial()) {
    // on<SignupEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<SignupSubmittedEvent>((event, emit) async {
      emit.call(AddingDataInProgressState());
      // yield AddingDataInProgressState();
      showLoader = true;
      var loginFormData = FormData.fromMap({
        'name': event.strFullName,
        'email': event.strEmail,
        'phone': event.strPhoneNumber,
        'password': event.strPassword,
      });

      SignupModel responseData =
          await ApiController().userSignUp(loginFormData);
      // showLoader.value = false;
      debugPrint("vcarez customer register we have is $responseData");

      if (responseData.success!) {
        showLoader = false;

        CommonUtils.utils.showToast(successRegister);
        // emit.call(AddingDataValidCompletedState());
        var storage = FlutterSecureStorage();

        debugPrint(
            "vcarez customer access token have is ${responseData.token!.original!.accessToken}");
        await storage.write(
            key: keyUserToken, value: responseData.token!.original!.accessToken);

        emit.call(AddingDataValidCompletedState());
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
        emit.call(AddingDataInValidCompletedState());

        showLoader = false;
      }
    });
  }
}
