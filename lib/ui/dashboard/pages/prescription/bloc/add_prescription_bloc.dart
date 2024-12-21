import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http_parser/http_parser.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/model/UploadPrescriptionModel.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/model/address_list_model.dart';

import '../../../../../services/api/api_hitter.dart';
import '../../../../../services/repo/common_repo.dart';
import '../../../../../utils/CommonUtils.dart';
import '../../../../my_prescription/bloc/my_prescription_bloc.dart';
import '../../../../storage/shared_pref_const.dart';

part 'add_prescription_event.dart';

part 'add_prescription_state.dart';

class AddPrescriptionBloc
    extends Bloc<AddPrescriptionEvent, AddPrescriptionState> {
  FlutterSecureStorage storage = FlutterSecureStorage();

  AddPrescriptionBloc() : super(AddPrescriptionInitial()) {
    on<UploadPrescriptionEvent>((event, emit) async {
      // String? lat = await storage.read(key: keyUserLat);
      // String? long = await storage.read(key: keyUserLong);
      emit.call(AddingDataInProgressState());

      var requestBody = {
        "upload_prescription": true,
        "deliver_or_pickup": event.deliveryType,
        "delivery_address": event.deliveryAddress,
        // "lattitude": double.parse('$lat'),
        // "longitude": double.parse('$long'),
        "lattitude": event.latitude,
        "longitude": event.longitude,
        "customer_prescription": {
          "medicine_specific_order":
              event.wholeItemPrescription == "only" ? true : false,
          "specific_medicine_details": event.specificItemDetails,
          "call_us": true
        },
        "alternative": event.alternativeType,
        "quote_medicine": event.listOfMedicineColumns

        // "quote_medicine": [
        //   {"medicine_name": "medicine 1", "qty": 10},
        //   {"medicine_name": "medicine 2", "qty": 16}
        // ]
      };
      // var storage = FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      debugPrint("vcarez customer paramet requestBody :  $requestBody");
      var responseData =
          await ApiController().userUploadPrescription(token!, requestBody);
      // showLoader.value = false;
      debugPrint(
          "vcarez customer upload prescription we have is ${responseData.message}");

      if (responseData.success) {
        CommonUtils.utils.showToast(responseData.message);
        UploadPrescriptionModel uploadPrescriptionModel = responseData;
        debugPrint(
            "vcarez customer uploadPrescriptionModel response is ${uploadPrescriptionModel.cPrescriptionId.toString()}");
        uploadPrescriptionImage(
            uploadPrescriptionModel.cPrescriptionId.toString(),
            event.prescriptionImage!);
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as
            // int+

            responseData.message as String);
        emit.call(AddingDataInValidCompletedState());

        // showLoader = false;
      }
    });
    on<MedicineDataAddDeleteEvent>((event, emit) async {
      debugPrint(
          "vcarez we have is event.listOfMedicineColumns ${event.listOfMedicineColumns}");
      emit(MedicineDataAdded(event.listOfMedicineColumns));
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
        debugPrint("vcarez OnBannerLoaded emited ");
        emit(OnAddressLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(ErrorAddressLoading());
      }
    });
  }

  void openAddressDialog() {}

  void uploadPrescriptionImage(
      String strPrescriptionID, File prescriptionImage) async {
    FormData loginFormData = FormData.fromMap({
      'customer_prescription_id': strPrescriptionID,
      "c_prescription": await MultipartFile.fromFile(
        prescriptionImage.path,
        filename: prescriptionImage.path.split('/').last.toLowerCase(),
        contentType: MediaType("image", "jpg"), //important
      ),
      // 'aadhar': event.strAdhaarImage,
    });

    String? token = await storage.read(key: keyUserToken);
    ApiResponse responseData = await ApiController()
        .userUploadImagePrescription(token!, loginFormData);
    // showLoader.value = false;
    debugPrint("vcarez customer register we have is $responseData");

    if (responseData.success) {
      // showLoader = false;
      emit.call(AddingDataValidCompletedState());

      CommonUtils.utils.showToast(responseData.message);

      // Future.delayed(const Duration(milliseconds: 500), () {
      // });

      //  emit.call(AddingDataValidCompletedState());
    } else {
      emit.call(AddingDataInValidCompletedState());
      CommonUtils.utils.showToast(
          // responseData.status as int+
          responseData.message as String);
      //emit.call(AddingDataInValidCompletedState());
    }
  }
}
