import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/feature_detail/model/feature_product_list_model.dart';
import 'package:vcarez_new/ui/feature_detail/model/featured_detail_model.dart';

import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../storage/shared_pref_const.dart';

part 'feature_detail_event.dart';

part 'feature_detail_state.dart';

class FeatureDetailBloc extends Bloc<FeatureDetailEvent, FeatureDetailState> {
  FeatureDetailBloc() : super(FeatureDetailInitial()) {
    on<GetFeaturedBrandDetail>((event, emit) async {
      emit(FeaturedBrandDetailLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      FeaturedBrandDetailModel responseData =
          await ApiController().getFeaturedBrandDetail(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Popular Success emited ");
        emit(OnFeaturedBrandDetailLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Error Popular emited ");

        emit(ErrorFeaturedBrandLoading());
      }
    });
    on<GetFeaturedDetailProductList>((event, emit) async {
      emit(FeaturedProductListLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      FeatureProductListModel responseData =
          await ApiController().getFeaturedProductList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Popular Success emited ");
        emit(OnFeaturedProductListLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Error Popular emited ");

        emit(ErrorFeaturedProductListLoading());
      }
    });
  }
}
