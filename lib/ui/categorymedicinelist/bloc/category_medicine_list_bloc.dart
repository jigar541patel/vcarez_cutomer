import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/repo/common_repo.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

import '../model/category_product_list_model.dart';

part 'category_medicine_list_event.dart';
part 'category_medicine_list_state.dart';

class CategoryMedicineListBloc extends Bloc<CategoryMedicineListEvent, CategoryMedicineListState> {
  CategoryMedicineListBloc() : super(CategoryMedicineListInitial()) {
    // on<CategoryMedicineListEvent>((event, emit) {
    //   // TODO: implement event handler
    //
    // });
    on<GetCategoryMedicineList>((event, emit) async {
      emit(CategoryProductLoading());
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      CategoryProductListModel responseData =
      await ApiController().getCategoryMedicineList(token!,event.strCategoryID);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        emit(OnCategoryProductLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(ErrorCategoryProductLoading());
      }
    });
  }
}
