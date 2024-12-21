import 'package:flutter/material.dart' ;
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:badges/src/badge.dart' as badge;
import '../commonmodel/cart_provider.dart';
import '../utils/route_names.dart';
import '../utils/strings.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {
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
                  const EdgeInsets.only(top: 7.0, bottom: 10.0, left: 16.0),
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

                                  label: Consumer<CartProvider>(
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
                      label: aboutUs,
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
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  margin: const EdgeInsets.all(8.0),
                  child: Card(
                      elevation: 4.0,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      color: whiteColor,
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              height: 350,
                              margin: const EdgeInsets.all(8.0),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: blackColor,fontSize: 15,fontWeight: FontWeight.w700),
                                    'Vcarez is an online healthcare platform based in India. It offers a range of services, ordering medicines and health products online and accessing health-related information and articles. The platform aims to make healthcare more accessible and convenient for people in India, especially those living in remote areas or with limited access to healthcare services. Vcarez has a mobile app that allows users to access its services on their smartphones.'),
                              ),
                            ),
                          ),
                        ],
                      )),
                ),
              ),
            ),
          )
        ],
      )),
    );
  }
}
