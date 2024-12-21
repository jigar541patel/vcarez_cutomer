import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/components/custom_snack_bar.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/cubit/internet_cubit.dart';
import 'package:vcarez_new/ui/forgotpassword/view/forgot_password_screen.dart';
import 'package:vcarez_new/ui/login/bloc/login_bloc.dart';
import 'package:vcarez_new/ui/signup/view/signup_screen.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../components/my_form_field.dart';
import '../../../components/my_theme_button.dart';
import '../../../cubit/internet_cubit.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/SizeConfig.dart';
import '../../../utils/strings.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late LoginBloc loginBloc;

  bool passwordVisible = true;

  void initController() {
    loginBloc = BlocProvider.of<LoginBloc>(context);
    // _userNameController.text = "jigartest2@gmail.com";
    // _passwordController.text = "123457";

    // _userNameController = TextEditingController();
    // _passwordController = TextEditingController();
  }

  // void disposeController() {
  //   _userNameController.dispose();
  //   _passwordController.dispose();
  // }

  @override
  void initState() {
    initController();
    super.initState();
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
    // initController();
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
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(10.0),
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
                          label: login,
                          fontWeight: FontWeight.bold,
                          color: darkSkyBluePrimaryColor,
                          fontSize: 30.0,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        const StandardCustomText(
                          label: loginSubtitle,
                          color: descriptionTextColor,
                          fontWeight: FontWeight.bold,
                        ),
                        Align(
                            alignment: AlignmentDirectional.topStart,
                            child: BlocBuilder<LoginBloc, LoginState>(
                              builder: (context, state) {
                                if (state is LoginErrorState) {
                                  return state.errorMessage == usernameError
                                      ? Text(
                                          state.errorMessage,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        )
                                      : SizedBox();
                                } else {
                                  return const SizedBox();
                                }
                              },
                            )),
                        Container(
                          margin: const EdgeInsets.only(top: 50.0),
                          child: CustomFormField(
                            // onChanged: (val) {
                            //   BlocProvider.of<LoginBloc>(context).add(
                            //       LoginTextChangedEvent(_userNameController.text,
                            //           _passwordController.text));
                            // },
                            controller: _userNameController,
                            // inputFormatters: [
                            //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z0-9]"))
                            // ],
                            // labelText: email,
                            labelText: email + " / Mobile Number",
                            validator: (value) {
                              String patttern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
                              RegExp regExp = new RegExp(patttern);

                              if (value == null ||
                                  value.isEmpty ||
                                  value.length == 0) {
                                return phoneEmailError;
                              } else if (!regExp.hasMatch(value)) {
                                if (EmailValidator.validate(value) == false) {
                                  return phoneEmailError;
                                }
                                return null;
                              }
                              return null;
                            },
                            // validator: (value) {
                            //   if (value == null ||
                            //       value.isEmpty ||
                            //       EmailValidator.validate(value) == false) {
                            //     return emailError;
                            //   }
                            //   return null;
                            // },
                            icon: usernameIcon,
                            isRequire: true,
                            textInputAction: TextInputAction.next,
                            textInputType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        // Align(
                        //     alignment: AlignmentDirectional.topStart,
                        //     child: BlocBuilder<LoginBloc, LoginState>(
                        //       builder: (context, state) {
                        //         if (state is LoginErrorState) {
                        //           return state.errorMessage == passwordError
                        //               ? Text(
                        //                   state.errorMessage,
                        //                   style: const TextStyle(color: Colors.red),
                        //                 )
                        //               : const SizedBox();
                        //         } else {
                        //           return const SizedBox();
                        //         }
                        //       },
                        //     )),
                        CustomFormField(
                          // onChanged: (val) {
                          //   BlocProvider.of<LoginBloc>(context).add(
                          //       LoginTextChangedEvent(_userNameController.text,
                          //           _passwordController.text));
                          // },
                          controller: _passwordController,
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
                          labelText: password,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return passwordError;
                            }
                            return null;
                          },
                          icon: passwordIcon,
                          // suffixIcon: eye,
                          isRequire: true,
                          textInputAction: TextInputAction.next,
                          textInputType: TextInputType.text,
                        ),
                        const SizedBox(
                          height: 16.0,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, routeForgotPassword);
                            },
                            child: const StandardCustomText(
                              label: forgotPasswordQ,
                              style: TextStyle(
                                color: darkSkyBluePrimaryColor,
                                fontWeight: FontWeight.w900,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 24.0),
                          child: BlocBuilder<LoginBloc, LoginState>(
                            builder: (context, state) {
                              if (state is AddingDataValidCompletedState) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  Navigator.pushReplacementNamed(
                                      context, routeDashboard);
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
                                        onLoginButtonClicked();
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
                                  disabledColor:
                                      Theme.of(context).disabledColor,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: SizeConfig.blockSizeVertical! * 2.7,
                                    child: Center(
                                      child:
                                          (state is AddingDataInProgressState)
                                              ? SizedBox(
                                                  width: SizeConfig
                                                          .blockSizeHorizontal! *
                                                      5.5,
                                                  child: CircularProgressIndicator(
                                                      //color: darkSkyBluePrimaryColor,
                                                      ),
                                                )
                                              : Text(
                                                  login,
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
                                  label: 'Don\'t have an account? '),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, routeSignup);
                                  },
                                  child: const StandardCustomText(
                                    label: ' Sign up',
                                    fontWeight: FontWeight.bold,
                                    color: darkSkyBluePrimaryColor,
                                  )),
                            ],
                          ),
                        ),
                      ],
                    )),
              ),
            ),
          ),
        ],
      )),
    );
  }

  void onLoginButtonClicked() {
    loginBloc.add(LoginSubmittedEvent(
        _userNameController.text, _passwordController.text));
  }
}
