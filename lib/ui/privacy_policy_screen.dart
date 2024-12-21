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

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
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
                      label: privacyPolicy,
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
                              // height: 350,
                              margin: const EdgeInsets.all(8.0),
                              child: const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                        color: blackColor,
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                    'Vcarez is an online healthcare platform that offers a range of services, including online consultation with doctors, ordering medicines and health products, and booking lab tests. The company is committed to protecting the privacy of its users and has a comprehensive privacy policy in place.Here are some key points from Vcarez\'s privacy policy:Collection of Information: Vcarez collects personal information such as name, email address, phone number, and health -related information from users when they sign up for the platform or use its services. The company also collects non-personal information such as browser type, IP address, and operating system.Use of Information: Vcarez uses the information it collects to provide its services to users, to communicate with them about their orders and health-related information, and to improve its platform and services. The company may also use the information to send promotional emails and messages tousers.Sharing of Information: Vcarez may share users\' information with third-party service providers who help the company deliver its services, such as delivery partners and payment gateway providers. The company may also share information with regulatory authorities, law enforcement agencies, and other government bodies if required by law.Security: Vcarez takes reasonable measures to protect users information from unauthorized access, disclosure, or misuse.The company uses industry-standard security protocols andencryption technologies to secure users\' data.Cookies and Tracking Technologies: Vcarez uses cookies and other tracking technologies to collect information about users\' browsing behaviorand preferences. Users can manage their cookie preferences through their browser settings.Third-Party Links: Vcarez'
                                    's platform may contain links to third-party websites and services. The company is not responsible for the privacy practices of these third parties.Children\'s Privacy: Vcarez does not knowingly collect or store personal information from children under the age of 18.Changes to the Privacy Policy: Vcarez may update its privacy policy from time to time. Users will be notified of any material changes to the policy via email or through the platform.Overall, Vcarez\'s privacy policy emphasizes the company\'s commitment to protecting users\' personal information and respecting their privacy. Users are advised to review the policy carefully and contact the company if they have any questions or concerns.'),
                                // ),
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
