import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/ui/signup/bloc/signup_bloc.dart';
import 'package:vcarez_new/utils/SizeConfig.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../components/color_loader.dart';
import '../../../components/custom_snack_bar.dart';
import '../../../components/my_form_field.dart';
import '../../../components/standard_regular_text.dart';
import '../../../components/my_theme_button.dart';
import '../../../utils/images_utils.dart';
import '../../../utils/strings.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState1();
}

class _SignupScreenState1 extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _userNameController,
      _phoneController,
      _emailController,
      _locationController,
      _passwordController;
  bool passwordVisible = true;
  late SignupBloc signupBloc;

  void initController() {
    signupBloc = BlocProvider.of<SignupBloc>(context);
    _userNameController = TextEditingController();
    _passwordController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _locationController = TextEditingController();
  }

  void disposeController() {
    _userNameController.dispose();
    _passwordController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    initController();
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   disposeController();
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget imageAppLogo() => SvgPicture.asset(
          appLogo_,
          height: 40,
          width: 180,
        );

    return Scaffold(
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .25,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(loginBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: imageAppLogo(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .23,
            ),
            height: MediaQuery.of(context).size.height * .75,
            decoration: const BoxDecoration(
              color: whiteColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(15.0),
                  bottomLeft: Radius.circular(0.0)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const StandardCustomText(
                        label: signup,
                        fontWeight: FontWeight.bold,
                        color: darkSkyBluePrimaryColor,
                        fontSize: 30.0,
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const StandardCustomText(
                        label: signupSubtitle,
                        color: descriptionTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 50.0),
                        child: BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            return CustomFormField(
                              controller: _userNameController,
                              labelText: name,
                              maxLength: 25,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp("[a-zA-Z ]"))
                              ],

                              isEnable: state is AddingDataInProgressState
                                  ? false
                                  : true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return nameError;
                                }
                                return null;
                              },
                              icon: usernameIcon,
                              isRequire: true,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.emailAddress,
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        child: BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            return CustomFormField(
                              controller: _phoneController,
                              labelText: phone,
                              maxLength: 10,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                              ],
                              validator: (value) {
                                if (value == null ||
                                    value.isEmpty ||
                                    value.toString().length != 10 ||
                                    !isNumeric(value.toString())) {
                                  return phoneError;
                                }
                                return null;
                              },
                              isEnable: state is AddingDataInProgressState
                                  ? false
                                  : true,
                              icon: phoneIcon,
                              isRequire: true,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.phone,
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        child: BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            return CustomFormField(
                              controller: _emailController,
                              labelText: email,
                              validator: (value) {
                                if (value == null ||
                                    value.toString().trim().isEmpty ||
                                    !EmailValidator.validate(value)) {
                                  return emailError;
                                }
                                return null;
                              },

                              isEnable: state is AddingDataInProgressState
                                  ? false
                                  : true,
                              icon: emailIcon,
                              isRequire: true,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.emailAddress,
                            );
                          },
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        child: BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            return CustomFormField(
                              controller: _passwordController,
                              labelText: password,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return passwordError;
                                }
                                return null;
                              },
                              isEnable: state is AddingDataInProgressState
                                  ? false
                                  : true,
                              icon: passwordIcon,
                              isSuffixIconDisplay: true,
                              suffixIconWidget: IconButton(
                                icon: Icon(
                                  // Based on passwordVisible state choose the icon
                                  passwordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: darkSkyBluePrimaryColor,
                                ),
                                onPressed: () {
                                  setState(() {
                                    if (passwordVisible) {
                                      passwordVisible = false;
                                    } else {
                                      passwordVisible = true;
                                    }
                                  });
                                },
                              ),
                              isObscureText: passwordVisible,
                              isRequire: true,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.text,
                            );
                          },
                        ),
                      ),
                     Visibility(
                         visible: false,
                         child:  Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        child: BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            return CustomFormField(
                              controller: _locationController,
                              labelText: location,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return locationError;
                                }
                                return null;
                              },
                              isEnable: state is AddingDataInProgressState
                                  ? false
                                  : true,
                              icon: locationIcon,
                              isRequire: true,
                              textInputAction: TextInputAction.next,
                              textInputType: TextInputType.text,
                            );
                          },
                        ),
                      )),
                      Container(
                        margin: const EdgeInsets.only(top: 24.0),
                        child: BlocBuilder<SignupBloc, SignupState>(
                          builder: (context, state) {
                            if (state is AddingDataValidCompletedState) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.pushReplacementNamed(
                                    context, routeDashboard);
                                // Navigator.of(context).maybePop();
                              });
                            }
                            return MaterialButton(
                                onPressed: () async {
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());

                                  if (_formKey.currentState!.validate()) {
                                    var connectivityResult =
                                        await (Connectivity()
                                            .checkConnectivity());
                                    if (connectivityResult ==
                                            ConnectivityResult.mobile ||
                                        connectivityResult ==
                                            ConnectivityResult.wifi) {
                                      onSignupButtonClicked();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(createMessageSnackBar(
                                              errorNoInternet));
                                    }
                                  }
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15)),
                                padding: const EdgeInsets.fromLTRB(
                                    0.0, 15.0, 0.0, 15.0),
                                color: darkSkyBluePrimaryColor,
                                splashColor: Theme.of(context).primaryColor,
                                disabledColor: Theme.of(context).disabledColor,
                                child: SizedBox(
                                  width: double.infinity,
                                  height: SizeConfig.blockSizeVertical! * 2.7,
                                  child: Center(
                                    child: (state is AddingDataInProgressState)
                                        ? SizedBox(
                                            width: SizeConfig
                                                    .blockSizeHorizontal! *
                                                5.5,
                                            child: const CircularProgressIndicator(
                                                //color: darkSkyBluePrimaryColor,
                                                ),
                                          )
                                        : const Text(
                                            signup,
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: whiteColor,
                                            ),
                                          ),
                                  ),
                                ));
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const StandardCustomText(
                                label: 'Already have an account? '),
                            GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const StandardCustomText(
                                  label: login,
                                  color: darkSkyBluePrimaryColor,
                                )),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }

  void onSignupButtonClicked() {
    signupBloc.add(SignupSubmittedEvent(
        _userNameController.text,
        _phoneController.text,
        _emailController.text,
        _passwordController.text,
        _locationController.text));
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
