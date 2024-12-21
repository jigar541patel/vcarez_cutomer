import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../components/my_theme_button.dart';
import '../../../utils/strings.dart';

class PlanConfirmScreen extends StatefulWidget {
  const PlanConfirmScreen({Key? key}) : super(key: key);

  @override
  State<PlanConfirmScreen> createState() => _PlanConfirmScreenState();
}

class _PlanConfirmScreenState extends State<PlanConfirmScreen> {
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
                            padding: const EdgeInsets.only(right: 10.0),
                            child: SvgPicture.asset(
                              cartIcon,
                              height: 30.0,
                              width: 30.0,
                            ),
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
                      label: lblSubscription,
                      fontWeight: FontWeight.bold,
                      color: whiteColor,
                      fontSize: 22.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Column(
            children: [
              Container(
                width: double.infinity,
                margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .20,
                ),
                height: MediaQuery.of(context).size.height * .65,
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          color: whiteColor,
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(15),
                                child: Container(
                                  height: 350,
                                  margin: const EdgeInsets.all(8.0),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: const [
                                        Image(
                                          image:
                                              AssetImage(icSubscriptionImage),
                                        ),
                                        StandardCustomText(
                                          label: "Subscription activated",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color: darkSkyBluePrimaryColor),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        StandardCustomText(
                                          label:
                                              "Congratulations, you have successfully \n activated premium access.",
                                          fontSize: 12,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 24.0, right: 20, left: 20),
                child: MyThemeButton(
                  buttonText: 'Next',
                  onPressed: () {
                    // Navigator.pushReplacementNamed(context, routeMyProfile);
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          )
        ],
      )),
    );
  }
}
