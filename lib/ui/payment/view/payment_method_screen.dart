import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/payment/bloc/payment_bloc.dart';
import 'package:vcarez_new/ui/payment/model/create_order_model.dart';
import 'package:vcarez_new/utils/SizeConfig.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import '../../../components/my_theme_button.dart';
import '../../../utils/strings.dart';
import '../../orderconfirm/view/order_confirmation_screen.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({Key? key}) : super(key: key);

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  var cfPaymentGatewayService = CFPaymentGatewayService();
  PaymentBloc paymentBloc = PaymentBloc();

  @override
  void initState() {
    super.initState();

    cfPaymentGatewayService.setCallback(verifyPayment, onError);
    // WidgetsBinding.instance.addPostFrameCallback((_) async {
    //   showOrderRatingDialog(context);
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget imageAppLogo() => SvgPicture.asset(
          appLogo_,
          height: 18.0,
          width: 116.0,
        );
    return Scaffold(
      backgroundColor: backgroundColor,
      body: BlocProvider(
        create: (context) => paymentBloc,
        child: SafeArea(
            child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .20,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 24.0, bottom: 10.0, left: 16.0),
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
                            SvgPicture.asset(
                              cartIcon,
                              height: 30.0,
                              width: 30.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: StandardCustomText(
                        label: paymentMode,
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
                top: MediaQuery.of(context).size.height * .18,
              ),
              height: MediaQuery.of(context).size.height * .80,
              decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(0.0)),
              ),
              child: BlocConsumer<PaymentBloc, PaymentState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is CreateOrderCompletedState) {
                    CreateOrderModel createOrderModel = state.createOrderModel;
                    String orderID =
                        createOrderModel.data!.orderId.toString();
                    String sessionID = createOrderModel.data!.paymentSessionId!;

                    debugPrint("vcarez we have is state " + state.toString());
                    debugPrint("vcarez we have is orderID " + orderID);
                    pay(orderID, sessionID);
                  }
                },
                builder: (context, state) {

                  return Container(
                    color: currentOrderBG,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SingleChildScrollView(
                          child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(16.0),
                              margin:
                                  const EdgeInsets.only(top: 8.0, bottom: 8.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    paymentOptionsIcon,
                                    fit: BoxFit.none,
                                  ),
                                  const SizedBox(
                                    width: 16.0,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        StandardCustomText(
                                            label: 'Payment Options',
                                            align: TextAlign.start,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: negativeButtonColor),
                                        Padding(
                                          padding: EdgeInsets.only(top: 5.0),
                                          child: StandardCustomText(
                                            label:
                                                'Select your preferred payment mode',
                                            align: TextAlign.start,
                                            maxlines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            cardRow(visaIcon, 'VISA Card',
                                'Click to pay with your Visa card'),
                            cardRow(mastercardIcon, 'Master Card',
                                'Click to pay with your Master card'),
                            cardRow(paypalIcon, 'PayPal',
                                'Click to pay with your PayPal Account'),
                            cardRow(cashIcon, 'Cash on Delivery',
                                'Click to pay cash on delivery'),
                            cardRow(upiIcon, 'Pay with UPI', 'UPI Payment'),
                            BlocProvider(
                              create: (context) => paymentBloc,
                              child: Container(
                                margin: const EdgeInsets.only(top: 24.0),
                                child: MyThemeButton(
                                  buttonText: 'Next',
                                  onPressed: () {

                                    onOrderSubmit();
                                    // Navigator.push(
                                    //   context,
                                    //   MaterialPageRoute(
                                    //       builder: (context) => const OrderConfirmationScreen()),
                                    // );
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ),
                  );
                },
              ),
            )
          ],
        )),
      ),
    );
  }

  Widget cardRow(String icon, String title, String subTitle) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 5.0, 0, 5),
      child: Card(
          color: whiteColor,
          elevation: 4,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Container(
            height: 60,
            padding: const EdgeInsets.fromLTRB(16.0, 1, 16, 1),
            margin: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  icon,
                  fit: BoxFit.none,
                ),
                const SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StandardCustomText(
                        label: title,
                        align: TextAlign.start,
                        fontWeight: FontWeight.bold,
                        color: negativeButtonColor,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: StandardCustomText(
                          label: subTitle,
                          align: TextAlign.start,
                          maxlines: 2,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: primaryColorDark,
                )
              ],
            ),
          )),
    );
  }

  void verifyPayment(String orderId) {
    print("Verify Payment");
    print("vcarez the payment succesfull "+orderId);


  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    print("vcarez the Error while making getCode payment "+errorResponse.getCode().toString());
    print("vcarez the Error while making getCode payment "+errorResponse.getMessage().toString());
  }

  // String orderId = "order_18482KRgqSW7xb1JsU2zPOWaLvBAaeI";

  // String paymentSessionId = "session__Riun1HTk5gExWqYDcl-0cVurRtF3ZSGLObkMlJoKWYLdyGpqCv7Qz1uWnwZIiLKZ1D4goGgOUu_DY6prTED6pm9mpFtO1pZhssJGu04gU7_";
  CFEnvironment environment = CFEnvironment.SANDBOX;

  CFSession? createSession(String orderID, String sessionID) {
    try {
      var session = CFSessionBuilder()
          .setEnvironment(environment)
          .setOrderId(orderID)
          .setPaymentSessionId(sessionID)
          .build();
      return session;
    } on CFException catch (e) {
      print(e.message);
    }
    return null;
  }

  pay(String orderID, String sessionID) async {
    try {
      var session = createSession(orderID, sessionID);
      List<CFPaymentModes> components = <CFPaymentModes>[];
      components.add(CFPaymentModes.UPI);
      components.add(CFPaymentModes.CARD);
      components.add(CFPaymentModes.NETBANKING);
      components.add(CFPaymentModes.WALLET);
      var paymentComponent =
          CFPaymentComponentBuilder().setComponents(components).build();

      var theme = CFThemeBuilder()
          // .setNavigationBarBackgroundColorColor("FF1BACE3")
          .setPrimaryFont("Menlo")
          .setSecondaryFont("Futura")
          .build();

      var cfDropCheckoutPayment = CFDropCheckoutPaymentBuilder()
          .setSession(session!)
          .setPaymentComponent(paymentComponent)
          .setTheme(theme)
          .build();


      cfPaymentGatewayService.doPayment(cfDropCheckoutPayment);

    } on CFException catch (e) {
      print(e.message);
    }
  }

  void showOrderRatingDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
              color: Colors.transparent,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: SizeConfig.blockSizeVertical! * 80,
                width: SizeConfig.screenWidth,
                // height: MediaQuery.of(context).size.height * .80,

                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const StandardCustomText(
                        label: 'Thank you for your recent purchase',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const StandardCustomText(
                            label: 'from ',
                            fontWeight: FontWeight.w400,
                            fontSize: 14.0,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            color: backgroundLogoDarkColor,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
                              child: Image.asset(
                                appLogo,
                                height: 40,
                                width: 100,
                              ),
                            ),
                          )
                        ],
                      ),

                      const SizedBox(
                        height: 40,
                      ),
                      const StandardCustomText(
                        label: 'Pharmacy Rating',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RatingBar.builder(
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      const StandardCustomText(
                        label: 'Delivery Boy Rating',
                        fontWeight: FontWeight.w400,
                        fontSize: 14.0,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      RatingBar.builder(
                        initialRating: 4,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),

                      Padding(
                        padding: const EdgeInsetsDirectional.fromSTEB(
                            20, 20, 17, 20),
                        child: TextFormField(
                          // controller: textEditingAddress,
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
                            hintText: "Review",
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

                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, top: 15),
                        child: MyThemeButton(
                          buttonText: 'Submit',
                          onPressed: () {
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const OrderConfirmationScreen()),
                            // );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Maybe Later",
                        style: TextStyle(
                            fontSize: 12,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.bold,
                            color: darkSkyBluePrimaryColor),
                      )
                      // addressList(),
                    ],
                  ),
                ),
              )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  void onOrderSubmit() {
    paymentBloc.add(CreateOrderSubmittedEvent("500"));
  }
}
