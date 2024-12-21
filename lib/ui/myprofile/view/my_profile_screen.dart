import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/cart/bloc/cart_list_bloc.dart';
import 'package:vcarez_new/ui/cart/model/cart_list_model.dart';
import 'package:vcarez_new/ui/wallet_screen.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../utils/strings.dart';
import '../../profile/view/edit_profile_screen.dart';
import '../../my_prescription/view/my_prescription_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({Key? key}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  CartListBloc cartListBloc = CartListBloc();
  CartListModel cartListModel = CartListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // Future.delayed(const Duration(seconds: 2), () {
      cartListBloc.add(GetCartListEvent());
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
    return BlocProvider(
      create: (context) => cartListBloc,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
            child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .24,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 10.0, bottom: 50.0, left: 16.0),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(loginBg),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
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
                            BlocConsumer<CartListBloc, CartListState>(
                              listener: (context, state) {
                                // TODO: implement listener

                                if (state is OnCartListLoaded) {
                                  cartListModel = state.cartListModel;
                                }
                              },
                              builder: (context, state) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, routeCartList);
                                      },
                                      child: Badge(
                                        badgeContent: Text(
                                            cartListModel.cartItems != null
                                                ? cartListModel
                                                    .cartItems!.length
                                                    .toString()
                                                : "0"),
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
                                );

                                //   SvgPicture.asset(
                                //   cartIcon,
                                //   height: 30.0,
                                //   width: 30.0,
                                // );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: StandardCustomText(
                        label: myProfile,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                        fontSize: 28.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .20,
              ),
              height: MediaQuery.of(context).size.height * .78,
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
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, routeEditProfile);
                            },
                            child: cardRow(editProfileIcon, 'Edit Profile')),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MyPrescriptionScreen()),
                              );
                            },
                            child: cardRow(
                                myPrescriptionIcon, 'My Prescriptions')),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, routeMyOrderList);
                            },
                            child: cardRow(orderHistoryIcon, 'Order History')),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, routePrivilegePlan);
                            },
                            child: cardRow(orderHistoryIcon, 'Privilege Plan')),
                        // InkWell(
                        //     onTap: () {
                        //       /* Navigator.push(
                        //       context,
                        //       MaterialPageRoute(builder: (context) =>  MyPrescriptionScreen()),
                        //     );*/
                        //     },
                        //     child:
                        //         cardRow(privilegePlanIcon, 'Privilege Plan')),
                        InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WalletDetailScreen()),
                              );
                            },
                            child: cardRow(walletIcon, 'Wallet')),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, routeQuotationHistory);
                            },
                            child:
                                cardRow(orderHistoryIcon, 'Quotation History')),
                        InkWell(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, routeMyAddressList);
                            },
                            child:
                                cardRow(orderHistoryIcon, 'My Address')),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                fit: BoxFit.none,
              ),
              const SizedBox(
                width: 16.0,
              ),
              Expanded(
                  child: StandardCustomText(
                label: title,
                fontWeight: FontWeight.w700,
                align: TextAlign.start,
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
