import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/profile/view/edit_profile_screen.dart';
import 'package:vcarez_new/ui/privilegeplan/view/privilage_plan_screen.dart';
import 'package:vcarez_new/ui/medicine_list/view/medicine_list_screen.dart';
import 'package:vcarez_new/ui/privacy_policy_screen.dart';
import 'package:vcarez_new/ui/shopquotationdetail/view/shop_detail_screen.dart';
import 'package:vcarez_new/ui/signup/view/signup_screen.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../components/custom_snack_bar.dart';
import '../../../components/my_form_field.dart';
import '../../../components/my_theme_button.dart';
import '../../../utils/SizeConfig.dart';
import '../../../utils/strings.dart';
import '../../my_prescription/view/my_prescription_screen.dart';
import '../../myprofile/view/my_profile_screen.dart';
import '../../orderconfirm/view/order_confirmation_screen.dart';
import '../bloc/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userEmailController;
  late TextEditingController _userOTPController;
  late TextEditingController _userPasswordController;
  late TextEditingController _userConfirmPasswordController;
  late ForgotPasswordBloc forgotPasswordBloc;

  void initController() {
    _userEmailController = TextEditingController();
    _userPasswordController = TextEditingController();
    _userConfirmPasswordController = TextEditingController();
    _userOTPController = TextEditingController();
    // _userEmailController.text = "jigartest2@gmail.com";
    // _userOTPController.text = "1234";
    // _userPasswordController.text = "jigar124";
    // _userConfirmPasswordController.text = "jigar24";
  }

  void disposeController() {
    _userEmailController.dispose();
  }

  @override
  void initState() {
    forgotPasswordBloc = BlocProvider.of<ForgotPasswordBloc>(context);
    initController();

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeController();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget imageAppLogo() => SvgPicture.asset(
          appLogo_,
          height: 18.0,
          width: 116.0,
        );
    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .12,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(loginBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 8.0,
                    ),
                    InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back_ios,
                          color: whiteColor,
                        )),
                    imageAppLogo(),
                  ],
                ),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .11,
            ),
            height: MediaQuery.of(context).size.height * .90,
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(0.0)),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 16.0, right: 16, bottom: 100),
                  child: Form(
                    key: _formKey,
                    child:
                        BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                      listener: (context, state) {
                        // TODO: implement listener
                        if (state is OTPVerifiedValidCompletedState) {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            Navigator.of(context).maybePop();
                          });
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const StandardCustomText(
                              label: forgotPassword,
                              fontWeight: FontWeight.bold,
                              color: darkSkyBluePrimaryColor,
                              fontSize: 24.0,
                            ),
                            const SizedBox(
                              height: 8.0,
                            ),
                            const StandardCustomText(
                              fontSize: 12,
                              label: forgotPasswordSubtitle,
                              color: descriptionTextColor,
                              maxlines: 2,
                            ),
                            state is OTPSendSuccessState
                                ? Column(
                                    children: [
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 30.0),
                                        child: CustomFormField(
                                          controller: _userPasswordController,
                                          labelText: lblNewPassword,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return usernameError;
                                            }
                                            return null;
                                          },
                                          isRequire: true,
                                          isObscureText: true,
                                          textInputAction: TextInputAction.next,
                                          textInputType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 30.0),
                                        child: CustomFormField(
                                          controller:
                                              _userConfirmPasswordController,
                                          labelText: lblConfirmPassword,
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return usernameError;
                                            }
                                            return null;
                                          },
                                          isRequire: true,
                                          isObscureText: true,
                                          textInputAction: TextInputAction.next,
                                          textInputType:
                                              TextInputType.emailAddress,
                                        ),
                                      ),
                                      Container(
                                        margin:
                                            const EdgeInsets.only(top: 30.0),
                                        child: CustomFormField(
                                          controller: _userOTPController,
                                          labelText: 'Please enter OTP*',
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return usernameError;
                                            }
                                            return null;
                                          },
                                          isRequire: true,
                                          textInputAction: TextInputAction.next,
                                          textInputType: TextInputType.number,
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(
                                    margin: const EdgeInsets.only(top: 30.0),
                                    child: CustomFormField(
                                      controller: _userEmailController,
                                      labelText:
                                          'Enter Email or Mobile Number*',
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return usernameError;
                                        }
                                        return null;
                                      },
                                      isRequire: true,
                                      textInputAction: TextInputAction.next,
                                      textInputType: TextInputType.emailAddress,
                                    ),
                                  ),
                            Container(
                                margin: const EdgeInsets.only(top: 24.0),
                                child: Container(
                                    margin: const EdgeInsets.only(top: 24.0),
                                    child: MaterialButton(
                                        onPressed: () async {
                                          FocusScope.of(context)
                                              .requestFocus(FocusNode());
                                          if (_formKey.currentState!
                                              .validate()) {
                                            var connectivityResult =
                                                await (Connectivity()
                                                    .checkConnectivity());
                                            if (connectivityResult ==
                                                    ConnectivityResult.mobile ||
                                                connectivityResult ==
                                                    ConnectivityResult.wifi) {
                                              state is OTPSendSuccessState
                                                  ? onVerifyButtonClicked()
                                                  : onGetOTPButtonClicked();
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                      createMessageSnackBar(
                                                          errorNoInternet));
                                            }
                                          }
                                        },
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        padding: const EdgeInsets.fromLTRB(
                                            0.0, 15.0, 0.0, 15.0),
                                        color: darkSkyBluePrimaryColor,
                                        splashColor:
                                            Theme.of(context).primaryColor,
                                        disabledColor:
                                            Theme.of(context).disabledColor,
                                        child: SizedBox(
                                          width: double.infinity,
                                          height:
                                              SizeConfig.blockSizeVertical! *
                                                  2.7,
                                          child: Center(
                                            child: (state
                                                    is AddingDataInProgressState)
                                                ? SizedBox(
                                                    width: SizeConfig
                                                            .blockSizeHorizontal! *
                                                        5.5,
                                                    child: const CircularProgressIndicator(
                                                        //color: darkSkyBluePrimaryColor,
                                                        ),
                                                  )
                                                : state is OTPSendSuccessState
                                                    ? const Text(verifyOtp,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: whiteColor,
                                                        ))
                                                    : const Text(
                                                        sendOtp,
                                                        style: TextStyle(
                                                          fontSize: 16,
                                                          color: whiteColor,
                                                        ),
                                                      ),
                                          ),
                                        )))
                                // },
                                ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  void onGetOTPButtonClicked() {
    forgotPasswordBloc.add(DataSubmittedEvent(_userEmailController.text));
  }

  void onVerifyButtonClicked() {
    if (_userPasswordController.text == _userConfirmPasswordController.text) {
      forgotPasswordBloc.add(OtpSubmittedEvent(
        _userEmailController.text,
        _userPasswordController.text,
        _userOTPController.text,
      ));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(createMessageSnackBar(lblPasswordConfirmPassError));
    }
  }
}
