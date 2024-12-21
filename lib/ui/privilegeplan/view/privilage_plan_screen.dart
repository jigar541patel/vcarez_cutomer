import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cashfree_pg_sdk/api/cferrorresponse/cferrorresponse.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpayment/cfdropcheckoutpayment.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentcomponents/cfpaymentcomponent.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfpaymentgateway/cfpaymentgatewayservice.dart';
import 'package:flutter_cashfree_pg_sdk/api/cfsession/cfsession.dart';
import 'package:flutter_cashfree_pg_sdk/api/cftheme/cftheme.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfenums.dart';
import 'package:flutter_cashfree_pg_sdk/utils/cfexceptions.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/privilegeplan/model/privilege_plan_model.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/verify_cf_model.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';
import '../../../components/common_loader.dart';
import '../../../components/my_theme_button.dart';
import '../../../components/transparent_common_loader.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/SizeConfig.dart';
import '../../../utils/strings.dart';
import '../../orderconfirm/view/order_confirmation_screen.dart';
import '../../payment/bloc/payment_bloc.dart';
import '../../payment/model/create_order_model.dart';
import '../bloc/privilege_plan_bloc.dart';
import '../model/buy_plan_success_model.dart';

class PrivilegePlanScreen extends StatefulWidget {
  const PrivilegePlanScreen({Key? key}) : super(key: key);

  @override
  State<PrivilegePlanScreen> createState() => _PrivilegePlanScreenState();
}

class _PrivilegePlanScreenState extends State<PrivilegePlanScreen> {
  PrivilegePlanBloc privilegePlanBloc = PrivilegePlanBloc();
  PrivilegePlanModel privilegePlanModel = PrivilegePlanModel();
  PaymentBloc paymentBloc = PaymentBloc();
  int intSelected = 0;
  var cfPaymentGatewayService = CFPaymentGatewayService();
  bool isLoading = false;
  VerifyCFModel verifyCFModel = VerifyCFModel();
  String strOrderID = "";
  String sessionID = "";
  CFEnvironment environment = CFEnvironment.SANDBOX;

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   Future.delayed(const Duration(seconds: 2), () {
      privilegePlanBloc.add(GetPrivilegePlanEvent());
      //   });
    });
  }

  void verifyPayment(String orderId) {
    print("Verify Payment");
    print("vcarez the payment succesfull " + orderId);

    setState(() {
      isLoading = true;
    });

    strOrderID = orderId;
    privilegePlanBloc.add(VerifyPlanOrderIDEvent(orderId));
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    print("vcarez the Error while making getCode payment " +
        errorResponse.getCode().toString());
    print("vcarez the Error while making getCode payment " +
        errorResponse.getMessage().toString());
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Widget imageAppLogo() => SvgPicture.asset(
        appLogo_,
        height: 18.0,
        width: 116.0,
      );

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return BlocProvider(
      create: (context) => paymentBloc,
      child: Scaffold(
          backgroundColor: backgroundColor,
          body: SafeArea(
              child: BlocProvider(
            create: (context) => privilegePlanBloc,
            child: SingleChildScrollView(
              child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: BlocConsumer<PaymentBloc, PaymentState>(
                    listener: (context, statePayment) {
                      // TODO: implement listener

                      if (statePayment is CreateOrderCompletedState) {
                        CreateOrderModel createOrderModel =
                            statePayment.createOrderModel;
                        String orderID =
                            createOrderModel.data!.orderId.toString();
                        sessionID = createOrderModel.data!.paymentSessionId!;

                        debugPrint("vcarez we have is state " +
                            statePayment.toString());
                        debugPrint("vcarez we have is orderID " + orderID);
                        openPaymentGateway(orderID, sessionID);
                      }
                    },
                    builder: (context, statePayment) {
                      return BlocConsumer<PrivilegePlanBloc,
                          PrivilegePlanState>(
                        listener: (context, state) {
                          // TODO: implement listener
                          if (state is PrivilegePlanDataLoaded) {
                            privilegePlanModel = state.privilegePlanModel;
                          }

                          if (state is VerifyPlanOrderSuccessState) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              setState(() {
                                verifyCFModel = state.verifyCFModel;

                                privilegePlanBloc.add(
                                    BuySubscriptionSubmittedEvent(
                                        privilegePlanModel
                                            .plans![intSelected].id
                                            .toString(),
                                        sessionID));
                              });
                            });
                          }

                          if (state is BuySubscriptionSuccessState) {
                            WidgetsBinding.instance
                                .addPostFrameCallback((_) async {
                              setState(() {
                                BuyPlanSuccessModel buyPlanSuccessModel =
                                    state.buyPlanSuccessModel;
                                Navigator.pushReplacementNamed(
                                  context, routePlanConfirmScreen,
                                  arguments: {'model': buyPlanSuccessModel},

                                  // arguments: orderAcceptSuccessModel
                                );
                                //change here save response api
                                // Navigator.pushReplacementNamed(
                                //     context, routeMyOrderList);
                              });
                            });
                          }
                        },
                        builder: (context, state) {
                          return Stack(
                            children: [
                              // createStandardAppBar(
                              //     context: context, size: MediaQuery.of(context).size.height * .25),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * .23,
                                padding: EdgeInsets.only(
                                    top: SizeConfig.safeBlockVertical! * 1,
                                    left: SizeConfig.safeBlockHorizontal! * 5,
                                    right: SizeConfig.safeBlockHorizontal! * 5),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
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
                                                padding: const EdgeInsets.only(
                                                    left: 8.0),
                                                child: imageAppLogo(),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      // height: 30.0,
                                      height:
                                          SizeConfig.safeBlockVertical! * 7.0,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Align(
                                        alignment: Alignment.bottomLeft,
                                        child: StandardCustomText(
                                          label: 'Privilege Plans',
                                          fontWeight: FontWeight.bold,
                                          color: whiteColor,
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ),

                                    //
                                  ],
                                ),
                              ),

                              bottomContent(),
                              state is PrivilegePlanDataLoaded
                                  ? privilegePlanModel.activePlan == null
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 40.0),
                                          child: Align(
                                              alignment: AlignmentDirectional
                                                  .bottomCenter,
                                              child: Container(
                                                height: 60,
                                                padding: const EdgeInsets.only(
                                                    right: 20.0,
                                                    left: 20.0,
                                                    top: 5),
                                                child: MyThemeButton(
                                                  buttonText: lblContinue,
                                                  onPressed: () {
                                                    onOrderSubmit(
                                                        privilegePlanModel
                                                            .plans![intSelected]
                                                            .price
                                                            .toString());
                                                  },
                                                ),
                                              )),
                                        )
                                      // ;
                                      //     : SizedBox()
                                      // : SizedBox();
                                      // },
                                      // )
                                      : SizedBox()
                                  : SizedBox(),

                              statePayment is CreateOrderInProgressState ||
                                      state is VerifyPlanOrderSubmittingState
                                  ? const CustomTransparentLoader()
                                  : SizedBox(),
                            ],
                          );
                        },
                      );
                    },
                  )
                  // },
                  // ),
                  ),
            ),
          ))),
    );
  }

  void onOrderSubmit(String strAmount) {
    setState(() {
      isLoading = true;
    });

    paymentBloc.add(CreateOrderSubmittedEvent(strAmount));
  }

  Widget bottomContent() {
    return Positioned(
        top: MediaQuery.of(context).size.height * .18,
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(
                color: bgColor,
              ),
              color: bgColor,
              borderRadius: const BorderRadius.all(Radius.circular(20))),
          child: SizedBox(
            child: deliveryHistoryList(),
          ),
        ));
  }

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

  openPaymentGateway(String orderID, String sessionID) async {
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

  Widget topHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * .25,
      padding: const EdgeInsets.only(
          top: 10.0, bottom: 0.0, left: 16.0, right: 16.0),
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
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 30.0,
          ),
        ],
      ),
    );
  }

  Widget deliveryHistoryList() {
    return BlocConsumer<PrivilegePlanBloc, PrivilegePlanState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return state is PrivilegePlanLoading ||
                state is BuySubscriptionLoadingState
            ? Center(
                child: SizedBox(
                    height: MediaQuery.of(context).size.height * .60,
                    child: const Center(child: CustomLoader())),
              )
            : state is PrivilegePlanDataLoaded ||
                    state is BuySubscriptionSuccessState ||
                    state is VerifyPlanOrderSuccessState ||
                    state is VerifyPlanOrderSubmittingState

                ? privilegePlanModel.plans!.isNotEmpty
                    ? Column(
                        children: [
                          widgetHeader(),
                          privilegePlanModel.activePlan != null
                              ? widgetAlreadyPlan()
                              : SizedBox(),
                          privilegePlanModel.activePlan == null
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10.0, bottom: 10),
                                  child: SingleChildScrollView(
                                      child: Column(
                                    children: [
                                      Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .45,
                                          child: ListView.builder(
                                              itemCount: privilegePlanModel
                                                  .plans!.length,
                                              shrinkWrap: true,
                                              padding: EdgeInsets.zero,
                                              scrollDirection: Axis.vertical,
                                              itemBuilder: (context, index) {
                                                Plans plans = privilegePlanModel
                                                    .plans![index];
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          8, 5, 7, 5),
                                                  child: GestureDetector(
                                                      onTap: () {
                                                        setState(() {
                                                          intSelected = index;
                                                        });
                                                        debugPrint(
                                                            "vacrez the click is called ");
                                                      },
                                                      child: widgetPlanList(
                                                          index, plans)),
                                                );
                                              })),
                                    ],
                                  )))
                              : SizedBox(),
                        ],
                      )
                    : CommonUtils.NoDataFoundPlaceholder(context,
                        message: "No Data Found")
                : CommonUtils.NoDataFoundPlaceholder(context,
                    message: "No Data Found");
      },
    );
  }

  Widget widgetHeader() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 15),
      child: Container(
          width: SizeConfig.screenWidth,
          // height: SizeConfig.safeBlockVertical! * 19.0,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
              border: Border.all(
                color: whiteColor,
              ),
              color: whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: StandardCustomText(
                    align: TextAlign.start,
                    maxlines: 4,
                    label: "Benefits of members",
                    color: darkSkyBluePrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: const BoxDecoration(
                            color: darkSkyBluePrimaryColor,
                            shape: BoxShape.circle,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      const StandardCustomText(
                        align: TextAlign.start,
                        maxlines: 4,
                        label: "“More you buy more you can save”",
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: StandardCustomText(
                    align: TextAlign.start,
                    maxlines: 4,
                    label: "1) 100 & above 2% 2) 500 & above 4% ",
                    color: blackColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 5,
                    right: 20,
                  ),
                  child: StandardCustomText(
                    align: TextAlign.start,
                    maxlines: 4,
                    label: "3) 1000 & above 6% 4) 5000 & above 8%",
                    color: blackColor,
                    fontWeight: FontWeight.normal,
                    fontSize: 12,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: const BoxDecoration(
                            color: darkSkyBluePrimaryColor,
                            shape: BoxShape.circle,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      const StandardCustomText(
                        align: TextAlign.start,
                        maxlines: 4,
                        label: "Delivery will be FREE.",
                        color: blackColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: const BoxDecoration(
                            color: darkSkyBluePrimaryColor,
                            shape: BoxShape.circle,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      const SizedBox(
                        width: 300,
                        child: StandardCustomText(
                          align: TextAlign.start,
                          maxlines: 4,
                          label:
                              "Additional 2% discount will be offered to members.",
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Widget widgetAlreadyPlan() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 15),
      child: Container(
          width: SizeConfig.screenWidth,
          // height: SizeConfig.safeBlockVertical! * 19.0,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
              border: Border.all(
                color: whiteColor,
              ),
              color: whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: StandardCustomText(
                    align: TextAlign.start,
                    maxlines: 4,
                    label: "Your Current Plan ",
                    color: darkSkyBluePrimaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Container(
                          height: 10.0,
                          width: 10.0,
                          decoration: const BoxDecoration(
                            color: darkSkyBluePrimaryColor,
                            shape: BoxShape.circle,
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      privilegePlanModel.activePlan != null
                          ? StandardCustomText(
                              align: TextAlign.start,
                              maxlines: 4,
                              label:
                                  "Plan Type  : ${privilegePlanModel.activePlan!.title!}",
                              color: blackColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    right: 20,
                  ),
                  child: privilegePlanModel.activePlan != null
                      ? StandardCustomText(
                          align: TextAlign.start,
                          maxlines: 4,
                          label:
                              "Amount  : ${"${privilegePlanModel.activePlan!.price} $rupeesString"}",
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )
                      : SizedBox(),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    top: 10,
                    left: 20.0,
                    right: 20,
                  ),
                  child: privilegePlanModel.validity != null
                      ? StandardCustomText(
                          align: TextAlign.start,
                          maxlines: 4,
                          label: "Validity  : ${privilegePlanModel.validity}",
                          color: blackColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )
                      : SizedBox(),
                ),
              ],
            ),
          )),
    );
  }

  Widget widgetPlanList(int index, Plans plans) {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15),
      child: Container(
          // height: SizeConfig.safeBlockVertical! * 19.0,
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 1,
                  offset: const Offset(0, 5), // changes position of shadow
                ),
              ],
              border: Border.all(
                color:
                    intSelected == index ? darkSkyBluePrimaryColor : whiteColor,
              ),
              color: whiteColor,
              borderRadius: const BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 5.0),
            child: Column(
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20, top: 15, bottom: 15, right: 10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        privilegeSvgImage,
                        // color: darkSkyBluePrimaryColor,
                        height: 25.0,
                        width: 25.0,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 4,
                          child: StandardCustomText(
                            align: TextAlign.start,
                            maxlines: 4,
                            label: plans.title != null ? plans.title! : "",
                            color: negativeButtonColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                      Expanded(
                          flex: 4,
                          child: Column(
                            children: [
                              StandardCustomText(
                                align: TextAlign.start,
                                maxlines: 4,
                                label: plans.price != null
                                    ? "$rupeesString ${plans.price.toString()}"
                                    : "",
                                color: darkSkyBluePrimaryColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              StandardCustomText(
                                align: TextAlign.start,
                                maxlines: 4,
                                label: plans.duration != null
                                    ? "${plans.duration} months"
                                    : "",
                                color: negativeButtonColor,
                                fontWeight: FontWeight.normal,
                                fontSize: 12,
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
