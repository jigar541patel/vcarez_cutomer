import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/profile/model/profile_model.dart';
import 'package:vcarez_new/ui/refer_earn_screen.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/custom_snack_bar.dart';
import '../../../components/my_form_field.dart';
import '../../../components/my_theme_button.dart';
import '../../../utils/SizeConfig.dart';
import '../../../utils/route_names.dart';
import '../../../utils/strings.dart';
import '../bloc/edit_profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _phoneController,
      _emailController,
      _locationController;

  EditProfileBloc editProfileBloc = EditProfileBloc();

  void initController() {
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
    _locationController = TextEditingController();
    _locationController.text = "surat";
    editProfileBloc.add(GetProfileEvent());
    WidgetsBinding.instance.addPostFrameCallback((_) async {

      context.read<CartProvider>().getData();

    });
  }

  void disposeController() {
    _phoneController.dispose();
    _emailController.dispose();
    _locationController.dispose();
  }

  @override
  void initState() {
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
            height: MediaQuery.of(context).size.height * .24,
            child: Container(
              padding: const EdgeInsets.only(bottom: 65.0, left: 16.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(loginBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  color: whiteColor,
                                ),
                              ),
                              imageAppLogo(),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(context, routeCartList);
                                },
                                // child: ChangeNotifierProvider(
                                //     create: (context) => CartListModel(),
                                child: Badge(
                                  badgeContent: Consumer<CartProvider>(
                                    builder: (context, value, child) {
                                      return Text(
                                        value.getCounter().toString(),
                                        // style: const TextStyle(
                                        //     color: Colors.white, fontWeight: FontWeight.bold),
                                      );
                                    },
                                  ),
                                  // badgeContent: Text(cartListModel.cartItems !=
                                  //         null
                                  //     ? cartListModel.cartItems!.length.toString()
                                  //     : "0"),
                                  position: BadgePosition.bottomEnd(),
                                  badgeColor: Colors.white,

                                  child: SvgPicture.asset(
                                    cartBadgeIcon,
                                    height: 25,
                                    width: 25,
                                    fit: BoxFit.none,
                                  ),
                                  // (Icons.shopping_cart),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 50),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: StandardCustomText(
                      label: editProfile,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          BlocProvider(
            create: (context) => editProfileBloc,
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .20,
              ),
              height: MediaQuery.of(context).size.height * .78,
              decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(0.0)),
              ),
              child: BlocConsumer<EditProfileBloc, EditProfileState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is DataLoaded) {
                    ProfileModel profileModel = state.profileModel;
                    _emailController.text = profileModel.user!.email!;
                    _phoneController.text = profileModel.user!.phone!;
                  }
                },
                builder: (context, state) {
                  return state is DataLoading
                      ? const Center(
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircularProgressIndicator(
                              color: darkSkyBluePrimaryColor,
                            ),
                          ),
                        )
                      : state is DataLoaded
                          ? bottomContent(profileModel: state.profileModel)
                          : bottomContent();
                },
              ),
            ),
          )
        ],
      )),
    );
  }

  Widget bottomContent({ProfileModel? profileModel}) {
    return Column(
      children: [
        SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 16, 25, 16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 24.0),
                    child: CustomFormField(
                      controller: _emailController,
                      labelText: email,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            EmailValidator.validate(value) == false) {
                          return emailError;
                        }
                        return null;
                      },
                      icon: emailIcon,
                      isRequire: true,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.emailAddress,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 24.0),
                    child: CustomFormField(
                      controller: _phoneController,
                      labelText: phone,
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            value.toString().length != 10 ||
                            !isNumeric(value.toString())) {
                          return phoneError;
                        }
                        return null;
                      },
                      icon: phoneIcon,
                      isRequire: true,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.phone,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 24.0),
                    child: CustomFormField(
                      controller: _locationController,
                      labelText: location,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return locationError;
                        }
                        return null;
                      },
                      icon: locationMarkerDarkIcon,
                      isRequire: true,
                      textInputAction: TextInputAction.next,
                      textInputType: TextInputType.text,
                    ),
                  ),
                  // Align(
                  //   alignment: AlignmentDirectional.bottomEnd,
                  //   child: Container(
                  //     margin: const EdgeInsets.only(top: 24.0),
                  //     child: MyThemeButton(
                  //       buttonText: saveChanges,
                  //       onPressed: () {
                  //         FocusScope.of(context).requestFocus(FocusNode());
                  //         if (_formKey.currentState!.validate()) {
                  //           onLoginButtonClicked();
                  //         }
                  //       },
                  //     ),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 8, 25, 70.0),
              child: Container(
                margin: const EdgeInsets.only(top: 24.0),
                child: BlocBuilder<EditProfileBloc, EditProfileState>(
                  builder: (context, state) {
                    if (state is AddingDataValidCompletedState) {
                      // WidgetsBinding.instance.addPostFrameCallback((_) {
                      //   Navigator.of(context).maybePop();
                      // });
                    }
                    return MaterialButton(
                        onPressed: () async {
                          FocusScope.of(context).requestFocus(FocusNode());

                          if (_formKey.currentState!.validate()) {
                            var connectivityResult =
                                await (Connectivity().checkConnectivity());
                            if (connectivityResult ==
                                    ConnectivityResult.mobile ||
                                connectivityResult == ConnectivityResult.wifi) {
                              onEditProfileClicked();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  createMessageSnackBar(errorNoInternet));
                            }
                          }
                        },
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)),
                        padding:
                            const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                        color: darkSkyBluePrimaryColor,
                        splashColor: Theme.of(context).primaryColor,
                        disabledColor: Theme.of(context).disabledColor,
                        child: SizedBox(
                          width: double.infinity,
                          height: SizeConfig.blockSizeVertical! * 2.7,
                          child: Center(
                            child: (state is AddingDataInProgressState)
                                ? SizedBox(
                                    width:
                                        SizeConfig.blockSizeHorizontal! * 5.5,
                                    child: const CircularProgressIndicator(
                                        //color: darkSkyBluePrimaryColor,
                                        ),
                                  )
                                : const Text(
                                    saveChanges,
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
              // child: SizedBox(
              //   // margin: const EdgeInsets.only(top: 24.0),
              //   height: 50,
              //   child: MyThemeButton(
              //     buttonText: saveChanges,
              //     onPressed: () {
              //       FocusScope.of(context).requestFocus(FocusNode());
              //       if (_formKey.currentState!.validate()) {
              //         onEditProfileClicked();
              //       }
              //     },
              //   ),
              // ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget _buildLoading() => const Center(child: CircularProgressIndicator());

  void onEditProfileClicked() {
    editProfileBloc.add(UpdateProfileSubmittedEvent(
        _emailController.text,
        _phoneController.text,
        _emailController.text,
        _locationController.text));
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }
}
