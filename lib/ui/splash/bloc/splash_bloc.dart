import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../profile/bloc/edit_profile_bloc.dart';
import '../../profile/model/profile_model.dart';
import '../../storage/shared_pref_const.dart';

part 'splash_event.dart';

part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc() : super(SplashInitial()) {
    // on<SplashEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<GetProfileEvent>((event, emit) async {
      emit(DataLoading());
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ProfileModel responseData = await ApiController().getUserProfile(token!);

      if (responseData.success == false) {
        emit(TokenExpired());
        CommonUtils.utils.showToast(responseData.message as String);
        emit(ErrorDataLoading());
      }
      if (responseData.success!) {
        emit(DataLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        emit(ErrorDataLoading());
      }
    });
  }
}
