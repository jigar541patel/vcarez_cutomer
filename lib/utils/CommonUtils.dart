import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:vcarez_new/utils/colors_utils.dart';

import '../components/color_loader.dart';
import '../components/my_theme_button.dart';
import '../components/standard_regular_text.dart';
import '../ui/cart/model/cart_list_model.dart';
import 'SizeConfig.dart';
import 'images_utils.dart';

class CommonUtils {
  static final CommonUtils utils = CommonUtils._internal();
  static var userToken = "";
  static CartListModel cartListModel = CartListModel();

  factory CommonUtils() {
    return utils;
  }

  CommonUtils._internal();

  // handleApiError(int code, String message) {
  //   switch (code) {
  //     case 301:
  //       Get.to(() => ErrorScreen(
  //             buttonText: backText,
  //             imageAssets: noConnectionError,
  //             onPressed: () => Get.back(),
  //           ));
  //       break;
  //
  //     case 400:
  //       ShowAlertDialog().showAppDialog(
  //         title: error,
  //         message: /*message*/ 'Something Wen\'t Wrong!',
  //         confirmColor: colorPrimary,
  //         image: warningError,
  //         cancelColor: Colors.grey.shade50,
  //         confirmText: ok,
  //         isCancel: false,
  //         onConfirm: () {
  //           Get.back();
  //         },
  //       );
  //       break;
  //
  //     case 500:
  //       {
  //         Get.to(
  //           () => ErrorScreen(
  //             imageAssets: errorImg,
  //             buttonText: backText,
  //             onPressed: () {
  //               Get.back();
  //             },
  //           ),
  //         );
  //       }
  //       break;
  //
  //     default:
  //       {
  //         ShowAlertDialog().showAppDialog(
  //           title: error,
  //           message: /* message*/ 'Something Wen\'t Wrong!',
  //           confirmColor: colorPrimary,
  //           image: warningError,
  //           cancelColor: Colors.grey.shade50,
  //           confirmText: ok,
  //           isCancel: false,
  //           onConfirm: () {
  //             Get.back();
  //           },
  //         );
  //       }
  //       break;
  //   }
  // }

  // CartListModel cartList()
  // {
  //   return cartListModel;
  // }
  showToast(String strMsg, {Color? backgroundColor, Color? textColor}) {
    Fluttertoast.showToast(
        msg: strMsg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: backgroundColor ?? negativeButtonColor,
        textColor: textColor ?? whiteColor,
        fontSize: 16.0);
  }

  // Future<String> getUserToken() async {
  //   if (userToken.isNotEmpty)
  //     return userToken;
  //   else {
  //     final storage = GetStorage();
  //     userToken = await storage.read(userToken);
  //     return userToken;
  //   }
  // }

  Future<void> copyToClipboard(String text, var key) async {
    await Clipboard.setData(ClipboardData(text: text));
    key.currentState.showSnackBar(const SnackBar(
      content: Text('Copied to clipboard'),
    ));
  }

  // launchWebSiteUrl(String webUrl) async {
  //   var url = webUrl;
  //   if (await canLaunchUrl(Uri.parse(url))) {
  //     await launchUrl(Uri.parse(url));
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }

  static Widget NoDataFoundPlaceholder(BuildContext context,
      {String? message, String? strAssetImage, double? doubleHeight}) {
    return SizedBox(
        height: doubleHeight ?? MediaQuery.of(context).size.height * .65,
        child: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            strAssetImage != null
                ? Image(
                    image: AssetImage(strAssetImage),
                    height: 50,
                  )
                : const SizedBox(),
            const SizedBox(
              height: 10,
            ),
            message != null
                ? Text(message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 15,
                        color: textColor,
                        fontWeight: FontWeight.w500))
                : const Text("No Data Found",
                    style: TextStyle(
                        fontSize: 15,
                        color: textColor,
                        fontWeight: FontWeight.w500)),
          ],
        )));
  }

  String? getDeviceType() {
    return Platform.isAndroid ? 'android' : 'ios';
  }

  // redirectToHome() async {
  //   Get.offAll(() => HomeScreenNew());
  //   await Future.delayed(Duration(seconds: 1), () => playAudio('booking4.mp3'));
  // }

  // redirectToPreviousScreen() {
  //   Get.back();
  // }

  // ServiceDuration convertDuration(String serviceTime) {
  //   var duration;
  //   var serviceDuration = ServiceDuration();
  //   if (serviceTime.contains(" ")) {
  //     var durationArray = serviceTime.split(" ");
  //     if (durationArray[1].isAlphabetOnly) {
  //       duration = int.parse(durationArray[0]);
  //       serviceDuration.min = duration;
  //       serviceDuration.hour = 0;
  //     } else {
  //       var hours = int.parse(
  //               durationArray[0].substring(0, durationArray[0].length - 1)) *
  //           60;
  //       var min = int.parse(
  //           durationArray[1].substring(0, durationArray[1].length - 3));
  //       duration = (hours + min);
  //       serviceDuration.min = min;
  //       serviceDuration.hour = (hours ~/ 60);
  //     }
  //   } else {
  //     // ignore: unnecessary_null_comparison
  //     if (serviceTime != null) {
  //       duration =
  //           int.parse(serviceTime.substring(0, serviceTime.length - 1)) * 60;
  //       serviceDuration.min = 0;
  //       serviceDuration.hour = (duration ~/ 60);
  //     }
  //   }
  //   return serviceDuration;
  // }

  double roundOffDouble(double val) {
    num mod = pow(10.0, 1);
    return ((val * mod).round().toDouble() / mod);
  }

  String setProfileImage(String s, String? gender) {
    var profileImage = '';
    return profileImage;
  }

  // String setDefaultUserImage(String? gender) {
  //   var defaultImage = "";
  //   if (gender != null) {
  //     if (gender.isNotEmpty) {
  //       defaultImage =
  //           gender.toLowerCase() == 'male' ? defaultMale : defaultFemale;
  //     } else
  //       defaultImage = defaultMale;
  //   } else
  //     defaultImage = defaultMale;
  //   return defaultImage;
  // }

  hexToColor(String colorString) {
    var color = int.parse(colorString.replaceAll('#', '0xFF'));
    return Color(color);
  }

  maskEmailString(String value) {
    return value.replaceAll(RegExp(r'(?<=.{3}).(?=.*@)'), '*');
  }

  maskNumberString(String value) {
    return value.replaceAll(RegExp(r'(?<=.{3}).(?=.[0-9])'), '*');
  }

  // updateAppointment(BookingFlowModal bookingFlowModal) async {
  //   var dataList = [];
  //   dataList.add(bookingFlowModal);
  //   var requestBody = {
  //     "ios": bookingFlowModal,
  //   };
  //
  //   var responseModel = await ApiController().updateAppointment(
  //       GlobalVariables.userToken,
  //       bookingFlowModal.id!,
  //       json.encode(requestBody));
  //   return responseModel;
  // }

  void hideKeyBoard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }

  onInternetError() async {
    await Future.delayed(
      const Duration(seconds: 5),
      () => ColorLoader(),
    );

    // showCustomNoInternetDialog(context);
    // ShowAlertDialog().showAppDialog(
    //     title: 'Connection Error',
    //     message:
    //         'No Internet Connection.\nCheck your Wi-Fi connection\nand try again.',
    //     confirmText: 'Continue',
    //     confirmColor: darkSkyBluePrimaryColor,
    //     image: warningError,
    //     isCancel: false,
    //     onConfirm: () {
    //       // CommonUtils.utils.redirectToHome();
    //     });
  }

  void showCustomNoInternetDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
              color: Colors.transparent,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: SizeConfig.safeBlockVertical! * 30,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(
                      SizeConfig.safeBlockVertical! * 2.0,
                      SizeConfig.safeBlockVertical! * 2.0,
                      SizeConfig.safeBlockVertical! * 2.0,
                      0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(10, 0, 0, 10),
                        child: StandardCustomText(
                          label: 'FAQ for rejected order',
                          align: TextAlign.start,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, left: 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.radio_button_checked_rounded,
                                  color: Color(0xFF00AAFF),
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                StandardCustomText(
                                  label: 'Address is too far.',
                                  fontWeight: FontWeight.bold,
                                  color: descriptionTextColor,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: SizeConfig.safeBlockVertical! * 1.0,
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: const [
                                Icon(
                                  Icons.radio_button_off_rounded,
                                  color: Color(0xFF8A8F9C),
                                  size: 24,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                StandardCustomText(
                                  label: 'I don’t have particular reason.',
                                  fontWeight: FontWeight.bold,
                                  color: descriptionTextColor,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 3.0,
                      ),
                      Center(
                        child: SizedBox(
                          width: SizeConfig.safeBlockHorizontal! * 40.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: MyThemeButton(
                              fontSize: 12,
                              buttonText: 'Submit',
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: SizeConfig.safeBlockVertical! * 1.0,
                      ),
                    ],
                  ),
                ),
              )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }
}
