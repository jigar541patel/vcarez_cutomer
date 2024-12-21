import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/bloc/quotation_list_bloc.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/model/quotation_list_history_model.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/view/quotations_detail_screen.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/my_theme_button.dart';
import '../../../components/standard_regular_text.dart';
import '../../../utils/strings.dart';

class QuotationsReceivedListScreen extends StatefulWidget {
  const QuotationsReceivedListScreen({Key? key}) : super(key: key);

  @override
  State<QuotationsReceivedListScreen> createState() =>
      _QuotationsReceivedListScreenState();
}

class _QuotationsReceivedListScreenState
    extends State<QuotationsReceivedListScreen> {
  var demoList = [1, 2, 3, 4, 5];

  QuotationListBloc quotationListBloc = QuotationListBloc();

  QuotationHistoryListModel quotationHistoryListModel =
      QuotationHistoryListModel();

  String strOrderID = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (ModalRoute.of(context)!.settings.arguments != null) {
      //   //        arguments: {'exampleArgument': exampleArgument},
      //   // arguments['exampleArgument']
      //   final arg = ModalRoute.of(context)!.settings.arguments as Map;
      //   strOrderID = arg['id'];
      //   debugPrint("vcarez medicine list strTitle $strOrderID");
      quotationListBloc.add(GetQuotationList());

      context.read<CartProvider>().getData();
      // medicineDetailBloc.add(GetMedicineDetailEvent(strMedicineID));
      // }
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
                          height: 30.0,
                        ),
                        const Align(
                          alignment: Alignment.bottomLeft,
                          child: StandardCustomText(
                            label: quotations,
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                            fontSize: 24.0,
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
                child: BlocProvider(
                  create: (context) => quotationListBloc,
                  child: quotationList(),
                ))
          ],
        )));
  }

  Widget quotationList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .75,
      child: SingleChildScrollView(
          child: BlocConsumer<QuotationListBloc, QuotationListState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is OnQuotationListLoadedState) {
            quotationHistoryListModel = state.quotationHistoryListModel;
          }
        },
        builder: (context, state) {
          return state is OnQuotationListLoadedState
              ? ListView.builder(
                  itemCount: quotationHistoryListModel.quotations!.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (context, index) {
                    Quotations quotation =
                        quotationHistoryListModel.quotations![index];
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(8, 5, 7, 5),
                      child: GestureDetector(
                          onTap: () {
                            debugPrint("vacrez the click is called ");
                            Navigator.pushNamed(
                                context, routeQuotationDetailList,
                                arguments: {
                                  'id': quotation.id!.toString(),
                                }); //
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) =>
                            //           const QuotationsDetailListScreen()),
                            // );
                          },
                          child: Container(
                              height: 145,
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
                                    15.0, 15.0, 15.0, 5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            size: 12,
                                            Icons.access_time,
                                            color: descriptionTextColor,
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 2.0),
                                            child: Text(
                                                '${quotation.timeLeft} min left ',
                                                style: const TextStyle(
                                                    color: descriptionTextColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 10.0)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Align(
                                            alignment:
                                                AlignmentDirectional.center,
                                            child: quotation.customerPrescription !=
                                                        null &&
                                                    quotation
                                                            .customerPrescription!
                                                            .prescription !=
                                                        null
                                                ? Image(
                                                    height: 75,

                                                    width: 81,
                                                    errorBuilder:
                                                        (BuildContext context,
                                                            Object exception,
                                                            StackTrace?
                                                                stackTrace) {
                                                      return Image(
                                                          width: 75,
                                                          height: 81,
                                                          image: AssetImage(
                                                              noImage));
                                                    },
                                                    image: NetworkImage(quotation
                                                        .customerPrescription!
                                                        .prescription!),
                                                    // fit: BoxFit.scaleDown,
                                                  )
                                                : const Image(
                                                    image: AssetImage(noImage),
                                                    height: 75,
                                                    width: 81,
                                                  )
                                            //     Image(
                                            //   width: 75,
                                            //   height: 81,
                                            //   image:
                                            //       AssetImage(demoProductImage_),
                                            //   fit: BoxFit.scaleDown,
                                            // ),
                                            ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        Column(
                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: SizedBox(
                                                child: Row(
                                                  children: [
                                                    const Text('Quote :',
                                                        style: TextStyle(
                                                            color:
                                                                primaryTextColor,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            fontSize: 14.0)),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(quotation.quotationNo!,
                                                        style: const TextStyle(
                                                            color:
                                                                darkSkyBluePrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12.0)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: SizedBox(
                                                child: Row(
                                                  children: [
                                                    const Text('Date :',
                                                        style: TextStyle(
                                                            color:
                                                                primaryTextColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12.0)),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        quotation
                                                            .date
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                darkSkyBluePrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12.0)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(2.0),
                                              child: SizedBox(
                                                child: Row(
                                                  children: [
                                                    const Text('Time :',
                                                        style: TextStyle(
                                                            color:
                                                                primaryTextColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12.0)),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                        quotation
                                                            .time
                                                            .toString(),
                                                        style: const TextStyle(
                                                            color:
                                                                darkSkyBluePrimaryColor,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            fontSize: 12.0)),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: const [
                                            Text('',
                                                // 'View :',
                                                style: TextStyle(
                                                    color: primaryTextColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.0)),
                                            SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                ''
                                                // '000'
                                                ,
                                                style: TextStyle(
                                                    color:
                                                        darkSkyBluePrimaryColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.0)),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text('Quotes Rec’d: ',
                                                style: TextStyle(
                                                    color: primaryTextColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.0)),
                                            const SizedBox(
                                              width: 5,
                                            ),
                                            Text(
                                                quotation.quotsCount.toString(),
                                                style: const TextStyle(
                                                    color:
                                                        darkSkyBluePrimaryColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.0)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ))),
                    );
                  })
              : state is QuotationListLoadingState ||
                      state is AcceptQuoteSubmittingState
                  ? Container(
                      height: MediaQuery.of(context).size.height - 100,
                      child: const Center(child: CustomLoader()))
                  : const SizedBox();
        },
      )),
    );
  }
}
