import 'package:badges/badges.dart';
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
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/payment/bloc/payment_bloc.dart';
import 'package:vcarez_new/ui/privilegeplan/view/privilage_plan_screen.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/view/quotations_detail_screen.dart';
import 'package:vcarez_new/ui/shopquotationdetail/bloc/shop_quotation_detail_bloc.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/order_accept_success_model.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/shop_quotation_detail_model.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/verify_cf_model.dart';
import 'package:vcarez_new/utils/SizeConfig.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/my_theme_button.dart';
import '../../../components/transparent_common_loader.dart';
import '../../../utils/strings.dart';
import '../../payment/model/create_order_model.dart';

class ShopDetailScreen extends StatefulWidget {
  const ShopDetailScreen({Key? key}) : super(key: key);

  @override
  State<ShopDetailScreen> createState() => _ShopDetailScreenState();
}

class _ShopDetailScreenState extends State<ShopDetailScreen> {
  String strQuoteID = "";
  String strOrderID = "";
  String strTitle = "";
  List listQuoteId = [];

  ShopQuotationDetailBloc shopQuotationDetailBloc = ShopQuotationDetailBloc();
  PaymentBloc paymentBloc = PaymentBloc();
  ShopQuotationDetailModel shopQuotationDetailModel =
      ShopQuotationDetailModel();
  var cfPaymentGatewayService = CFPaymentGatewayService();
  CFEnvironment environment = CFEnvironment.SANDBOX;
  VerifyCFModel verifyCFModel = VerifyCFModel();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    cfPaymentGatewayService.setCallback(verifyPayment, onError);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final arg = ModalRoute.of(context)!.settings.arguments as Map;
        strQuoteID = arg['id'];

        debugPrint("vcarez medicine list strQuoteID $strQuoteID");
        debugPrint("vcarez medicine list strTitle $strTitle");
        shopQuotationDetailBloc.add(GetQuotationDetail(strQuoteID));
        setState(() {
          strTitle = arg['title'];
        });

        context.read<CartProvider>().getData();
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var demoList = [1, 2, 3];

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
      body: SafeArea(
          child: BlocProvider(
        create: (context) => paymentBloc,
        child: BlocProvider(
          create: (context) => shopQuotationDetailBloc,
          child:
              BlocConsumer<ShopQuotationDetailBloc, ShopQuotationDetailState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is ShopQuotationDetailLoaded) {
                shopQuotationDetailModel = state.shopQuotationDetailModel;
              }
              if (state is AcceptQuoteSuccessState) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  setState(() {
                    saveOrderRequest();
                    //change here save response api
                    // Navigator.pushReplacementNamed(
                    //     context, routeMyOrderList);
                  });
                });
              }
              if (state is VerifyOrderSuccessState) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  setState(() {
                    verifyCFModel = state.verifyCFModel;
                    shopQuotationDetailBloc.add(AcceptQuoteSubmitEvent(
                        shopQuotationDetailModel.quotation!.customerQuotationId
                            .toString(),
                        listQuoteId));

                    //change here save response api
                    // Navigator.pushReplacementNamed(
                    //     context, routeMyOrderList);
                  });
                });
              }

              if (state is SaveOrderSuccessState) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  setState(() {
                    OrderAcceptSuccessModel orderAcceptSuccessModel =
                        state.orderAcceptSuccessModel;
                    Navigator.pushReplacementNamed(
                        context, routeOrderConfirmation,
                        arguments: {
                          'model':orderAcceptSuccessModel
                        },

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
              return BlocConsumer<PaymentBloc, PaymentState>(
                listener: (context, state) {
                  // TODO: implement listener
                },
                builder: (context, state) {
                  return Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .30,
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 24.0, bottom: 50.0, left: 16.0),
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
                                      // SvgPicture.asset(
                                      //   cartIcon,
                                      //   height: 30.0,
                                      //   width: 30.0,
                                      // ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 40,
                              ),
                              Align(
                                alignment: Alignment.bottomLeft,
                                child: StandardCustomText(
                                  label: strTitle,
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
                          top: MediaQuery.of(context).size.height * .23,
                        ),
                        height: MediaQuery.of(context).size.height * .75,
                        decoration: const BoxDecoration(
                          color: whiteColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(0.0)),
                        ),
                        child: SingleChildScrollView(
                          child: BlocProvider(
                            create: (context) => shopQuotationDetailBloc,
                            child: BlocConsumer<ShopQuotationDetailBloc,
                                ShopQuotationDetailState>(
                              listener: (context, state) {
                                // TODO: implement listener
                              },
                              builder: (context, state) {
                                return state is ShopQuotationDetailLoaded

                                    // ||
                                    // state is AcceptQuoteSuccessState ||
                                    // state is VerifyOrderSuccessState
                                    ? BlocConsumer<PaymentBloc, PaymentState>(
                                        listener: (context, state) {
                                          // TODO: implement listener
                                        },
                                        builder: (context, state) {
                                          return Column(
                                            children: [
                                              productList(),
                                              subTotalWidget(),
                                              BlocProvider(
                                                create: (context) =>
                                                    paymentBloc,
                                                child: acceptRejectWidget(),
                                              ),
                                            ],
                                          );
                                        },
                                      )
                                    : state is ShopQuotationDetailLoading ||
                                            state
                                                is AcceptQuoteSubmittingState ||
                                            isLoading
                                        ? Container(
                                            width: double.infinity,

                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                .50,
                                            child: Center(
                                                child: const CustomLoader()))
                                        : const SizedBox();
                              },
                            ),
                          ),
                        ),
                      ),
                      state is CreateOrderInProgressState ||
                              state is VerifyOrderSubmittingState ||
                              state is SaveOrderSubmittingState
                          ? const CustomTransparentLoader()
                          : SizedBox(),
                    ],
                  );
                },
              );
            },
          ),
        ),
      )),
    );
  }

  Widget subTotalWidget() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: Card(
        elevation: 4,
        child: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      child: StandardCustomText(
                          align: TextAlign.start, label: 'Discount')),
                  Expanded(
                    child: StandardCustomText(
                      align: TextAlign.end,
                      label:
                          '$rupeesString ${shopQuotationDetailModel.quotation!.discount.toString()}',
                      color: darkSkyBluePrimaryColor,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                      child: StandardCustomText(
                          align: TextAlign.start, label: 'NET TOTAL')),
                  Expanded(
                    child: StandardCustomText(
                      align: TextAlign.end,
                      label:
                          '$rupeesString ${shopQuotationDetailModel.quotation!.total.toString()}',
                      color: darkSkyBluePrimaryColor,
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void verifyPayment(String orderId) {
    print("Verify Payment");
    print("vcarez the payment succesfull " + orderId);

    setState(() {
      isLoading = true;
    });

    // shopQuotationDetailBloc.add(AcceptQuoteSubmitEvent(
    //     shopQuotationDetailModel.quotation!.customerQuotationId.toString(),
    //     listQuoteId));
    strOrderID = orderId;
    shopQuotationDetailBloc.add(VerifyOrderIDEvent(orderId));

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => const PaymentMethodScreen()),
    // );
  }

  void onError(CFErrorResponse errorResponse, String orderId) {
    print("vcarez the Error while making getCode payment " +
        errorResponse.getCode().toString());
    print("vcarez the Error while making getCode payment " +
        errorResponse.getMessage().toString());
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

  Widget acceptRejectWidget() {
    return BlocConsumer<PaymentBloc, PaymentState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is CreateOrderCompletedState) {
          CreateOrderModel createOrderModel = state.createOrderModel;
          String orderID = createOrderModel.data!.orderId.toString();
          String sessionID = createOrderModel.data!.paymentSessionId!;

          debugPrint("vcarez we have is state " + state.toString());
          debugPrint("vcarez we have is orderID " + orderID);
          openPaymentGateway(orderID, sessionID);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyThemeButton(
                    fontSize: 12,
                    buttonText: 'Accept',
                    onPressed: () {
                      listQuoteId.add(
                          shopQuotationDetailModel.quotation!.id.toString());
                      onOrderSubmit(
                          shopQuotationDetailModel.quotation!.total.toString());
                    },
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: MyThemeButton(
                    color: redColor,
                    fontSize: 12,
                    buttonText: 'Reject',
                    onPressed: () {
                      Navigator.pop(context);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => const QuotationsDetailScreen()),
                      // );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
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

  Widget productList() {
    return SizedBox(
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(top: 0.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(
              color: whiteColor,
            ),
            color: whiteColor,
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(10.0),
                bottomRight: Radius.circular(0.0),
                topLeft: Radius.circular(10.0),
                bottomLeft: Radius.circular(0.0)),
          ),
          child: ListView.builder(
              itemCount: shopQuotationDetailModel.quotation!.medicines!.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                Medicines medicines =
                    shopQuotationDetailModel.quotation!.medicines![index];
                return
                    // Padding(
                    // padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                    // child:
                    GestureDetector(
                        onTap: () {
                          debugPrint("vacrez the click is called ");
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //       builder: (context) =>
                          //       const QuotationsDetailScreen()),
                          // );
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Container(
                              color: whiteColor,
                              height: SizeConfig.safeBlockVertical! * 20.0,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    15.0, 15.0, 15.0, 5.0),
                                child: Column(
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                            flex: 1,
                                            child: Align(
                                              alignment:
                                                  AlignmentDirectional.center,
                                              child: medicines.imageUrl != null
                                                  ? Image(
                                                      width: 75,
                                                      height: 81,
                                                      image: NetworkImage(
                                                          medicines.imageUrl!),
                                                      fit: BoxFit.fill,
                                                    )
                                                  : const Image(
                                                      image:
                                                          AssetImage(noImage),
                                                      width: 75,
                                                      height: 81,
                                                    ),
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            flex: 5,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  // mainAxisAlignment:
                                                  //     MainAxisAlignment.spaceEvenly,
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        'Sr.No : ${index + 1}',
                                                        style: const TextStyle(
                                                            color: textColor,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontSize: 10.0),
                                                        textAlign:
                                                            TextAlign.start,
                                                      ),
                                                    ),
                                                    // const VerticalDivider(),
                                                    // const SizedBox(
                                                    //   width: 10,
                                                    // ),

                                                    const Text('|'),
                                                    const SizedBox(
                                                      width: 10,
                                                    ),

                                                    Expanded(
                                                      child: Text(
                                                          medicines
                                                              .medicineName!,
                                                          maxLines: 2,
                                                          style: const TextStyle(
                                                              color:
                                                                  primaryTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: 14.0)),
                                                      flex: 4,
                                                    ),
                                                    // Align(
                                                    //     alignment: AlignmentDirectional.topStart,
                                                    //     child:

                                                    // ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            130,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text('Mrp',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      descriptionTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .safeBlockVertical! *
                                                                          1.2)),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text('Disc',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      descriptionTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .safeBlockVertical! *
                                                                          1.2)),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text('Rate',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      descriptionTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .safeBlockVertical! *
                                                                          1.2)),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text('Exp Date',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      descriptionTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .safeBlockVertical! *
                                                                          1.2)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: SizedBox(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            130,
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                              medicines
                                                                  .mrp
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .safeBlockVertical! *
                                                                          1.2)),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Text(
                                                              medicines.discount
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .safeBlockVertical! *
                                                                          1.2)),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                              medicines
                                                                  .mrp
                                                                  .toString(),
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .safeBlockVertical! *
                                                                          1.2)),
                                                        ),
                                                        Expanded(
                                                          flex: 2,
                                                          child: Text(
                                                              medicines
                                                                  .expireOn!,
                                                              textAlign:
                                                                  TextAlign
                                                                      .center,
                                                              style: TextStyle(
                                                                  color:
                                                                      primaryTextColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900,
                                                                  fontSize:
                                                                      SizeConfig
                                                                              .safeBlockVertical! *
                                                                          1.2)),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ],
                                    ),
                                    Align(
                                      alignment: AlignmentDirectional.bottomEnd,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, right: 10),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            // Expanded(
                                            //   flex: 1,
                                            //   child:

                                            const SizedBox(),
                                            Row(
                                              children: [
                                                Text('Qty : ',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            descriptionTextColor,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: SizeConfig
                                                                .safeBlockVertical! *
                                                            1.2)),
                                                Text(
                                                    medicines.quantity
                                                        .toString(),
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: primaryTextColor,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: SizeConfig
                                                                .safeBlockVertical! *
                                                            1.2)),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                Text('Total : ',
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color:
                                                            descriptionTextColor,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: SizeConfig
                                                                .safeBlockVertical! *
                                                            1.4)),
                                                Text(
                                                    "$rupeesString ${medicines.mrp}",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: primaryTextColor,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: SizeConfig
                                                                .safeBlockVertical! *
                                                            1.4)),
                                              ],
                                            ),

                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height:
                                          SizeConfig.safeBlockVertical! * 1.5,
                                    ),
                                    const Divider(),
                                  ],
                                ),
                              )),
                        ));
                // );
              }),
        ),
      )),
    );
  }

  void onOrderSubmit(String strAmount) {
    setState(() {
      isLoading = true;
    });

    paymentBloc.add(CreateOrderSubmittedEvent(strAmount));
  }

  void saveOrderRequest() {
    String strCustQuoteID =
        shopQuotationDetailModel.quotation!.customerQuotationId.toString();
    String strPaymentMethod = verifyCFModel.data!.paymentGroup!;
    String strPaymentStatus = "0";

    if (verifyCFModel.data!.paymentStatus == "SUCCESS") {
      strPaymentStatus = "1";
    } else {
      strPaymentStatus = "0";
    }

    shopQuotationDetailBloc.add(SaveQuoteSubmitEvent(strCustQuoteID,
        listQuoteId, strOrderID, strPaymentMethod, strPaymentStatus));
  }
}
