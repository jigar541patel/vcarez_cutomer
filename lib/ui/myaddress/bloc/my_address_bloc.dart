import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/myaddress/model/state_list_model.dart';

import '../../../services/api/api_hitter.dart';
import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../dashboard/pages/prescription/model/address_list_model.dart';
import '../../storage/shared_pref_const.dart';
import '../model/city_list_model.dart';

part 'my_address_event.dart';

part 'my_address_state.dart';

class MyAddressBloc extends Bloc<MyAddressEvent, MyAddressState> {
  MyAddressBloc() : super(MyAddressInitial()) {
    on<GetAddressListEvent>((event, emit) async {
      emit(OnAddressLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");

      AddressListModel responseData =
          await ApiController().getAddressList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnAddressLoaded emited ");
        emit(OnAddressLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorAddressLoading emited ");
        emit(ErrorAddressLoading());
      }
    });


    on<GetStateListEvent>((event, emit) async {
      emit(OnAddressLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");

      StateListModel responseData =
      await ApiController().getStateList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnAddressLoaded emited ");
        emit(OnStateListLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorAddressLoading emited ");
        emit(ErrorAddressLoading());
      }
    });
    on<GetCityListEvent>((event, emit) async {
      emit(OnAddressLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");

      CityListModel responseData =
      await ApiController().getCityList(token!,event.strCityID);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez city list emited ");
        emit(OnCityListLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorAddressLoading emited ");
        emit(ErrorAddressLoading());
      }
    });

    on<UpdateAddressSubmittedEvent>((event, emit) async {
      emit.call(AddingAddressInProgressState());

      var requestBody = {
        "address": event.strAddress,
        'lattitude': event.strLatitude,
        'longitude': event.strLongitude,
        'state_id': event.strState,
        'city_id': event.strCity,
        'pincode': event.strPincode,
      };
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ApiResponse responseData =
          await ApiController().updateAddress(token!, requestBody,event.strAddressID);
      debugPrint("vcarez customer update we have is ${responseData.message}");

      if (responseData.success) {
        CommonUtils.utils.showToast(responseData.message);
        emit.call(AddingAddressValidCompletedState());
      } else {
        CommonUtils.utils.showToast(responseData.message);
        emit.call(ErrorSaveAddressState());
      }
    });


    on<SaveAddressSubmittedEvent>((event, emit) async {
      emit.call(AddingAddressInProgressState());

      var requestBody = {
        "address": event.strAddress,
        'lattitude': event.strLatitude,
        'longitude': event.strLongitude,
        'state_id': event.strState,
        'city_id': event.strCity,
        'pincode': event.strPincode,
      };
      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ApiResponse responseData =
          await ApiController().saveAddress(token!, requestBody);
      debugPrint("vcarez customer update we have is ${responseData.message}");

      if (responseData.success) {
        CommonUtils.utils.showToast(responseData.message);
        emit.call(AddingAddressValidCompletedState());
      } else {
        CommonUtils.utils.showToast(responseData.message);
        emit.call(ErrorSaveAddressState());
      }
    });

    on<DeleteAddressEvent>((event, emit) async {
      emit.call(DeleteAddressInProgressState());

      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ApiResponse responseData =
          await ApiController().deleteAddress(token!, event.strAddressID);
      // showLoader.value = false;
      debugPrint("vcarez customer update we have is ${responseData.message}");

      if (responseData.success) {
        CommonUtils.utils.showToast(responseData.message);
        emit.call(DeleteAddressValidCompletedState());
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message);
        emit.call(ErrorDeleteAddressState());

        // showLoader = false;
      }
    });
  }
}
