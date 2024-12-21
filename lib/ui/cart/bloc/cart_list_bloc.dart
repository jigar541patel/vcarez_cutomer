import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/api/api_hitter.dart';
import 'package:vcarez_new/ui/cart/model/cart_list_model.dart';
import 'package:vibration/vibration.dart';

import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../dashboard/pages/prescription/model/address_list_model.dart';
import '../../storage/shared_pref_const.dart';

part 'cart_list_event.dart';

part 'cart_list_state.dart';

class CartListBloc extends Bloc<CartListEvent, CartListState> {
  CartListBloc() : super(CartListInitial()) {


    on<GetCartListEvent>((event, emit) async {
      emit(CartLoadingState());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");


      CartListModel responseData = await ApiController().getCartList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        CommonUtils.cartListModel = responseData;

        emit(OnCartListLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(ErrorCartLoading());
      }
    });

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

    on<PlaceOrderEvent>((event, emit) async {
      emit(PlaceOrderLoadingState());
      var storage = const FlutterSecureStorage();
      var requestBody = {
        "deliver_or_pickup": event.strDeliveryType,
        "alternative": event.intAlternative.toString(),
        "delivery_address": event.strDeliveryAddress,
        "lattitude": event.doubleLatitude,
        "longitude": event.doubleLongitude,
      };

      // {
      //   "deliver_or_pickup":"deliver",
      // "alternative":"0",
      // "delivery_address":"Abcd, New Delhi",
      // "lattitude":28.87878,
      // "longitude":75.87483
      // }
      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      // debugPrint("vcarez customer event.strID! token have is ${event.doubleLongitude}");
      // debugPrint(
      //     "vcarez customer event.strQuantity! token have is ${event.strQuantity}");
      // debugPrint(
      //     "vcarez customer event.strQuantity! token have is ${requestBody.toString()}");
      ApiResponse responseData =
          await ApiController().placeOrderFromCart(token!, requestBody);

      if (responseData.success) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        Fluttertoast.showToast(msg: responseData.message);
        emit(PlaceOrderSuccessState());
        Vibration.vibrate(duration: 1000);
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(PlaceOrderErrorState());
      }
    });

    on<UpdateCartListEvent>((event, emit) async {
      emit(CartUpdateLoadingState());
      var storage = const FlutterSecureStorage();
      var requestBody = {
        "quantity": event.strQuantity,
      };
      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      debugPrint("vcarez customer event.strID! token have is ${event.strID}");
      debugPrint(
          "vcarez customer event.strQuantity! token have is ${event.strQuantity}");
      debugPrint(
          "vcarez customer event.strQuantity! token have is ${requestBody.toString()}");
      ApiResponse responseData =
          await ApiController().updateCart(token!, event.strID, requestBody);

      if (responseData.success) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        Fluttertoast.showToast(msg: responseData.message);
        emit(UpdateCartSuccessState());
        Vibration.vibrate(duration: 1000);
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(ErrorCartLoading());
      }
    });
  }
}
