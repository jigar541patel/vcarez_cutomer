import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../../../commonmodel/cart_provider.dart';
import '../../../../../components/standard_regular_text.dart';
import '../../../../../utils/colors_utils.dart';
import '../../../../../utils/images_utils.dart';
import '../../../../../utils/strings.dart';
import '../../../../about_us_screen.dart';
import '../../../../cart/bloc/cart_list_bloc.dart';
import '../../../../cart/model/cart_list_model.dart';
import '../../../../contact_us_screen.dart';
import '../../../../myprofile/view/my_profile_screen.dart';
import '../../../../privacy_policy_screen.dart';
import '../../../../refer_earn_screen.dart';
import '../../../../terms_conditions_screen.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingsScreen> {
  // CartListBloc cartListBloc = CartListBloc();
  // CartListModel cartListModel = CartListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Future.delayed(const Duration(seconds: 2), () {
      // cartListBloc.add(GetCartListEvent());
      context.read<CartProvider>().getData();

      // });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget imageAppLogo() => SvgPicture.asset(
          appLogo_,
          height: 18.0,
          width: 116.0,
        );

    Widget profilePicImage() => InkWell(
        onTap: () {
          Navigator.pushNamed(context, routeMyProfile);
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(builder: (context) => const MyProfileScreen()),
          // );
        },
        child: SvgPicture.asset(
          userPicPlaceHolder,
          height: 45.0,
          width: 45.0,
        ));
    return
        // BlocProvider(
        // create: (context) => cartListBloc,
        // child:
        Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .20,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 7.0, bottom: 20.0, left: 16.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(loginBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            profilePicImage(),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: imageAppLogo(),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                              onTap: () {
                                Navigator.pushNamed(context, routeCartList);
                              },
                              child: Badge(
                                badgeContent: Consumer<CartProvider>(
                                  builder: (context, value, child) {
                                    return Text(
                                      value.getCounter().toString(),
                                    );
                                  },
                                ),
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
                          // InkWell(
                          //     onTap: () {
                          //       Navigator.pushNamed(
                          //           context, routeCartList);
                          //     },
                          //     child: Badge(
                          //       badgeContent: Text(
                          //           cartListModel.cartItems != null
                          //               ? cartListModel.cartItems!.length
                          //                   .toString()
                          //               : "0"),
                          //       position: BadgePosition.bottomEnd(),
                          //       badgeColor: Colors.white,
                          //
                          //       child: SvgPicture.asset(
                          //         cartBadgeIcon,
                          //         height: 25,
                          //         width: 25,
                          //         fit: BoxFit.none,
                          //       ),
                          //       // (Icons.shopping_cart),
                          //     )),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: StandardCustomText(
                      label: mySettings,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                      fontSize: 24.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * .18,
            ),
            height: MediaQuery.of(context).size.height * .80,
            decoration: const BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  bottomRight: Radius.circular(0.0),
                  topLeft: Radius.circular(10.0),
                  bottomLeft: Radius.circular(0.0)),
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ReferEarnScreen()),
                              );
                            },
                            child: cardRow(referEarnIcon, 'Refer & Earn')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AboutUsScreen()),
                              );
                            },
                            child: cardRow(aboutUsIcon, 'About Us')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ContactUsScreen()),
                              );
                            },
                            child: cardRow(contactUsIcon, 'Contact Us')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        TermsConditionScreen()),
                              );
                            },
                            child: cardRow(
                                termsConditionIcon, 'Terms & Conditions')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        PrivacyPolicyScreen()),
                              );
                            },
                            child:
                                cardRow(privacyPolicyIcon, 'Privacy & Policy')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0),
                        child: InkWell(
                            onTap: () async {
                              FlutterSecureStorage storage =
                                  FlutterSecureStorage();
                              await storage.deleteAll();
                              Navigator.pushNamedAndRemoveUntil(context,
                                  routeLogin, ModalRoute.withName('/'));
                            },
                            child: cardRow(logoutIcon, 'Logout')),
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
    // );
  }

  Widget cardRow(String icon, String title) {
    return Card(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        elevation: 4,
        color: whiteColor,
        child: Container(
          padding: const EdgeInsets.only(
              left: 16.0, right: 16.0, top: 8.0, bottom: 8.0),
          margin: const EdgeInsets.only(top: 12.0, bottom: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                // height: 20,
                icon,
                fit: BoxFit.none,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                  child: StandardCustomText(
                label: title,
                align: TextAlign.start,
                fontWeight: FontWeight.bold,
              )),
              const Icon(
                Icons.chevron_right,
                color: primaryColorDark,
              )
            ],
          ),
        ));
  }
}
