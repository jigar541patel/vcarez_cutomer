import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../commonmodel/cart_provider.dart';
import '../utils/route_names.dart';
import '../utils/strings.dart';

class ReferEarnScreen extends StatefulWidget {
  const ReferEarnScreen({Key? key}) : super(key: key);

  @override
  State<ReferEarnScreen> createState() => _ReferEarnScreenState();
}

class _ReferEarnScreenState extends State<ReferEarnScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      context.read<CartProvider>().getData();
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
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
          child: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .22,
            child: Container(
              padding:
                  const EdgeInsets.only(top: 5.0, bottom: 20.0, left: 16.0),
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(loginBg),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
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
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: imageAppLogo(),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 15.0),
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
                  const SizedBox(
                    height: 40.0,
                  ),
                  const Align(
                    alignment: Alignment.bottomLeft,
                    child: StandardCustomText(
                      label: referEarn,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                      fontSize: 22.0,
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
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),

                child: Column(
                  children: [
                    Card(
                        elevation: 4.0,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        color: whiteColor,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 20, 8, 40),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      referOne,
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    const Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: StandardCustomText(
                                        label: 'Invite a friend on Vcarez',
                                        fontWeight: FontWeight.bold,
                                        maxlines: 2,
                                        fontSize: 14,
                                        color: referEarnTextColor,
                                        align: TextAlign.start,
                                      ),
                                    )),
                                    SvgPicture.asset(
                                      referFriend,
                                      fit: BoxFit.contain,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      referPhone,
                                    ),
                                    const Expanded(
                                        child: Padding(
                                      padding: EdgeInsets.only(right: 8.0),
                                      child: StandardCustomText(
                                        label:
                                            'Your Friend Gets 25 rs. On Sign Up',
                                        fontSize: 14,
                                        color: referEarnTextColor,
                                        fontWeight: FontWeight.bold,
                                        maxlines: 2,
                                        align: TextAlign.end,
                                      ),
                                    )),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    SvgPicture.asset(
                                      referTwo,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 10, 8, 5),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      referThree,
                                    ),
                                    const SizedBox(
                                      width: 4.0,
                                    ),
                                    const Expanded(
                                        child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 8.0, right: 10),
                                      child: StandardCustomText(
                                        label:
                                            'Get 2r rs. Upon delivery of your friend’s first order',
                                        maxlines: 3,
                                        fontWeight: FontWeight.bold,
                                        color: referEarnTextColor,
                                        fontSize: 14,
                                        align: TextAlign.start,
                                      ),
                                    )),
                                    SvgPicture.asset(
                                      referEmail,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Card(
                      elevation: 4.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 18.0, top: 10),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'REFER VIA',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: primaryTextColor),
                                )),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 18.0, bottom: 18),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      whatsappColorIcon,
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const StandardCustomText(label: 'Whatsapp')
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      phoneBookColorIcon,
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const StandardCustomText(label: 'Phonebook')
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      emailColorIcon,
                                      height: 50.0,
                                      width: 50.0,
                                    ),
                                    const StandardCustomText(label: 'Email'),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset(
                                      moreColorIcon,
                                      height: 30.0,
                                      width: 30.0,
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    const StandardCustomText(label: 'More')
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
