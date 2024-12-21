import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/services/repo/common_repo.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/category_list_model.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

part 'category_list_event.dart';

part 'category_list_state.dart';

class CategoryListBloc extends Bloc<CategoryListEvent, CategoryListState> {
  CategoryListBloc() : super(CategoryListInitial()) {
    // on<CategoryListEvent>((event, emit) {
    //   // TODO: implement event handler
    // });

    on<GetCategoryList>((event, emit) async {
      var storage = const FlutterSecureStorage();

      String? token = await storage.read(key: keyUserToken);
      debugPrint("vcarez customer reading access token have is $token");
      CategoriesListModel responseData =
          await ApiController().getCategoryList(token!);

      if (responseData.success!) {
        // CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez OnBannerLoaded emited ");
        emit(OnCategoryLoaded(responseData));
      } else {
        CommonUtils.utils.showToast(responseData.message as String);
        debugPrint("vcarez ErrorDataLoading emited ");
        emit(ErrorCategoryLoading());
      }
    });
  }
}
