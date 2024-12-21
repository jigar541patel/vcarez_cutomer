import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/myorderlist/model/my_order_list_model.dart';

import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../storage/shared_pref_const.dart';

part 'my_order_list_event.dart';

part 'my_order_list_state.dart';

class MyOrderListBloc extends Bloc<MyOrderListEvent, MyOrderListState> {
  MyOrderListBloc() : super(MyOrderListInitial()) {
    on<GetMyOrderList>((event, emit) async {
      emit(MyOrderListLoadingState());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      MyOrderListModel responseData =
          await ApiController().getMyOrderList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnMyOrderListLoadedState emited ");
        emit(OnMyOrderListLoadedState(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorMyOrderListLoadingState emited ");
        emit(ErrorMyOrderListLoadingState());
      }
    });
  }
}
