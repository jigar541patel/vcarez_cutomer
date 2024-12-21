import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vcarez_new/services/repo/common_repo.dart';
import 'package:vcarez_new/ui/medicinedetails/model/medicine_detail_model.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

import '../../../services/api/api_hitter.dart';

part 'medicine_detail_event.dart';

part 'medicine_detail_state.dart';

class MedicineDetailBloc
    extends Bloc<MedicineDetailEvent, MedicineDetailState> {
  MedicineDetailBloc() : super(MedicineDetailInitial()) {
    emit(MedicineDataLoading());
    on<GetMedicineDetailEvent>((event, emit) async {
      var storage = const FlutterSecureStorage();

      String strMedicineID = event.strID.toString();
      String strType = event.strType.toString();
      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez vendor strMedicineID is $strMedicineID");

      MedicineDetailModel responseData = await ApiController()
          .getMedicineDetail(token!, strMedicineID, strType);
      // await ApiController().getMedicineDetail(token!,"718");
      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        emit(OnMedicineLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        // debugPrint("vcarez MedicineDetailBloc ErrorDataLoading emited ${responseData.medicine!.mrp}");
        emit(ErrorMedicineLoading());
      }
    });

    on<UpdateMedicineQuantityEvent>((event, emit) {
      emit(OnUpdateQuantitySuccessState(event.intQuantity));
    });

    on<AddToCartMedicineEvent>((event, emit) async {
      emit.call(AddToCartDetailSubmittingState());

      var requestBody = {
        "medicine_id": event.strMedicineID,
        "name": event.strMedicineName,
        "image_url": event.strMedicineUrl,
        "type": event.strMedicineType,
        "mrp": event.strMedicineMrp,
        "quantity":int.parse(event.strQuantity!),
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
        emit.call(AddToCartDetailSuccessState());
      } else {
        CommonUtils.utils.showToast(
            // responseData.status as int+
            responseData.message as String);
        emit.call(AddToCartFailureState());

        // showLoader = false;
      }
    });
  }
}
