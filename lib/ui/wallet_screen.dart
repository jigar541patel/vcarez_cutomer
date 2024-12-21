import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/ui/shopquotationdetail/view/shop_detail_screen.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../commonmodel/cart_provider.dart';
import '../components/standard_regular_text.dart';
import '../utils/route_names.dart';
import '../utils/strings.dart';

class WalletDetailScreen extends StatefulWidget {
  const WalletDetailScreen({Key? key}) : super(key: key);

  @override
  State<WalletDetailScreen> createState() => _WalletDetailScreenState();
}

class _WalletDetailScreenState extends State<WalletDetailScreen> {
  var demoList = [1, 2, 3, 4, 5];

  @override
  void initState() {
    super.initState();
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
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * .30,
                    padding: const EdgeInsets.only(
                        top: 24.0, bottom: 0.0, left: 16.0),
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
                            label: wallet,
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                            fontSize: 22.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * .70,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .20,
                  right: 20.0,
                  left: 20.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 155.0,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.white,
                      elevation: 4.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(rewardPoints,
                              style: TextStyle(
                                  color: darkSkyBluePrimaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0)),
                          const SizedBox(
                            height: 15,
                          ),
                          Align(
                            alignment: AlignmentDirectional.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  goldCoin,
                                  height: 35.0,
                                  width: 50.0,
                                ),
                                const SizedBox(width: 10),
                                const Text('1000',
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    height: 155.0,
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: Colors.white,
                      elevation: 4.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15,20,15,20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('125 SuperCoins Used',
                                style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0)),
                            const SizedBox(
                              height: 15,
                            ),
                            Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Extra Rs. 200 off',
                                      style: TextStyle(
                                          color: primaryTextColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12.0)),
                                  const SizedBox(width: 10),
                                  SvgPicture.asset(
                                    appLogoCoin,
                                    height: 58.0,
                                    width: 137.0,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: const [
                                Text('Expiry Date: ',
                                    style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0)),
                                Text('22/08/2022 ',
                                    style: TextStyle(
                                        color: darkSkyBluePrimaryColor,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )));
  }

  Widget quotationDetailList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .50,
      child: SingleChildScrollView(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20.0),
            child: Text('Quotations Rec’d',
                style: TextStyle(
                    color: primaryTextColor,
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0)),
          ),
          ListView.builder(
              itemCount: demoList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(8, 5, 7, 5),
                  child: GestureDetector(
                      onTap: () {
                        debugPrint("vacrez the click is called ");
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ShopDetailScreen()),
                        );
                      },
                      child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 1,
                                  offset: const Offset(
                                      0, 5), // changes position of shadow
                                ),
                              ],
                              border: Border.all(
                                color: whiteColor,
                              ),
                              color: whiteColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding:
                                const EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text('Shop A ',
                                        style: TextStyle(
                                            color: primaryTextColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0)),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text('$rupeesString 650.00',
                                        style: TextStyle(
                                            color: darkSkyBluePrimaryColor,
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12.0)),
                                  ],
                                ),
                              ],
                            ),
                          ))),
                );
              }),
        ],
      )),
    );
  }
}
