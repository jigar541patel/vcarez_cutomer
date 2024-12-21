import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/orderconfirm/bloc/order_confirm_bloc.dart';
import 'package:vcarez_new/ui/shopquotationdetail/model/order_accept_success_model.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/my_theme_button.dart';
import '../../../utils/route_names.dart';
import '../../../utils/strings.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  OrderAcceptSuccessModel orderAcceptSuccessModel = OrderAcceptSuccessModel();
  OrderConfirmBloc orderConfirmBloc = OrderConfirmBloc();

  // @override
  // void initState() {
  //   super.initState();
  // }
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final arg = ModalRoute.of(context)!.settings.arguments as Map;
        orderAcceptSuccessModel = arg['model'];

        // debugPrint("vcarez medicine list strQuoteID $strQuoteID");
        // debugPrint("vcarez medicine list strTitle $strTitle");
        orderConfirmBloc.add(GetOrderConfirmEvent(orderAcceptSuccessModel));
        context.read<CartProvider>().getData();
        // setState(() {
        //   strTitle = arg['title'];
        // });
      }
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
      body: BlocProvider(
        create: (context) => orderConfirmBloc,
        child: SafeArea(
            child: BlocConsumer<OrderConfirmBloc, OrderConfirmState>(
          listener: (context, state) {
            // TODO: implement listener

            if (state is OrderConfirmSuccessState) {
              orderAcceptSuccessModel = state.orderAcceptSuccessModel;
            }
          },
          builder: (context, state) {
            return state is OrderConfirmSuccessState
                ? Stack(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * .22,
                        child: Container(
                          padding: const EdgeInsets.only(
                              top: 10.0, bottom: 0.0, left: 16.0),
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
                                height: 40.0,
                              ),
                              const Align(
                                alignment: Alignment.bottomLeft,
                                child: StandardCustomText(
                                  label: orderConfirmation,
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
                          color: whiteColor,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10.0),
                              bottomRight: Radius.circular(0.0),
                              topLeft: Radius.circular(10.0),
                              bottomLeft: Radius.circular(0.0)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SingleChildScrollView(
                            child: Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  SvgPicture.asset(
                                    orderConfirmImage,
                                    height: 90.0,
                                    width: 90.0,
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(top: 20.0, bottom: 20),
                                    child: StandardCustomText(
                                        fontSize: 14,
                                        color: descriptionTextColor,
                                        align: TextAlign.center,
                                        label:
                                            'Your Order has been\nsuccessfully submitted!'),
                                  ),
                                  ListView.builder(
                                      itemCount: orderAcceptSuccessModel
                                          .order!.subOrders!.length,

//                                      itemCount: 2,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context, index) {
                                        SubOrders subOrderModel =
                                            orderAcceptSuccessModel
                                                .order!.subOrders![index];

                                        return Column(
                                          children: [
                                            Card(
                                              shape:
                                                  const RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  10))),
                                              color: Colors.white,
                                              elevation: 4.0,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    StandardCustomText(
                                                      label: subOrderModel
                                                          .shopName!,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      align: TextAlign.start,
                                                    ),
                                                    const SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          locationMarkerDarkIcon,
                                                          height: 17.0,
                                                          width: 15.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 8.0),
                                                          child: StandardCustomText(
                                                              label: subOrderModel
                                                                          .city !=
                                                                      null
                                                                  ? subOrderModel
                                                                      .city!
                                                                  : ""),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 7.0,
                                                    ),
                                                    Row(
                                                      children: [
                                                        SvgPicture.asset(
                                                          phoneIcon,
                                                          height: 17.0,
                                                          width: 15.0,
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 8.0),
                                                          child: StandardCustomText(
                                                              label: subOrderModel
                                                                          .shopContact !=
                                                                      null
                                                                  ? subOrderModel
                                                                      .shopContact!
                                                                  : ""),
                                                        ),
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 16.0,
                                                    ),
                                                    const Divider(),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        StandardCustomText(
                                                            label: 'Subtotal'),
                                                        StandardCustomText(
                                                          label: subOrderModel
                                                                      .subtotal !=
                                                                  null
                                                              ? "$rupeesString ${subOrderModel.subtotal.toString()}"
                                                              : "",
                                                          // '$rupeesString 200.00',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              darkSkyBluePrimaryColor,
                                                        )
                                                      ],
                                                    ),
                                                    const SizedBox(
                                                      height: 8.0,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        StandardCustomText(
                                                            label:
                                                                'Delivery fee'),
                                                        StandardCustomText(
                                                          label: subOrderModel
                                                                      .deliveryCharge !=
                                                                  null
                                                              ? "$rupeesString ${subOrderModel.deliveryCharge}"
                                                              : "",
                                                          // '$rupeesString 2100.00',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              darkSkyBluePrimaryColor,
                                                        )
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        );
                                      }),
                                  Card(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10))),
                                    color: Colors.white,
                                    elevation: 4.0,
                                    child: Container(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              StandardCustomText(
                                                  label: 'Subtotal'),
                                              StandardCustomText(
                                                label: orderAcceptSuccessModel
                                                            .order!.subtotal !=
                                                        null
                                                    ? '$rupeesString ${orderAcceptSuccessModel.order!.subtotal.toString()}'
                                                    : "",
                                                fontWeight: FontWeight.bold,
                                                color: darkSkyBluePrimaryColor,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 7.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              StandardCustomText(
                                                  label: 'Delivery Fee'),
                                              StandardCustomText(
                                                label: orderAcceptSuccessModel
                                                            .order!
                                                            .deliveryCharge !=
                                                        null
                                                    ? '$rupeesString ${orderAcceptSuccessModel.order!.deliveryCharge.toString()}'
                                                    : "0",
                                                fontWeight: FontWeight.bold,
                                                color: darkSkyBluePrimaryColor,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 7.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              StandardCustomText(label: 'SGST'),
                                              StandardCustomText(
                                                label: orderAcceptSuccessModel
                                                            .order!.sgst !=
                                                        null
                                                    ? '$rupeesString ${orderAcceptSuccessModel.order!.sgst.toString()}'
                                                    : "0",
                                                fontWeight: FontWeight.bold,
                                                color: darkSkyBluePrimaryColor,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 7.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              StandardCustomText(label: 'CGST'),
                                              StandardCustomText(
                                                label: orderAcceptSuccessModel
                                                            .order!.cgst !=
                                                        null
                                                    ? "$rupeesString ${orderAcceptSuccessModel.order!.cgst}"
                                                    : "",
                                                fontWeight: FontWeight.bold,
                                                color: darkSkyBluePrimaryColor,
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 16.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              StandardCustomText(
                                                  label: 'Total'),
                                              StandardCustomText(
                                                label: orderAcceptSuccessModel
                                                            .order!.total !=
                                                        null
                                                    ? '$rupeesString ${orderAcceptSuccessModel.order!.total}'
                                                    : "0",
                                                // '$rupeesString 2500.00',
                                                fontWeight: FontWeight.bold,
                                                color: darkSkyBluePrimaryColor,
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(top: 24.0),
                                    child: MyThemeButton(
                                      buttonText: 'My Orders',
                                      onPressed: () {

                                        Navigator.pushReplacementNamed(context, routeMyOrderList);
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : SizedBox();
          },
        )),
      ),
    );
  }
}
