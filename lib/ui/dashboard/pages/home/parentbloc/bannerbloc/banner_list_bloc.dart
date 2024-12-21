import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/repo/common_repo.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/banner_list_model.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

part 'banner_list_event.dart';
part 'banner_list_state.dart';

class BannerListBloc extends Bloc<BannerListEvent, BannerListState> {
  BannerListBloc() : super(BannerListInitial()) {
    // on<BannerListEvent>((event, emit) {
    //   // TODO: implement event handler

      on<GetBannerList>((event, emit) async {
        var storage = const FlutterSecureStorage();

        String? token = await storage.read(key: keyUserToken);
        debugPrint("vcarez customer reading access token have is $token");
        BannerListModel responseData =
        await ApiController().getBannerList(token!);

        if (responseData.success!) {
          // CommonUtils.utils.showToast(responseData.message as String);
          debugPrint("vcarez OnBannerLoaded emited ");
          emit(OnBannerLoaded(responseData));
        } else {
          CommonUtils.utils.showToast(responseData.message as String);
          debugPrint("vcarez ErrorDataLoading emited ");
          emit(ErrorDataLoading());
        }
      });
    // });
  }
}
