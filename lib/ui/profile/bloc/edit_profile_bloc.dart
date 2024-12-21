import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/api/api_hitter.dart';
import 'package:vcarez_new/ui/profile/model/profile_model.dart';
import 'package:vcarez_new/utils/strings.dart';

import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../storage/shared_pref_const.dart';

part 'edit_profile_event.dart';

part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc() : super(EditProfileInitial()) {
    on<GetProfileEvent>((event, emit) async {
      emit(DataLoading());
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ProfileModel responseData = await ApiController().getUserProfile(token!);

      if (responseData.success!) {
        emit(DataLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        emit(ErrorDataLoading());
      }
    });

    on<UpdateProfileSubmittedEvent>((event, emit) async {
      emit.call(AddingDataInProgressState());

      var requestBody = {
        "email": event.strEmail,
        'phone': event.strPhoneNumber,
        'location': event.strLocation,
      };
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ApiResponse responseData =
          await ApiController().userUpdateProfile(token!, requestBody);
      // showLoader.value = false;
      debugPrint("vcarez customer update we have is ${responseData.message}");

      if (responseData.success) {
        CommonUtils.utils.showToast(responseData.message);
        emit.call(AddingDataValidCompletedState());
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
        emit.call(AddingDataInValidCompletedState());

        // showLoader = false;
      }
    });
  }
}
