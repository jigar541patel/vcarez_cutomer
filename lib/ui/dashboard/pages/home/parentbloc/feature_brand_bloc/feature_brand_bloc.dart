import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

import '../../../../../../services/repo/common_repo.dart';
import '../../../../../../utils/CommonUtils.dart';
import '../../../../../storage/shared_pref_const.dart';
import '../../model/feature_brand_model.dart';

part 'feature_brand_event.dart';
part 'feature_brand_state.dart';

class FeatureBrandBloc extends Bloc<FeatureBrandEvent, FeatureBrandState> {
  FeatureBrandBloc() : super(FeatureBrandInitial()) {
    on<GetFeatureBrandList>((event, emit) async {
      emit(FeatureBrandLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      FeatureBrandModel responseData =
      await ApiController().getFeatureBrandList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Popular Success emited ");
        emit(OnFeatureBrandLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Error Popular emited ");

        emit(ErrorFeatureBrandLoading());
      }
    });
  }
}
