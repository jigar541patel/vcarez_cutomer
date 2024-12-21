import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/components/my_theme_button.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/model/quotation_recieved_list_model.dart';
import 'package:vcarez_new/ui/shopquotationdetail/view/shop_detail_screen.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/standard_regular_text.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/strings.dart';
import '../../privilegeplan/view/privilage_plan_screen.dart';
import '../bloc/quotation_list_bloc.dart';

class QuotationsDetailListScreen extends StatefulWidget {
  const QuotationsDetailListScreen({Key? key}) : super(key: key);

  @override
  State<QuotationsDetailListScreen> createState() =>
      _QuotationsDetailListScreenState();
}

class _QuotationsDetailListScreenState
    extends State<QuotationsDetailListScreen> {
  var demoList = [1, 2, 3, 4, 5];
  QuotationListBloc quotationListBloc = QuotationListBloc();
  QuotationReceivedListModel quotationReceivedListModel =
      QuotationReceivedListModel();
  String strOrderID = "";
  late List<bool> _isChecked;
  List? listQuoteId = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        //        arguments: {'exampleArgument': exampleArgument},
        // arguments['exampleArgument']
        final arg = ModalRoute.of(context)!.settings.arguments as Map;
        strOrderID = arg['id'];
        debugPrint("vcarez medicine list strTitle $strOrderID");
        quotationListBloc.add(GetQuotationDetailReceivedListList(strOrderID));
        context.read<CartProvider>().getData();
        // medicineDetailBloc.add(GetMedicineDetailEvent(strMedicineID));
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
            create: (context) => quotationListBloc,
            child: SingleChildScrollView(
              child: SafeArea(
                  child: BlocConsumer<QuotationListBloc, QuotationListState>(
                      listener: (context, state) {
                // TODO: implement listener

                if (state is OnQuotationReceivedListLoadedState) {
                  quotationReceivedListModel = state.quotationReceivedListModel;
                  _isChecked = List<bool>.filled(
                      quotationReceivedListModel.quotations!.length, false);
                }

                if (state is AcceptQuoteSuccessState) {
                  WidgetsBinding.instance.addPostFrameCallback((_) async {
                    setState(() {
                      Navigator.pushReplacementNamed(context, routeMyOrderList);
                    });
                  });
                }
              }, builder: (context, state) {
                // return state is OnQuotationReceivedListLoadedState
                //     ?
                return Stack(
                  children: <Widget>[
                    Column(
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
                                        padding:
                                            const EdgeInsets.only(right: 15.0),
                                        child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                  context, routeCartList);
                                            },
                                            // child: ChangeNotifierProvider(
                                            //     create: (context) => CartListModel(),
                                            child: Badge(
                                              badgeContent:
                                                  Consumer<CartProvider>(
                                                builder:
                                                    (context, value, child) {
                                                  return Text(
                                                    value
                                                        .getCounter()
                                                        .toString(),
                                                    // style: const TextStyle(
                                                    //     color: Colors.white, fontWeight: FontWeight.bold),
                                                  );
                                                },
                                              ),
                                              // badgeContent: Text(cartListModel.cartItems !=
                                              //         null
                                              //     ? cartListModel.cartItems!.length.toString()
                                              //     : "0"),
                                              position:
                                                  BadgePosition.bottomEnd(),
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
                                  label: quotationsDetail,
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
                    Container(
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * .20,
                          right: 20.0,
                          left: 20.0),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 185.0,
                            width: MediaQuery.of(context).size.width,
                            child: Card(
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              color: Colors.white,
                              elevation: 4.0,
                              child: Align(
                                  alignment: AlignmentDirectional.center,
                                  child: state
                                          is OnQuotationReceivedListLoadedState
                                      ? quotationReceivedListModel.presImage !=
                                              null
                                          ? Image(
                                              height: 120,
                                              width: 225,
                                              image: NetworkImage(
                                                  quotationReceivedListModel
                                                      .presImage!),
                                              // fit: BoxFit.scaleDown,
                                            )
                                          : const Image(
                                              image: AssetImage(noImage),
                                              height: 120,
                                              width: 225,
                                            )
                                      : state is ErrorQuotationReceivedListLoadingState
                                          ? const Image(
                                              image: AssetImage(noImage),
                                              height: 120,
                                              width: 225,
                                            )
                                          : SizedBox()
                                  // : SizedBox(),
                                  ),
                            ),
                          ),
                          state is OnQuotationReceivedListLoadedState
                              ? quotationReceivedListModel
                                      .quotations!.isNotEmpty
                                  ? quotationDetailList()
                                  : CommonUtils.NoDataFoundPlaceholder(
                                      context,
                                      message: lblQuotationListEmpty,
                                      doubleHeight:
                                          MediaQuery.of(context).size.height *
                                              .15,
                                    )
                              : state is QuotationReceivedListLoadingState ||
                                      state is AcceptQuoteSubmittingState
                                  ? const Center(child: CustomLoader())
                                  : const SizedBox(),
                        ],
                      ),
                    )
                  ],
                );
                // : state is QuotationReceivedListLoadingState
                //     ? Center(child: CustomLoader())
                //     : SizedBox();
              })),
            )));
  }

  Widget quotationDetailList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .50,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 4,
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
                    itemCount: quotationReceivedListModel.quotations!.length,
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
                              Navigator.pushNamed(
                                context,
                                routeShopQuotationDetail,
                                arguments: {
                                  'id': quotationReceivedListModel
                                      .quotations![index].id!
                                      .toString(),
                                  'title': quotationReceivedListModel
                                      .quotations![index].shopName!
                                      .toString()
                                },
                              );
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //       builder: (context) =>
                              //           const ShopDetailScreen()),
                              // );
                            },
                            child: Container(
                                height: 60,
                                width: MediaQuery.of(context).size.width - 10,
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
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10))),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      15.0, 5.0, 15.0, 5.0),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Checkbox(
                                          value: _isChecked[index],
                                          onChanged: (bool? value) {
                                            setState(() {
                                              _isChecked[index] = value!;

                                              if (_isChecked[index] == true) {
                                                listQuoteId!.add(
                                                    quotationReceivedListModel
                                                        .quotations![index].id
                                                        .toString());
                                              } else {
                                                listQuoteId!.remove(
                                                    quotationReceivedListModel
                                                        .quotations![index].id
                                                        .toString());
                                              }
                                            });
                                          }),
                                      Text(
                                          // 'Shop ${index + 1}A ',
                                          quotationReceivedListModel
                                              .quotations![index].shopName!,
                                          style: const TextStyle(
                                              color: primaryTextColor,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0)),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                          "$rupeesString ${quotationReceivedListModel.quotations![index].total}",
                                          style: const TextStyle(
                                              color: darkSkyBluePrimaryColor,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 12.0)),
                                    ],
                                  ),
                                ))),
                      );
                    }),
              ],
            ),
          ),
          _isChecked.contains(true)
              ? Expanded(flex: 1, child: acceptRejectWidget())
              : SizedBox()
        ],
      ),
    );
  }

  Widget acceptRejectWidget() {
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
                  quotationListBloc
                      .add(AcceptQuoteSubmitEvent(strOrderID, listQuoteId!));

                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //       builder: (context) => const PaymentMethodScreen()),
                  // );
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
  }
}
