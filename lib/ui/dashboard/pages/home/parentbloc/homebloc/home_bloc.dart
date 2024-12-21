import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vcarez_new/services/repo/common_repo.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/banner_list_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/category_list_model.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

import '../../../../../../services/api/api_hitter.dart';
import '../../../../../cart/model/cart_list_model.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<GetCurrentLocationName>((event, emit) async {
      // TODO: implement event handler
      emit(DataLoading());
      Position position = await _determinePosition();
      debugPrint("vcarez customer location we have is ${position.latitude}");
      debugPrint("vcarez customer location we have is ${position.latitude}");

      var storage = const FlutterSecureStorage();

      await storage.write(key: keyUserLat, value: position.latitude.toString());
      await storage.write(
          key: keyUserLong, value: position.longitude.toString());

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);

      debugPrint(
          "vcarez customer location we have is ${placemarks[0].locality!}");
      emit(OnLocationLoadedState(placemarks[0].locality!));
    });

    on<GetHomeCartListEvent>((event, emit) async {
      emit(HomeCartLoadingState());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      CartListModel responseData = await ApiController().getCartList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        emit(OnHomeCartListLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(ErrorHomeCartLoading());
      }
    });

    on<AddToCartMedicineEvent>((event, emit) async {
      emit.call(AddToCartSubmittingState());

      var requestBody = {
        "medicine_id": event.strMedicineID,
        "name": event.strMedicineName,
        "image_url": event.strMedicineUrl,
        "type": event.strMedicineType,
        "mrp": event.strMedicineMrp,
        "packaging": event.strMedicinePackaging,
        "pack_info": event.strMedicinePackInfo,
      };

      var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      ApiResponse responseData =
          await ApiController().addToCart(token!, requestBody);
      // showLoader.value = false;
      debugPrint("vcarez customer update we have is ${responseData.message}");

      if (responseData.success) {
        CommonUtils.utils.showToast(responseData.message);
        emit.call(AddToCartSuccessState());
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
        emit.call(AddToCartFailureState());

        // showLoader = false;
      }
    });
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
