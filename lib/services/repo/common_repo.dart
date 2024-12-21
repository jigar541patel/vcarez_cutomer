import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:vcarez_new/ui/cart/model/cart_list_model.dart';
import 'package:vcarez_new/ui/categorymedicinelist/model/category_product_list_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/banner_list_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/category_list_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/popular_medicine_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/search_medicine_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/trending_medicine_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/currentorder/model/current_order_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/model/UploadPrescriptionModel.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/model/address_list_model.dart';
import 'package:vcarez_new/ui/feature_detail/model/feature_product_list_model.dart';
import 'package:vcarez_new/ui/feature_detail/model/featured_detail_model.dart';
import 'package:vcarez_new/ui/login/model/login_model.dart';
import 'package:vcarez_new/ui/medicinedetails/model/medicine_detail_model.dart';
import 'package:vcarez_new/ui/my_prescription/model/MyPrescriptionModel.dart';
import 'package:vcarez_new/ui/myaddress/model/state_list_model.dart';
import 'package:vcarez_new/ui/myorderlist/model/my_order_list_model.dart';
import 'package:vcarez_new/ui/payment/model/create_order_model.dart';
import 'package:vcarez_new/ui/profile/model/profile_model.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/model/quotation_list_history_model.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/order_accept_success_model.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/shop_quotation_detail_model.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/verify_cf_model.dart';

import '../../base/base_repository.dart';
import '../../ui/dashboard/pages/home/model/feature_brand_model.dart';
import '../../ui/dashboard/pages/notification/model/notification_list_model.dart';
import '../../ui/myaddress/model/city_list_model.dart';
import '../../ui/privilegeplan/model/buy_plan_success_model.dart';
import '../../ui/privilegeplan/model/privilege_plan_model.dart';
import '../../ui/quotationrecievedhistory/model/quotation_recieved_list_model.dart';
import '../../ui/searchdetailist/model/search_detail_result_list_model.dart';
import '../../ui/signup/model/signup_model.dart';
import '../api/api_end_point.dart';
import '../api/api_hitter.dart';

class ApiController extends BaseRepository {
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      debugPrint('Couldn\'t check connectivity status${e.message}');
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    // if (!mounted) {
    //   return Future.value(null);
    // }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    // setState(() {
    _connectionStatus = result;
    // });
  }

  Future<SearchResultModel> getSearchMedicineList(
      String userToken, String searchQuery,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.searchMedicineDetail}?search=$searchQuery",
        headers: auth,
        queryParams: requestBody);

    debugPrint("vcarez the getSearchMedicineList api status is ${apiResponse.responseCode}");
    debugPrint("vcarez the getSearchMedicineList api data is ${apiResponse.response!.data}");

    try {
      if (apiResponse.responseCode == null) {
        if (apiResponse.message.contains("Medicines fetched successfully")) {
          final passEntity =
              SearchResultModel.fromJson(apiResponse.response!.data);
          return passEntity;
        }
      }
      if (apiResponse.responseCode == 403) {
        return SearchResultModel(
            success: false, message: apiResponse.message, medicines: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                SearchResultModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return SearchResultModel(
                  success: false,
                  message: apiResponse.message,
                  medicines: null);
            } else {
              return SearchResultModel(
                  success: apiResponse.success,
                  message: apiResponse.message,
                  medicines: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return SearchResultModel(
                success: false, message: apiResponse.message, medicines: null);
          } else {
            return SearchResultModel(
                success: apiResponse.success,
                message: apiResponse.message,
                medicines: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return SearchResultModel(
              success: false, message: apiResponse.message, medicines: null);
        } else {
          return SearchResultModel(
              success: apiResponse.success,
              message: apiResponse.message,
              medicines: null);
        }
      }
    } catch (error) {
      return SearchResultModel(
          success: false, message: apiResponse.message, medicines: null);
    }
  }

  Future<SearchDetailResultModel> getDetailSearchMedicineList(
      String userToken, String searchQuery,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.searchMedicineDetail}?search=$searchQuery",
        headers: auth,
        queryParams: requestBody);

    debugPrint("vcarez the getSearchMedicineList api status is ${apiResponse.responseCode}");
    debugPrint("vcarez the getSearchMedicineList api data is ${apiResponse.response!.data}");

    try {
      if (apiResponse.responseCode == null) {
        if (apiResponse.message.contains("Medicines fetched successfully")) {
          final passEntity =
              SearchDetailResultModel.fromJson(apiResponse.response!.data);
          return passEntity;
        }
      }
      if (apiResponse.responseCode == 403) {
        return SearchDetailResultModel(
            success: false, message: apiResponse.message, medicines: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                SearchDetailResultModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return SearchDetailResultModel(
                  success: false,
                  message: apiResponse.message,
                  medicines: null);
            } else {
              return SearchDetailResultModel(
                  success: apiResponse.success,
                  message: apiResponse.message,
                  medicines: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return SearchDetailResultModel(
                success: false, message: apiResponse.message, medicines: null);
          } else {
            return SearchDetailResultModel(
                success: apiResponse.success,
                message: apiResponse.message,
                medicines: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return SearchDetailResultModel(
              success: false, message: apiResponse.message, medicines: null);
        } else {
          return SearchDetailResultModel(
              success: apiResponse.success,
              message: apiResponse.message,
              medicines: null);
        }
      }
    } catch (error) {
      return SearchDetailResultModel(
          success: false, message: apiResponse.message, medicines: null);
    }
  }

  Future<dynamic> forgotPassword(var loginFormData) async {
    initConnectivity();

    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter
        .getPostApiResponse(ApiEndpoint.forgotPassword, data: loginFormData);

    {
      try {
        if (apiResponse.success) {
          if (apiResponse.response!.data != null) {
            // debugPrint("vcarez the forgotPassword rrsponsecode== is " +
            //     apiResponse.responseCode.toString());
            if (apiResponse.responseCode) {
              return ApiResponse(true,
                  responseCode: apiResponse.responseCode,
                  message: apiResponse.response!.data['message']);
            } else {
              return ApiResponse(false,
                  responseCode: apiResponse.responseCode,
                  message: apiResponse.response!.data['message']);
            }
          } else {
            return apiResponse;
            // return LoginModel(
            //     token: apiResponse.response!.data,
            //     success: apiResponse.success);
          }
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> verifyOtpPassword(var loginFormData) async {
    initConnectivity();

    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter
        .getPostApiResponse(ApiEndpoint.updatePassword, data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          if (apiResponse.response!.data != null) {
            if (apiResponse.responseCode) {
              return ApiResponse(true,
                  responseCode: apiResponse.responseCode,
                  message: apiResponse.response!.data['message']);
            } else {
              return ApiResponse(false,
                  responseCode: apiResponse.responseCode,
                  message: apiResponse.response!.data['message']);
            }
          } else {
            return apiResponse;
            // return LoginModel(
            //     token: apiResponse.response!.data,
            //     success: apiResponse.success);
          }
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> userLogin(var loginFormData) async {
    initConnectivity();

    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter
        .getPostApiResponse(ApiEndpoint.userLogin, data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          if (apiResponse.response!.data != null) {
            final passEntity = LoginModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            return apiResponse;
            // return LoginModel(
            //     token: apiResponse.response!.data,
            //     success: apiResponse.success);
          }
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<ProfileModel> getUserProfile(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getUserprofile,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return ProfileModel(
            success: false, message: apiResponse.message, user: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            if (apiResponse.response!.data['status'] == 403) {
              return ProfileModel(
                  success: false, message: apiResponse.message, user: null);
            } else {
              final passEntity =
                  ProfileModel.fromJson(apiResponse.response!.data);
              return passEntity;
            }
          } else {
            if (apiResponse.responseCode == 403) {
              return ProfileModel(
                  success: false, message: apiResponse.message, user: null);
            } else {
              return ProfileModel(
                  success: apiResponse.success,
                  message: apiResponse.message,
                  user: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return ProfileModel(
                success: false, message: apiResponse.message, user: null);
          } else {
            return ProfileModel(
                success: apiResponse.success,
                message: apiResponse.message,
                user: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return ProfileModel(
              success: false, message: apiResponse.message, user: null);
        } else {
          return ProfileModel(
              success: apiResponse.success,
              message: apiResponse.message,
              user: null);
        }
      }
    } catch (error) {
      return ProfileModel(
          success: false, message: apiResponse.message, user: null);
    }
  }

  Future<PrivilegePlanModel> getPrivilegePlanList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getPrivilegePlanList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return PrivilegePlanModel(
            success: false, message: apiResponse.message, plans: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                PrivilegePlanModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return PrivilegePlanModel(
                  success: false, message: apiResponse.message, plans: null);
            } else {
              return PrivilegePlanModel(
                  success: apiResponse.success,
                  message: apiResponse.message,
                  plans: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return PrivilegePlanModel(
                success: false, message: apiResponse.message, plans: null);
          } else {
            return PrivilegePlanModel(
                success: apiResponse.success,
                message: apiResponse.message,
                plans: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return PrivilegePlanModel(
              success: false, message: apiResponse.message, plans: null);
        } else {
          return PrivilegePlanModel(
              success: apiResponse.success,
              message: apiResponse.message,
              plans: null);
        }
      }
    } catch (error) {
      return PrivilegePlanModel(
          success: false, message: apiResponse.message, plans: null);
    }
  }

  Future<MyPrescriptionModel> getPrescriptionList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getPrescriptionList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return MyPrescriptionModel(
            success: false,
            message: apiResponse.message,
            prescriptionList: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                MyPrescriptionModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return MyPrescriptionModel(
                  success: false,
                  message: apiResponse.message,
                  prescriptionList: null);
            } else {
              return MyPrescriptionModel(
                  success: false,
                  message: apiResponse.message,
                  prescriptionList: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return MyPrescriptionModel(
                success: false,
                message: apiResponse.message,
                prescriptionList: null);
          } else {
            return MyPrescriptionModel(
                success: false,
                message: apiResponse.message,
                prescriptionList: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return MyPrescriptionModel(
              success: false,
              message: apiResponse.message,
              prescriptionList: null);
        } else {
          return MyPrescriptionModel(
              success: false,
              message: apiResponse.message,
              prescriptionList: null);
        }
      }
    } catch (error) {
      return MyPrescriptionModel(
          success: false, message: apiResponse.message, prescriptionList: null);
    }
  }

  Future<BannerListModel> getBannerList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getBannerList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return BannerListModel(
            success: false, message: apiResponse.message, data: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                BannerListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return BannerListModel(
                  success: false, message: apiResponse.message, data: null);
            } else {
              return BannerListModel(
                  success: false, message: apiResponse.message, data: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return BannerListModel(
                success: false, message: apiResponse.message, data: null);
          } else {
            return BannerListModel(
                success: false, message: apiResponse.message, data: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return BannerListModel(
              success: false, message: apiResponse.message, data: null);
        } else {
          return BannerListModel(
              success: false, message: apiResponse.message, data: null);
        }
      }
    } catch (error) {
      return BannerListModel(
          success: false, message: apiResponse.message, data: null);
    }
  }

  Future<CategoriesListModel> getCategoryList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getCategoryList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return CategoriesListModel(
            success: false, message: apiResponse.message, categories: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                CategoriesListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return CategoriesListModel(
                  success: false,
                  message: apiResponse.message,
                  categories: null);
            } else {
              return CategoriesListModel(
                  success: false,
                  message: apiResponse.message,
                  categories: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return CategoriesListModel(
                success: false, message: apiResponse.message, categories: null);
          } else {
            return CategoriesListModel(
                success: false, message: apiResponse.message, categories: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return CategoriesListModel(
              success: false, message: apiResponse.message, categories: null);
        } else {
          return CategoriesListModel(
              success: false, message: apiResponse.message, categories: null);
        }
      }
    } catch (error) {
      return CategoriesListModel(
          success: false, message: apiResponse.message, categories: null);
    }
  }

  Future<CurrentOrdersModel> getCurrentOrderList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getCurrentOrderList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return CurrentOrdersModel(
            success: false, message: apiResponse.message, orders: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                CurrentOrdersModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return CurrentOrdersModel(
                  success: false, message: apiResponse.message, orders: null);
            } else {
              return CurrentOrdersModel(
                  success: false, message: apiResponse.message, orders: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return CurrentOrdersModel(
                success: false, message: apiResponse.message, orders: null);
          } else {
            return CurrentOrdersModel(
                success: false, message: apiResponse.message, orders: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return CurrentOrdersModel(
              success: false, message: apiResponse.message, orders: null);
        } else {
          return CurrentOrdersModel(
              success: false, message: apiResponse.message, orders: null);
        }
      }
    } catch (error) {
      return CurrentOrdersModel(
          success: false, message: apiResponse.message, orders: null);
    }
  }

  Future<StateListModel> getStateList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getStateList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return StateListModel(
            success: false, message: apiResponse.message, data: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                StateListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return StateListModel(
                  success: false, message: apiResponse.message, data: null);
            } else {
              return StateListModel(
                  success: false, message: apiResponse.message, data: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return StateListModel(
                success: false, message: apiResponse.message, data: null);
          } else {
            return StateListModel(
                success: false, message: apiResponse.message, data: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return StateListModel(
              success: false, message: apiResponse.message, data: null);
        } else {
          return StateListModel(
              success: false, message: apiResponse.message, data: null);
        }
      }
    } catch (error) {
      return StateListModel(
          success: false, message: apiResponse.message, data: null);
    }
  }

  Future<CityListModel> getCityList(String userToken, String strStateID,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        // ApiEndpoint.getCityList,
        "${ApiEndpoint.getCityList}/$strStateID",
        headers: auth,
        queryParams: requestBody);
    debugPrint("vcarez apiResponse apiResponse.response ${apiResponse.response}");
    try {
      if (apiResponse.responseCode == 403) {
        return CityListModel(
            success: false, message: apiResponse.message, data: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                CityListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return CityListModel(
                  success: false, message: apiResponse.message, data: null);
            } else {
              return CityListModel(
                  success: false, message: apiResponse.message, data: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return CityListModel(
                success: false, message: apiResponse.message, data: null);
          } else {
            return CityListModel(
                success: false, message: apiResponse.message, data: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return CityListModel(
              success: false, message: apiResponse.message, data: null);
        } else {
          return CityListModel(
              success: false, message: apiResponse.message, data: null);
        }
      }
    } catch (error) {
      return CityListModel(
          success: false, message: apiResponse.message, data: null);
    }
  }

  Future<AddressListModel> getAddressList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getAddressList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return AddressListModel(
            success: false, message: apiResponse.message, addresses: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                AddressListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return AddressListModel(
                  success: false,
                  message: apiResponse.message,
                  addresses: null);
            } else {
              return AddressListModel(
                  success: false,
                  message: apiResponse.message,
                  addresses: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return AddressListModel(
                success: false, message: apiResponse.message, addresses: null);
          } else {
            return AddressListModel(
                success: false, message: apiResponse.message, addresses: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return AddressListModel(
              success: false, message: apiResponse.message, addresses: null);
        } else {
          return AddressListModel(
              success: false, message: apiResponse.message, addresses: null);
        }
      }
    } catch (error) {
      return AddressListModel(
          success: false, message: apiResponse.message, addresses: null);
    }
  }

  Future<PopularMedicineModel> getPopularMedicineList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getPopularMedicineList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return PopularMedicineModel(
            success: false, message: apiResponse.message, medicines: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                PopularMedicineModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return PopularMedicineModel(
                  success: false,
                  message: apiResponse.message,
                  medicines: null);
            } else {
              return PopularMedicineModel(
                  success: false,
                  message: apiResponse.message,
                  medicines: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return PopularMedicineModel(
                success: false, message: apiResponse.message, medicines: null);
          } else {
            return PopularMedicineModel(
                success: false, message: apiResponse.message, medicines: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return PopularMedicineModel(
              success: false, message: apiResponse.message, medicines: null);
        } else {
          return PopularMedicineModel(
              success: false, message: apiResponse.message, medicines: null);
        }
      }
    } catch (error) {
      debugPrint("vcarez api error in getPopularMedicineList $error");
      return PopularMedicineModel(
          success: false, message: error.toString(), medicines: null);
    }
  }

  Future<FeaturedBrandDetailModel> getFeaturedBrandDetail(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getFeatureBrandDetail,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return FeaturedBrandDetailModel(
            success: false,
            message: apiResponse.message,
            banners: null,
            brands: null,
            deals: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                FeaturedBrandDetailModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return FeaturedBrandDetailModel(
                  success: false,
                  message: apiResponse.message,
                  banners: null,
                  brands: null,
                  deals: null);
            } else {
              return FeaturedBrandDetailModel(
                  success: false,
                  message: apiResponse.message,
                  banners: null,
                  brands: null,
                  deals: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return FeaturedBrandDetailModel(
                success: false,
                message: apiResponse.message,
                banners: null,
                brands: null,
                deals: null);
          } else {
            return FeaturedBrandDetailModel(
                success: false,
                message: apiResponse.message,
                banners: null,
                brands: null,
                deals: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return FeaturedBrandDetailModel(
              success: false,
              message: apiResponse.message,
              banners: null,
              brands: null,
              deals: null);
        } else {
          return FeaturedBrandDetailModel(
              success: false,
              message: apiResponse.message,
              banners: null,
              brands: null,
              deals: null);
        }
      }
    } catch (error) {
      debugPrint("vcarez api error in getPopularMedicineList $error");
      return FeaturedBrandDetailModel(
          success: false,
          message: error.toString(),
          banners: null,
          brands: null,
          deals: null);
    }
  }

  Future<FeatureProductListModel> getFeaturedProductList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getFeatureProductList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return FeatureProductListModel(
          success: false,
          message: apiResponse.message,
          medicines: null,
        );
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                FeatureProductListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return FeatureProductListModel(
                success: false,
                message: apiResponse.message,
                medicines: null,
              );
            } else {
              return FeatureProductListModel(
                success: false,
                message: apiResponse.message,
                medicines: null,
              );
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return FeatureProductListModel(
              success: false,
              message: apiResponse.message,
              medicines: null,
            );
          } else {
            return FeatureProductListModel(
              success: false,
              message: apiResponse.message,
              medicines: null,
            );
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return FeatureProductListModel(
            success: false,
            message: apiResponse.message,
            medicines: null,
          );
        } else {
          return FeatureProductListModel(
            success: false,
            message: apiResponse.message,
            medicines: null,
          );
        }
      }
    } catch (error) {
      debugPrint("vcarez api error in getPopularMedicineList $error");
      return FeatureProductListModel(
        success: false,
        message: error.toString(),
        medicines: null,
      );
    }
  }

  Future<FeatureBrandModel> getFeatureBrandList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getFeatureBrandList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return FeatureBrandModel(
            success: false, message: apiResponse.message, brands: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                FeatureBrandModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return FeatureBrandModel(
                  success: false, message: apiResponse.message, brands: null);
            } else {
              return FeatureBrandModel(
                  success: false, message: apiResponse.message, brands: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return FeatureBrandModel(
                success: false, message: apiResponse.message, brands: null);
          } else {
            return FeatureBrandModel(
                success: false, message: apiResponse.message, brands: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return FeatureBrandModel(
              success: false, message: apiResponse.message, brands: null);
        } else {
          return FeatureBrandModel(
              success: false, message: apiResponse.message, brands: null);
        }
      }
    } catch (error) {
      debugPrint("vcarez api error in getPopularMedicineList $error");
      return FeatureBrandModel(
          success: false, message: error.toString(), brands: null);
    }
  }

  Future<NotificationListModel> getNotificationList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getNotificationList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return NotificationListModel(
            success: false, message: apiResponse.message, notifications: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                NotificationListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return NotificationListModel(
                  success: false,
                  message: apiResponse.message,
                  notifications: null);
            } else {
              return NotificationListModel(
                  success: false,
                  message: apiResponse.message,
                  notifications: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return NotificationListModel(
                success: false,
                message: apiResponse.message,
                notifications: null);
          } else {
            return NotificationListModel(
                success: false,
                message: apiResponse.message,
                notifications: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return NotificationListModel(
              success: false,
              message: apiResponse.message,
              notifications: null);
        } else {
          return NotificationListModel(
              success: false,
              message: apiResponse.message,
              notifications: null);
        }
      }
    } catch (error) {
      debugPrint("vcarez api error in getPopularMedicineList $error");
      return NotificationListModel(
          success: false, message: error.toString(), notifications: null);
    }
  }

  Future<ShopQuotationDetailModel> getShopQuotationDetail(
      String userToken, String strID,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.getShopQuotationDetail}" + "/" + strID,
        headers: auth,
        queryParams: requestBody);

    try {
      debugPrint("vcarez response code iss ${apiResponse.responseCode}");

      // if (apiResponse.responseCode == 403) {
      //   return QuotationReceivedListModel(
      //       success: false, message: apiResponse.message, quotations: null);
      // }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                ShopQuotationDetailModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return ShopQuotationDetailModel(
                  success: false,
                  message: apiResponse.message,
                  quotation: null);
            } else {
              return ShopQuotationDetailModel(
                  success: false,
                  message: apiResponse.message,
                  quotation: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return ShopQuotationDetailModel(
                success: false, message: apiResponse.message, quotation: null);
          } else {
            return ShopQuotationDetailModel(
                success: false, message: apiResponse.message, quotation: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return ShopQuotationDetailModel(
              success: false, message: apiResponse.message, quotation: null);
        } else {
          return ShopQuotationDetailModel(
              success: false, message: apiResponse.message, quotation: null);
        }
      }
    } catch (error) {
      debugPrint("vcarez the error is $error");
      return ShopQuotationDetailModel(
          success: false, message: apiResponse.message, quotation: null);
    }
  }

  Future<MyOrderListModel> saveMyOrderList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.saveMyOrderList}",
        headers: auth,
        queryParams: requestBody);

    try {
      // if (apiResponse.responseCode == 403) {
      //   return QuotationReceivedListModel(
      //       success: false, message: apiResponse.message, quotations: null);
      // }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                MyOrderListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return MyOrderListModel(
                  success: false,
                  message: apiResponse.message,
                  newOrders: null,
                  pastOrders: null);
            } else {
              return MyOrderListModel(
                  success: false,
                  message: apiResponse.message,
                  newOrders: null,
                  pastOrders: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return MyOrderListModel(
                success: false,
                message: apiResponse.message,
                newOrders: null,
                pastOrders: null);
          } else {
            return MyOrderListModel(
                success: false,
                message: apiResponse.message,
                newOrders: null,
                pastOrders: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return MyOrderListModel(
              success: false,
              message: apiResponse.message,
              newOrders: null,
              pastOrders: null);
        } else {
          return MyOrderListModel(
              success: false,
              message: apiResponse.message,
              newOrders: null,
              pastOrders: null);
        }
      }
    } catch (error) {
      return MyOrderListModel(
          success: false,
          message: apiResponse.message,
          newOrders: null,
          pastOrders: null);
    }
  }

  Future<MyOrderListModel> getMyOrderList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.getMyOrderList}",
        headers: auth,
        queryParams: requestBody);

    try {
      // if (apiResponse.responseCode == 403) {
      //   return QuotationReceivedListModel(
      //       success: false, message: apiResponse.message, quotations: null);
      // }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                MyOrderListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return MyOrderListModel(
                  success: false,
                  message: apiResponse.message,
                  newOrders: null,
                  pastOrders: null);
            } else {
              return MyOrderListModel(
                  success: false,
                  message: apiResponse.message,
                  newOrders: null,
                  pastOrders: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return MyOrderListModel(
                success: false,
                message: apiResponse.message,
                newOrders: null,
                pastOrders: null);
          } else {
            return MyOrderListModel(
                success: false,
                message: apiResponse.message,
                newOrders: null,
                pastOrders: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return MyOrderListModel(
              success: false,
              message: apiResponse.message,
              newOrders: null,
              pastOrders: null);
        } else {
          return MyOrderListModel(
              success: false,
              message: apiResponse.message,
              newOrders: null,
              pastOrders: null);
        }
      }
    } catch (error) {
      return MyOrderListModel(
          success: false,
          message: apiResponse.message,
          newOrders: null,
          pastOrders: null);
    }
  }

  Future<QuotationHistoryListModel> getQuotationHistoryList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.getQuotationHistoryList}",
        headers: auth,
        queryParams: requestBody);

    try {
      // if (apiResponse.responseCode == 403) {
      //   return QuotationReceivedListModel(
      //       success: false, message: apiResponse.message, quotations: null);
      // }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                QuotationHistoryListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return QuotationHistoryListModel(
                  success: false,
                  message: apiResponse.message,
                  quotations: null);
            } else {
              return QuotationHistoryListModel(
                  success: false,
                  message: apiResponse.message,
                  quotations: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return QuotationHistoryListModel(
                success: false, message: apiResponse.message, quotations: null);
          } else {
            return QuotationHistoryListModel(
                success: false, message: apiResponse.message, quotations: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return QuotationHistoryListModel(
              success: false, message: apiResponse.message, quotations: null);
        } else {
          return QuotationHistoryListModel(
              success: false, message: apiResponse.message, quotations: null);
        }
      }
    } catch (error) {
      debugPrint(
          "vcarez the error is QuotationHistoryListModel $error");
      return QuotationHistoryListModel(
          success: false, message: apiResponse.message, quotations: null);
    }
  }

  Future<QuotationReceivedListModel> getQuotationHistoryDetail(
      String userToken, String strOrderID,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.getQuotationHistoryDetailList}/$strOrderID",
        headers: auth,
        queryParams: requestBody);

    try {
      // if (apiResponse.responseCode == 403) {
      //   return QuotationReceivedListModel(
      //       success: false, message: apiResponse.message, quotations: null);
      // }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                QuotationReceivedListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return QuotationReceivedListModel(
                  success: false,
                  message: apiResponse.message,
                  quotations: null);
            } else {
              return QuotationReceivedListModel(
                  success: false,
                  message: apiResponse.message,
                  quotations: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return QuotationReceivedListModel(
                success: false, message: apiResponse.message, quotations: null);
          } else {
            return QuotationReceivedListModel(
                success: false, message: apiResponse.message, quotations: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return QuotationReceivedListModel(
              success: false, message: apiResponse.message, quotations: null);
        } else {
          return QuotationReceivedListModel(
              success: false, message: apiResponse.message, quotations: null);
        }
      }
    } catch (error) {
      return QuotationReceivedListModel(
          success: false, message: apiResponse.message, quotations: null);
    }
  }

  Future<CartListModel> getCartList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.getCartList}",
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return CartListModel(
            success: false, message: apiResponse.message, cartItems: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                CartListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return CartListModel(
                  success: false,
                  message: apiResponse.message,
                  cartItems: null);
            } else {
              return CartListModel(
                  success: false,
                  message: apiResponse.message,
                  cartItems: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return CartListModel(
                success: false, message: apiResponse.message, cartItems: null);
          } else {
            return CartListModel(
                success: false, message: apiResponse.message, cartItems: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return CartListModel(
              success: false, message: apiResponse.message, cartItems: null);
        } else {
          return CartListModel(
              success: false, message: apiResponse.message, cartItems: null);
        }
      }
    } catch (error) {
      return CartListModel(
          success: false, message: apiResponse.message, cartItems: null);
    }
  }

  Future<CategoryProductListModel> getCategoryMedicineList(
      String userToken, String strCategoryID,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.getCategoryMedicineList}/$strCategoryID",
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return CategoryProductListModel(
            success: false, message: apiResponse.message, categories: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                CategoryProductListModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return CategoryProductListModel(
                  success: false,
                  message: apiResponse.message,
                  categories: null);
            } else {
              return CategoryProductListModel(
                  success: false,
                  message: apiResponse.message,
                  categories: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return CategoryProductListModel(
                success: false, message: apiResponse.message, categories: null);
          } else {
            return CategoryProductListModel(
                success: false, message: apiResponse.message, categories: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return CategoryProductListModel(
              success: false, message: apiResponse.message, categories: null);
        } else {
          return CategoryProductListModel(
              success: false, message: apiResponse.message, categories: null);
        }
      }
    } catch (error) {
      return CategoryProductListModel(
          success: false, message: apiResponse.message, categories: null);
    }
  }

  Future<MedicineDetailModel> getMedicineDetail(
      String userToken, String strID, String strType,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        "${ApiEndpoint.getMedicineDetail}$strID?type=$strType",
        headers: auth,
        queryParams: requestBody);

    try {
      debugPrint(
          "vcarez vendor getMedicineDetail apiResponse.responseCode is ${apiResponse.responseCode}");
      if (apiResponse.responseCode == 403) {
        return MedicineDetailModel(
            success: false, message: apiResponse.message, medicine: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                MedicineDetailModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return MedicineDetailModel(
                  success: false, message: apiResponse.message, medicine: null);
            } else {
              return MedicineDetailModel(
                  success: false, message: apiResponse.message, medicine: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return MedicineDetailModel(
                success: false, message: apiResponse.message, medicine: null);
          } else {
            return MedicineDetailModel(
                success: false, message: apiResponse.message, medicine: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return MedicineDetailModel(
              success: false, message: apiResponse.message, medicine: null);
        } else {
          return MedicineDetailModel(
              success: false, message: apiResponse.message, medicine: null);
        }
      }
    } catch (error) {
      return MedicineDetailModel(
          success: false, message: error.toString(), medicine: null);
    }
  }

  Future<TrendingMedicineModel> getTrendingMedicineList(String userToken,
      {Map<String, String>? requestBody}) async {
    var auth = {"Authorization": 'Bearer $userToken'};

    ApiResponse apiResponse = await apiHitter.getApiResponse(
        ApiEndpoint.getTrendingMedicineList,
        headers: auth,
        queryParams: requestBody);

    try {
      if (apiResponse.responseCode == 403) {
        return TrendingMedicineModel(
            success: false, message: apiResponse.message, medicines: null);
      }
      if (apiResponse.success) {
        if (apiResponse.response != null) {
          if (apiResponse.response!.data != null) {
            final passEntity =
                TrendingMedicineModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            if (apiResponse.responseCode == 403) {
              return TrendingMedicineModel(
                  success: false,
                  message: apiResponse.message,
                  medicines: null);
            } else {
              return TrendingMedicineModel(
                  success: false,
                  message: apiResponse.message,
                  medicines: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return TrendingMedicineModel(
                success: false, message: apiResponse.message, medicines: null);
          } else {
            return TrendingMedicineModel(
                success: false, message: apiResponse.message, medicines: null);
          }
        }
      } else {
        if (apiResponse.responseCode == 403) {
          return TrendingMedicineModel(
              success: false, message: apiResponse.message, medicines: null);
        } else {
          return TrendingMedicineModel(
              success: false, message: apiResponse.message, medicines: null);
        }
      }
    } catch (error) {
      return TrendingMedicineModel(
          success: false, message: apiResponse.message, medicines: null);
    }
  }

  Future<dynamic> userSignUp(FormData? formData) async {
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.userRegister,
        postFormData: formData,
        isFormData: true);
    {
      try {
        debugPrint("vcarez the try first is${apiResponse.message}");
        if (apiResponse.success) {
          if (apiResponse != null) {
            final passEntity = SignupModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            return SignupModel(
                message: apiResponse.message, success: apiResponse.success);
          }
        } else {
          return SignupModel(
              message: apiResponse.message, success: apiResponse.success);
        }
      } catch (error) {
        debugPrint("vcarez the register error is $apiResponse");
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> userUploadPrescription(
      String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.uploadPrescription,
        headers: auth,
        data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");
          final passEntity =
              UploadPrescriptionModel.fromJson(apiResponse.response!.data);
          return passEntity;

          // return ApiResponse(true,
          //     responseCode: apiResponse.responseCode,
          //     message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> userUploadImagePrescription(
      String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.updatePrescription,
        headers: auth,
        isFormData: true,
        postFormData: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: 200,
              message: apiResponse.response!.data['message']);
          final passEntity =
              UploadPrescriptionModel.fromJson(apiResponse.response!.data);
          // return passEntity;

          // return ApiResponse(true,
          //     responseCode: apiResponse.responseCode,
          //     message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> updateAddress(
      String userToken, var loginFormData, String? strAddressID) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPutApiJson(
        "${ApiEndpoint.saveAddress}/$strAddressID",
        headers: auth,
        data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: apiResponse.responseCode,
              message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> buySubscription(String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.buySubscription,
        headers: auth,
        data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          if (apiResponse != null) {
            if (apiResponse.response!.data != null) {
              final passEntity =
                  BuyPlanSuccessModel.fromJson(apiResponse.response!.data);
              return passEntity;
            } else {
              return BuyPlanSuccessModel(
                  message: apiResponse.message, success: false);
            }
          } else {
            return BuyPlanSuccessModel(
                message: apiResponse.message, success: apiResponse.success);
          }
        } else {
          return BuyPlanSuccessModel(
              message: apiResponse.message, success: apiResponse.success);
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return BuyPlanSuccessModel(
            success: false, membership: null, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> saveAddress(String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.saveAddress,
        headers: auth,
        data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: apiResponse.responseCode,
              message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<CreateOrderModel> createOrderSession(
      String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.createOrderSession,
        headers: auth,
        data: loginFormData);
    {
      try {
        debugPrint(
            "vcarez vendor getMedicineDetail apiResponse.responseCode is ${apiResponse.responseCode}");
        if (apiResponse.responseCode == 403) {
          return CreateOrderModel(
              success: false, message: apiResponse.message, data: null);
        }
        if (apiResponse.success) {
          if (apiResponse.response != null) {
            if (apiResponse.response!.data != null) {
              final passEntity =
                  CreateOrderModel.fromJson(apiResponse.response!.data);
              return passEntity;
            } else {
              if (apiResponse.responseCode == 403) {
                return CreateOrderModel(
                    success: false, message: apiResponse.message, data: null);
              } else {
                return CreateOrderModel(
                    success: false, message: apiResponse.message, data: null);
              }
            }
          } else {
            if (apiResponse.responseCode == 403) {
              return CreateOrderModel(
                  success: false, message: apiResponse.message, data: null);
            } else {
              return CreateOrderModel(
                  success: false, message: apiResponse.message, data: null);
            }
          }
        } else {
          if (apiResponse.responseCode == 403) {
            return CreateOrderModel(
                success: false, message: apiResponse.message, data: null);
          } else {
            return CreateOrderModel(
                success: false, message: apiResponse.message, data: null);
          }
        }
      } catch (error) {
        return CreateOrderModel(
            success: false, message: error.toString(), data: null);
      }
    }
  }

  Future<dynamic> userUpdateProfile(String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.updateProfile,
        headers: auth,
        data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: apiResponse.responseCode,
              message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> placeOrderFromCart(
      String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
      "${ApiEndpoint.placeOrder}",
      headers: auth,
      data: loginFormData,
    );
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: apiResponse.responseCode,
              message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> deleteAddress(String userToken, String strAddressID) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getDeleteApi(
      "${ApiEndpoint.deleteAddress}/$strAddressID",
      headers: auth,
    );
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: apiResponse.responseCode,
              message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> updateCart(
      String userToken, String strCartID, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.postApiWithQueryParam(
      "${ApiEndpoint.addToCart}/$strCartID",
      headers: auth,
      data: loginFormData,
    );
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: apiResponse.responseCode,
              message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> addToCart(String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.addToCart,
        headers: auth,
        data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: apiResponse.responseCode,
              message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> acceptQuote(String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.acceptQuote,
        headers: auth,
        data: loginFormData);
    {
      try {
        if (apiResponse.success) {
          debugPrint("vcarez the try first is${apiResponse.response!.data}");

          return ApiResponse(true,
              responseCode: apiResponse.responseCode,
              message: apiResponse.response!.data['message']);
        } else {
          return apiResponse;
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return ApiResponse(false,
            responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> verifyCFOrder(String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
        ApiEndpoint.verifyCFOrderID,
        headers: auth,
        isFormData: true,
        postFormData: loginFormData);
    {
      try {
        debugPrint("vcarez the try first is${apiResponse.message}");
        if (apiResponse.success) {
          if (apiResponse != null) {
            final passEntity =
                VerifyCFModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            return VerifyCFModel(
                message: apiResponse.message, success: apiResponse.success);
          }
        } else {
          return VerifyCFModel(
              message: apiResponse.message, success: apiResponse.success);
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return VerifyCFModel(message: apiResponse.message, success: false);
        // return VerifyCFModel(false,
        //     responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }

  Future<dynamic> acceptSaveOrder(String userToken, var loginFormData) async {
    initConnectivity();
    var auth = {"Authorization": 'Bearer $userToken'};
    debugPrint("vcarez the internet is ${_connectionStatus.name}");
    ApiResponse apiResponse = await apiHitter.getPostApiResponse(
      ApiEndpoint.saveOrderAccept,
      headers: auth,
      data: loginFormData,
    );
    {
      try {
        debugPrint("vcarez the try first is${apiResponse.message}");
        if (apiResponse.success) {
          if (apiResponse != null) {
            final passEntity =
                OrderAcceptSuccessModel.fromJson(apiResponse.response!.data);
            return passEntity;
          } else {
            return OrderAcceptSuccessModel(
                message: apiResponse.message, success: apiResponse.success);
          }
        } else {
          return OrderAcceptSuccessModel(
              message: apiResponse.message, success: apiResponse.success);
        }
      } catch (error) {
        debugPrint("vcarez the error is $apiResponse");
        return OrderAcceptSuccessModel(
            message: apiResponse.message, success: false);
        // return VerifyCFModel(false,
        //     responseCode: 301, message: apiResponse.message);
        // return LoginModel(
        //     token: apiResponse.toString(), success: false);
      }
    }
  }
}
