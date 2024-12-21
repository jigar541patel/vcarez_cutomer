import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/commonmodel/cart_provider.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/ui/dashboard/pages/notification/bloc/notification_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/notification/model/notification_list_model.dart';

import '../../../../../components/standard_regular_text.dart';
import '../../../../../utils/colors_utils.dart';
import '../../../../../utils/images_utils.dart';
import '../../../../../utils/route_names.dart';

class NotificationScreen extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<NotificationScreen> {
  var demoList = [1, 2, 3, 4, 5];
  NotificationBloc notificationBloc = NotificationBloc();
  NotificationListModel notificationListModel = NotificationListModel();

  @override
  void initState() {
    // TODO: implement initState

    initController();
    super.initState();
  }

  initController() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      notificationBloc.add(GetNotificationList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
            child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Column(
                children: [
                  topHeader(),
                  bottomContent(),
                ],
              ),
            ),
          ],
        )));
  }

  Widget bottomContent() {
    return Container(
      transform: Matrix4.translationValues(0.0, -55.0, 0.0),
      decoration: BoxDecoration(
          border: Border.all(
            color: bgColor,
          ),
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(20))),
      // height: MediaQuery.of(context).size.height * .75,
//               color: bgColor,
      child: Column(
        children: [
          BlocProvider(
            create: (context) => notificationBloc,
            child: notificationList(),
          ),
        ],
      ),
    );
  }

  Widget topHeader() {
    Widget imageAppLogo() => SvgPicture.asset(
          appLogo_,
          height: 18.0,
          width: 116.0,
        );
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
            child:   Align(
              alignment: Alignment.topLeft,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // InkWell(
                      //   onTap: () {
                      //     Navigator.pop(context);
                      //   },
                      //   child: const Icon(
                      //     Icons.arrow_back_ios,
                      //     color: whiteColor,
                      //   ),
                      // ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: imageAppLogo(),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, routeCartList);
                        },
                        child: Badge(
                          badgeContent: Consumer<CartProvider>(
                            builder: (context, value, child) {
                              return Text(
                                value.getCounter().toString(),
                              );
                            },
                          ),
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
                    // InkWell(
                    //     onTap: () {
                    //       Navigator.pushNamed(
                    //           context, routeCartList);
                    //     },
                    //     child: Badge(
                    //       badgeContent: Text(
                    //           cartListModel.cartItems != null
                    //               ? cartListModel.cartItems!.length
                    //                   .toString()
                    //               : "0"),
                    //       position: BadgePosition.bottomEnd(),
                    //       badgeColor: Colors.white,
                    //
                    //       child: SvgPicture.asset(
                    //         cartBadgeIcon,
                    //         height: 25,
                    //         width: 25,
                    //         fit: BoxFit.none,
                    //       ),
                    //       // (Icons.shopping_cart),
                    //     )),
                  )
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
          const Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: StandardCustomText(
                label: 'Notification',
                fontWeight: FontWeight.bold,
                color: whiteColor,
                fontSize: 22.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget notificationList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .70,
      child: BlocConsumer<NotificationBloc, NotificationState>(
        listener: (context, state) {
          // TODO: implement listener
          if (state is OnNotificationLoadedState) {
            notificationListModel = state.notificationListModel;
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
            child: SingleChildScrollView(
                child: state is NotificationLoadingState
                    ? const Center(child: CustomLoader())
                    : state is OnNotificationLoadedState
                        ? ListView.builder(
                            itemCount: notificationListModel.notifications !=
                                    null
                                ? notificationListModel.notifications!.length
                                : 0,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 5, 7, 5),
                                  child: GestureDetector(
                                      onTap: () {
                                        // debugPrint(
                                        //     "vacrez the click is called ");
                                      },
                                      child: notificationRow(index)));
                            })
                        : SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * .80,
                          )),
          );
        },
      ),
    );
  }

  Widget notificationRow(int index) {
    Notifications notifications = notificationListModel.notifications![index];
    return Container(
        height: 70,
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
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                      child: StandardCustomText(
                        align: TextAlign.start,
                        label: notifications.message != null
                            ? notifications.message!
                            : "",
                        color: primaryTextColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: SizedBox(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // const SizedBox(
                            //   width: 5,
                            // ),

                            Expanded(
                              flex: 2,
                              child: Text(
                                  notifications.title != null
                                      ? notifications.title!
                                      : "",
                                  style: TextStyle(
                                      color: greenDarkColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 12.0)),
                            ),
                            Expanded(
                                flex: 2,
                                child: Align(
                                  alignment: AlignmentDirectional.topEnd,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Icon(
                                        size: 12,
                                        Icons.access_time,
                                        color: descriptionTextColor,
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.0),
                                        child: Text('${index + 1}:00 min ago ',
                                            style: TextStyle(
                                                color: descriptionTextColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 10.0)),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
