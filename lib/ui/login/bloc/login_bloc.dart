import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/login/model/login_model.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/strings.dart';

import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/route_names.dart';

part 'login_event.dart';

part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    // on<LoginEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<LoginTextChangedEvent>((event, emit) {
      if (EmailValidator.validate(event.strEmail) == false) {
        emit(LoginErrorState(emailError));
      } else if (event.strPassword == "") {
        emit(LoginErrorState(passwordError));
      } else {
        emit(LoginValidState());
      }
    });
    on<LoginSubmittedEvent>((event, emit) async {
      debugPrint("vcarez customer login submit bloc called ");

      emit.call(AddingDataInProgressState());

      var requestBody = {
        "email": event.strEmail,
        "password": event.strPassword,
      };

      var responseData = await ApiController().userLogin(requestBody);
      // showLoader.value = false;
      debugPrint("vcarez customer we have is $responseData");

      if (responseData.success) {
        LoginModel loginModel = responseData;
        CommonUtils.utils.showToast(successLogin);
        emit.call(AddingDataValidCompletedState());
        var storage = FlutterSecureStorage();

        debugPrint(
            "vcarez customer access token have is ${loginModel.token.original.accessToken}");
        await storage.write(
            key: keyUserToken, value: loginModel.token.original.accessToken);

        //stored in SharedPrefConstant.dart
        // storage.write(userData, responseData.result);
        // storage.write(userPassword, passwordController.text);
        // storage.write(userPassword, passwordController.text);
        // GlobalVariables.userToken = responseData.token!;
        // passwordController.clear();
        // Get.to(() => LoginLocationScreen());

      } else {
        emit.call(AddingDataInValidCompletedState());
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
      }
    });
  }
}
