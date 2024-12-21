import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/trending_medicine_model.dart';
import 'package:vcarez_new/ui/myorderlist/bloc/my_order_list_bloc.dart';
import 'package:vcarez_new/ui/myorderlist/model/my_order_list_model.dart';
import 'package:vcarez_new/ui/trendingmedicinelist/bloc/trending_medicine_list_bloc.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../../../components/my_form_field.dart';
import '../../../components/standard_regular_text.dart';
import '../../../utils/route_names.dart';
import '../../../utils/strings.dart';
import '../../dashboard/pages/home/parentbloc/trendingmedicinebloc/trending_medicine_bloc.dart';
import '../../medicinedetails/view/medicine_details.dart';

class MyOrderListScreen extends StatefulWidget {
  const MyOrderListScreen({Key? key}) : super(key: key);

  @override
  State<MyOrderListScreen> createState() => _MyOrderListScreenState();
}

class _MyOrderListScreenState extends State<MyOrderListScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _searchMedicineController;
  var demoList = [1, 2, 3, 4, 5];

  MyOrderListBloc myOrderListBloc = MyOrderListBloc();
  MyOrderListModel myOrderListModel = MyOrderListModel();
  String strTitle = "";

  int selectedTab = 0;

  // TrendingMedicineModel medicineListModel = TrendingMedicineModel();

  void initController() {
    _userNameController = TextEditingController();
    _searchMedicineController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      myOrderListBloc.add(GetMyOrderList());
    });
  }

  void disposeController() {
    _userNameController.dispose();
    _searchMedicineController.dispose();
  }

  @override
  void initState() {
    initController();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    disposeController();
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
            child: BlocProvider(
              create: (context) => myOrderListBloc,
              child: BlocConsumer<MyOrderListBloc, MyOrderListState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is OnMyOrderListLoadedState) {
                    myOrderListModel = state.myOrderListModel;
                  }
                },
                builder: (context, state) {
                  return state is MyOrderListLoadingState
                      ? Container(
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: CustomLoader(),
                          ),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: MediaQuery.of(context).size.height * .25,
                              padding: const EdgeInsets.only(
                                  top: 10.0,
                                  bottom: 0.0,
                                  left: 16.0,
                                  right: 16.0),
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
                                        // SvgPicture.asset(
                                        //   cartIcon,
                                        //   height: 30.0,
                                        //   width: 30.0,
                                        // ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30.0,
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(7, 15, 7, 10),
                                    // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                                    child: Align(
                                        alignment:
                                            AlignmentDirectional.topStart,
                                        child: BlocConsumer<MyOrderListBloc,
                                            MyOrderListState>(
                                          listener: (context, state) {
                                            // TODO: implement listener
                                            if (state is OnMedicineListLoaded) {
                                              // strTitle = state.strTitle;
                                              // medicineListModel =
                                              //     state.popularMedicineModel;
                                            }
                                          },
                                          builder: (context, state) {
                                            return const StandardCustomText(
//                                label: 'Popular Medicine',
                                                label: "My Orders",
                                                align: TextAlign.start,
                                                color: whiteColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 22.0);
                                          },
                                        )),
                                  ),
                                  // Container(
                                  //   margin: const EdgeInsets.only(
                                  //       left: 5, top: 15.0, bottom: 15, right: 5),
                                  //   child: CustomFormField(
                                  //     controller: _searchMedicineController,
                                  //     labelText: searchMedicine,
                                  //     validator: (value) {
                                  //       if (value == null || value.isEmpty) {
                                  //         return usernameError;
                                  //       }
                                  //       return null;
                                  //     },
                                  //     icon: searchMenuIcon,
                                  //     isRequire: true,
                                  //     textInputAction: TextInputAction.next,
                                  //     textInputType: TextInputType.text,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            upperTabBar(),
                            selectedTab == 0 ? newOrderList() : pastOrderList(),
                          ],
                        );
                },
              ),
            ),
          ),
        ));
  }

  Widget upperTabBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width - 10,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(1),
                spreadRadius: 1,
                blurRadius: 2,
                offset: const Offset(0, 3), // changes position of shadow
              ),
            ],
            border: Border.all(
              color: whiteColor,
            ),
            color: whiteColor,
            borderRadius: const BorderRadius.all(Radius.circular(10))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedTab = 0;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: StandardCustomText(
                              label: "Current Order ",
                              color: selectedTab == 0
                                  ? darkSkyBluePrimaryColor
                                  : greyColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: selectedTab == 0
                              ? Container(
                                  width: 50,
                                  color: darkSkyBluePrimaryColor,
                                  height: 3,
                                )
                              : const SizedBox(),
                        )
                      ],
                    ))),
            Expanded(
                child: InkWell(
                    onTap: () {
                      setState(() {
                        selectedTab = 1;
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 10.0),
                          child: StandardCustomText(
                              label: "Past Order ",
                              color: selectedTab == 1
                                  ? darkSkyBluePrimaryColor
                                  : greyColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: selectedTab == 1
                              ? Container(
                                  width: 50,
                                  color: darkSkyBluePrimaryColor,
                                  height: 3,
                                )
                              : const SizedBox(),
                        )
                      ],
                    ))),
          ],
        ),
      ),
    );
  }

  Widget newOrderList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 30.0),
        child: SingleChildScrollView(
            child: myOrderListModel.newOrders == null
                ? Container(
                    height: MediaQuery.of(context).size.height * .75,
                    child: Center(
                      child: Text("No Current Order Found"),
                    ),
                  )
                : myOrderListModel.newOrders!.isEmpty
                    ? Container(
                        height: MediaQuery.of(context).size.height * .75,
                        child: Center(
                          child: Text("No Current Order Found"),
                        ),
                      )
                    : ListView.builder(
                        itemCount: myOrderListModel.newOrders != null
                            ? myOrderListModel.newOrders!.length
                            : 0,
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
                                  // Navigator.pushNamed(context, routeMedicineDetails,
                                  //     arguments:
                                  //         myOrderListModel.orders![index].id.toString());
                                },
                                child: Container(
                                    height: 135,
                                    width: MediaQuery.of(context).size.width - 10,
                                    decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: const Offset(
                                                0, 3), // changes position of shadow
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
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Align(
                                            alignment:
                                                AlignmentDirectional.bottomEnd,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                const StandardCustomText(
                                                    label: "Total Amount : ",
                                                    color: greyColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 11.0),
                                                StandardCustomText(
                                                    label: myOrderListModel
                                                                .newOrders![index]
                                                                .total !=
                                                            null
                                                        ? "$rupeesString ${myOrderListModel.newOrders![index].total!}"
                                                        : "",
                                                    maxlines: 2,
                                                    color: greyColor,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12.0),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    myOrderListModel
                                                                .newOrders![index]
                                                                .shop !=
                                                            null
                                                        ? "Order Id : #"
                                                        : "",
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14.0)),
                                                Text(
                                                    myOrderListModel
                                                                .newOrders![index]
                                                                .orderNumber !=
                                                            null
                                                        ? myOrderListModel
                                                            .newOrders![index]
                                                            .orderNumber!
                                                        : "",
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w700,
                                                        fontSize: 14.0)),
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Text(
                                                myOrderListModel.newOrders![index]
                                                            .shop !=
                                                        null
                                                    ? myOrderListModel
                                                        .newOrders![index].shop!
                                                    : "",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0)),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(2.0),
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                    myOrderListModel
                                                                .newOrders![index]
                                                                .orderStatus !=
                                                            null
                                                        ? "Order Status : "
                                                        : "",
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w500,
                                                        fontSize: 12.0)),
                                                Text(
                                                    myOrderListModel
                                                                .newOrders![index]
                                                                .orderNumber !=
                                                            null
                                                        ? myOrderListModel
                                                                    .newOrders![
                                                                        index]
                                                                    .orderStatus ==
                                                                0
                                                            ? "Order Received"
                                                            : myOrderListModel
                                                                        .newOrders![
                                                                            index]
                                                                        .orderStatus ==
                                                                    1
                                                                ? "Order Accepted"
                                                                : myOrderListModel
                                                                            .newOrders![
                                                                                index]
                                                                            .orderStatus ==
                                                                        2
                                                                    ? "Order is Ready"
                                                                    : myOrderListModel
                                                                                .newOrders![
                                                                                    index]
                                                                                .orderStatus ==
                                                                            3
                                                                        ? "Order is on the way"
                                                                        : myOrderListModel.newOrders![index].orderStatus ==
                                                                                4
                                                                            ? "Order Delivered"
                                                                            : ""
                                                        : "",
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                        color: textColor,
                                                        fontWeight: FontWeight.w600,
                                                        fontSize: 12.0)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))),
                          );
                        })),
      ),
    );
  }

  Widget pastOrderList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height ,
      child: Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
        child: SingleChildScrollView(
            child: myOrderListModel.pastOrders == null
                ? Container(
              height: MediaQuery.of(context).size.height * .55,
              child: Center(
                child: Text("No Past Order Found"),
              ),
            )
                : myOrderListModel.pastOrders!.isEmpty
                ? Container(
              height: MediaQuery.of(context).size.height * .55,
              child: Center(
                child: Text("No Past Order Found"),
              ),
            )
                : ListView.builder(
                    itemCount: myOrderListModel.pastOrders != null
                        ? myOrderListModel.pastOrders!.length
                        : 0,
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
                              // Navigator.pushNamed(context, routeMedicineDetails,
                              //     arguments:
                              //         myOrderListModel.orders![index].id.toString());
                            },
                            child: Container(
                                height: 135,
                                width: MediaQuery.of(context).size.width - 10,
                                decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 1,
                                        offset: const Offset(
                                            0, 3), // changes position of shadow
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
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Align(
                                        alignment: AlignmentDirectional.bottomEnd,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            const StandardCustomText(
                                                label: "Total Amount : ",
                                                color: greyColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11.0),
                                            StandardCustomText(
                                                label: myOrderListModel
                                                            .pastOrders![index]
                                                            .total !=
                                                        null
                                                    ? "$rupeesString ${myOrderListModel.pastOrders![index].total!}"
                                                    : "",
                                                maxlines: 2,
                                                color: greyColor,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 12.0),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                myOrderListModel.pastOrders![index]
                                                            .shop !=
                                                        null
                                                    ? "Order Id : #"
                                                    : "",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.0)),
                                            Text(
                                                myOrderListModel.pastOrders![index]
                                                            .orderNumber !=
                                                        null
                                                    ? myOrderListModel
                                                        .pastOrders![index]
                                                        .orderNumber!
                                                    : "",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 14.0)),
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Text(
                                            myOrderListModel
                                                        .pastOrders![index].shop !=
                                                    null
                                                ? myOrderListModel
                                                    .pastOrders![index].shop!
                                                : "",
                                            maxLines: 2,
                                            style: const TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.0)),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                                myOrderListModel.pastOrders![index]
                                                            .orderStatus !=
                                                        null
                                                    ? "Order Status : "
                                                    : "",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 12.0)),
                                            Text(
                                                myOrderListModel.pastOrders![index]
                                                            .orderNumber !=
                                                        null
                                                    ? myOrderListModel
                                                                .pastOrders![index]
                                                                .orderStatus ==
                                                            0
                                                        ? "Order Received"
                                                        : myOrderListModel
                                                                    .pastOrders![
                                                                        index]
                                                                    .orderStatus ==
                                                                1
                                                            ? "Order Accepted"
                                                            : myOrderListModel
                                                                        .pastOrders![
                                                                            index]
                                                                        .orderStatus ==
                                                                    2
                                                                ? "Order is Ready"
                                                                : myOrderListModel
                                                                            .pastOrders![
                                                                                index]
                                                                            .orderStatus ==
                                                                        3
                                                                    ? "Order is on the way"
                                                                    : myOrderListModel
                                                                                .pastOrders![
                                                                                    index]
                                                                                .orderStatus ==
                                                                            4
                                                                        ? "Order Delivered"
                                                                        : ""
                                                    : "",
                                                maxLines: 2,
                                                style: const TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 12.0)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ))),
                      );
                    })),
      ),
    );
  }
}
