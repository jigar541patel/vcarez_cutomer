import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vcarez_new/components/my_theme_button.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../commonmodel/cart_provider.dart';
import '../utils/route_names.dart';
import '../utils/strings.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  TextEditingController? textEditingAddress;
  TextEditingController? textEditingUserName;
  TextEditingController? textEditingUserEmail;

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
            child: SingleChildScrollView(
                child: Stack(
          children: <Widget>[
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
                                    child: const IgnorePointer(
                                      child: Icon(
                                        Icons.arrow_back_ios,
                                        color: whiteColor,
                                      ),
                                    )),
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
                        label: contactus,
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                        fontSize: 22.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // SingleChildScrollView(
            //     child:
            Column(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * .15,
                      right: 20.0,
                      left: 20.0),
                  child: SizedBox(
                    height: 140.0,
                    width: MediaQuery.of(context).size.width,
                    child: topHeaderWidget(),
                  ),
                ),
                // Container(
                //   padding:
                //       const EdgeInsets.only(right: 20.0, left: 20.0, top: 20),
                //   child: contentWidget(),
                // ),
                // Container(
                //   padding:
                //       const EdgeInsets.only(right: 20.0, left: 20.0, top: 45),
                //   child: MyThemeButton(
                //     buttonText: 'Submit',
                //     onPressed: () {
                //       // Navigator.push(
                //       //   context,
                //       //   MaterialPageRoute(
                //       //       builder: (context) => const OrderConfirmationScreen()),
                //       // );
                //     },
                //   ),
                // ),
              ],
            )
            // )
          ],
        ))));
  }

  Widget topHeaderWidget() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          InkWell(
            onTap: (){
              _makePhoneCall("+912121678321460");
            },
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                callWithBGIcon,
                height: 54.0,
                width: 54.0,
              ),
              const SizedBox(
                height: 10,
              ),
              const StandardCustomText(
                label: 'Call Us',
                fontSize: 12,
              )
            ],
          )),

          InkWell(
              onTap: () {
                _sendMail();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    messageWithBGIcon,
                    height: 54.0,
                    width: 54.0,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const StandardCustomText(label: 'Email Us', fontSize: 12)
                ],
              )),
          // Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     SvgPicture.asset(
          //       chatWithBGIcon,
          //       height: 54.0,
          //       width: 54.0,
          //     ),
          //     const SizedBox(
          //       height: 10,
          //     ),
          //     // const StandardCustomText(label: 'Chat', fontSize: 12)
          //   ],
          // ),
        ],
      ),
    );
  }

  _sendMail() async {
    // Android and iOS
    // const uri = 'mailto:smith@example.org?subject=News&body=New%20plugin';
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'support@vcarez-help.freshdesk.com',
      query: encodeQueryParameters(<String, String>{
        'subject': '',
      }),
    );

    launchUrl(emailLaunchUri);
    // if (await canLaunchUrl(Uri.parse(uri))) {
    //   await launchUrl(Uri.parse(uri));
    // } else {
    //   throw 'Could not launch $uri';
    // }
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Widget contentWidget() {
    return Card(
      color: Colors.white,
      elevation: 4.0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
            child: TextFormField(
              controller: textEditingUserName,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Enter Name',
                hintStyle: const TextStyle(fontSize: 12),
                filled: true,
                fillColor: currentOrderBG,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
            child: TextFormField(
              controller: textEditingUserEmail,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: Color(0x00000000),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: 'Enter Email',
                hintStyle: const TextStyle(fontSize: 12),
                filled: true,
                fillColor: currentOrderBG,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 17, 20),
            child: TextFormField(
              controller: textEditingAddress,
              maxLines: 5,
              autofocus: false,
              obscureText: false,
              decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: currentOrderBG,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Enter Message…",
                hintStyle: const TextStyle(fontSize: 12),
                focusedBorder: UnderlineInputBorder(
                  borderSide: const BorderSide(
                    color: currentOrderBG,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: currentOrderBG,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
