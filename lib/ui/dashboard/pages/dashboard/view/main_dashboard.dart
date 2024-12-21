import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/bannerbloc/banner_list_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/categorybloc/category_list_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/homebloc/home_bloc.dart';
import 'package:vcarez_new/ui/searchdetailist/view/search_detail_list_screen.dart';
import 'package:vcarez_new/utils/colors_utils.dart';

import '../../../../../utils/images_utils.dart';
import '../../prescription/view/add_prescription.dart';
import '../../home/view/home_screen.dart';

import '../../notification/view/notification_screen.dart';
import '../../search/view/search_screen.dart';
import '../../setting/view/settings_screen.dart';

class MainDashBoard extends StatefulWidget {
  const MainDashBoard({Key? key}) : super(key: key);

  @override
  _MainDashState createState() => _MainDashState();
}

class _MainDashState extends State<MainDashBoard> {
  int currentTab =
      0; // to keep track of active tab index// to store nested tabs
  final PageStorageBucket bucket = PageStorageBucket();

  Widget currentScreen = const HomePage();

  // BlocProvider(
  //   create: (context) => HomeBloc(),
  //   child: const HomePage(),
  // ); // Our first view in viewport

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (currentTab == 0) {
            return true;
          }
          setState(() {
            currentTab = 0;
            currentScreen = BlocProvider(
              create: (context) => HomeBloc(),
              child: const HomePage(),
            );
          });
          return false;
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: bgColor,
          body: PageStorage(
            bucket: bucket,
            child: currentScreen,
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: darkSkyBluePrimaryColor,
            onPressed: () {
              setState(() {
                currentScreen =
                    AddPrescriptionPage(); // if user taps on this dashboard tab will be active
                currentTab = 2;
              });
            },
            child: SvgPicture.asset(
              addMenuIcon,
              height: 24,
              width: 24,
              color: whiteColor,
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: bottomAppBar(),
          ),
        ));
  }

  Widget bottomAppBar() {
    return BottomAppBar(
      color: whiteColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 10,
      child: Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(right: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentScreen =
                              const HomePage(); // if user taps on this dashboard tab will be active
                          currentTab = 0;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            homeMenuIcon,
                            height: 24,
                            width: 24,
                            color: currentTab == 0 ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          StandardCustomText(
                            label: 'DashBoard',
                            fontSize: 10.0,
                            color: currentTab == 0 ? Colors.blue : Colors.grey,
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentScreen =
                              SearchDetailListScreen(); // if user taps on this dashboard tab will be active
                          currentTab = 1;
                        });
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            searchMenuIcon,
                            height: 24,
                            width: 24,
                            color: currentTab == 1 ? Colors.blue : Colors.grey,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          StandardCustomText(
                            label: 'Search',
                            fontSize: 10.0,
                            color: currentTab == 1 ? Colors.blue : Colors.grey,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              width: 24.0,
            ),
            // Right Tab bar icons
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentScreen =
                            NotificationScreen(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          notificationMenuIcon,
                          height: 24,
                          width: 24,
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        StandardCustomText(
                          label: 'Notification',
                          fontSize: 10.0,
                          color: currentTab == 3 ? Colors.blue : Colors.grey,
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentScreen =
                            SettingsScreen(); // if user taps on this dashboard tab will be active
                        currentTab = 4;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SvgPicture.asset(
                          settingsMenuIcon,
                          height: 24,
                          width: 24,
                          color: currentTab == 4 ? Colors.blue : Colors.grey,
                        ),
                        const SizedBox(
                          height: 4.0,
                        ),
                        StandardCustomText(
                          label: 'Settings',
                          fontSize: 10.0,
                          color: currentTab == 4 ? Colors.blue : Colors.grey,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
