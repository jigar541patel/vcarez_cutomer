import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/dashboard/pages/notification/model/notification_list_model.dart';

import '../../../../../services/repo/common_repo.dart';
import '../../../../../utils/CommonUtils.dart';
import '../../../../storage/shared_pref_const.dart';

part 'notification_event.dart';
part 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc() : super(NotificationInitial()) {
    on<GetNotificationList>((event, emit) async {
      emit(NotificationLoadingState());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      NotificationListModel responseData =
      await ApiController().getNotificationList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Popular Success emited ");
        emit(OnNotificationLoadedState(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez Error Popular emited ");

        emit(NotificationErrorState());
      }
    });
  }
}
