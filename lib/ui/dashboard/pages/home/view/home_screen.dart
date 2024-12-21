import 'dart:async';

import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:skeletons/skeletons.dart';
import 'package:vcarez_new/components/common_horizontal_list_place_holder.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/cart/model/cart_list_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/banner_list_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/category_list_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/feature_brand_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/popular_medicine_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/search_medicine_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/trending_medicine_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/bannerbloc/banner_list_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/categorybloc/category_list_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/currentorder/bloc/current_orders_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/currentorder/model/current_order_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/feature_brand_bloc/feature_brand_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/homebloc/home_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/popularmedicinebloc/popular_medicine_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/trendingmedicinebloc/trending_medicine_bloc.dart';

import 'package:vcarez_new/ui/myprofile/view/my_profile_screen.dart';
import 'package:vcarez_new/utils/route_names.dart';
import '../../../../../commonmodel/cart_provider.dart';
import '../../../../../components/custom_snack_bar.dart';
import '../../../../../services/api/api_hitter.dart';
import '../../../../../services/repo/common_repo.dart';
import '../../../../../utils/CommonUtils.dart';
import '../../../../../utils/SizeConfig.dart';
import '../../../../../utils/colors_utils.dart';
import '../../../../../utils/images_utils.dart';
import '../../../../../utils/strings.dart';
import '../../../../storage/shared_pref_const.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // late TextEditingController _searchMedicineController;
  int _current = 0;
  bool ifPop = false;

  void pop() => setState(() => ifPop = true);
  var demoList = [1, 2, 3, 4, 5];
  var currentLocation = "";
  CartListModel cartListModel = CartListModel();

  BannerListModel bannerListModel = BannerListModel();
  FeatureBrandModel featureBrandModel = FeatureBrandModel();
  List<TopBanners>? topBanners;
  List<MiddleBanners>? middleBanners;
  List<BottomBanners>? bottomBanners;
  late List<Categories> categoriesList;
  final List<Map> myProducts =
      List.generate(8, (index) => {"id": index, "name": "Ayurvedic"}).toList();

  HomeBloc homeBloc = HomeBloc();
  BannerListBloc bannerListBloc = BannerListBloc();
  FeatureBrandBloc featureBrandBloc = FeatureBrandBloc();
  CategoryListBloc categoryListBloc = CategoryListBloc();
  CurrentOrdersBloc currentOrdersBloc = CurrentOrdersBloc();
  TrendingMedicineBloc trendingMedicineBloc = TrendingMedicineBloc();
  PopularMedicineBloc popularMedicineBloc = PopularMedicineBloc();
  PopularMedicineModel popularMedicineModel = PopularMedicineModel();
  TrendingMedicineModel trendingMedicineModel = TrendingMedicineModel();
  CurrentOrdersModel currentOrdersModel = CurrentOrdersModel();
  TextEditingController? medicineNameSearchController = TextEditingController();
  SearchResultModel searchResultModel = SearchResultModel();
  String token = "";
  CartProvider? cart;
  int intPopular = -1;
  int intTrending = -1;
  bool isLoading = false;

  Future<void> initController() async {
    // _searchMedicineController = TextEditingController();
    // homeBloc = BlocProvider.of<HomeBloc>(context);
    // categoryListBloc = BlocProvider.of<CategoryListBloc>(context);

    bannerListBloc.add(GetBannerList());
    categoryListBloc.add(GetCategoryList());
    currentOrdersBloc.add(GetCurrentOrderList());
    trendingMedicineBloc.add(GetTrendingMedicineList());
    homeBloc.add(GetCurrentLocationName());
    var storage = const FlutterSecureStorage();

    token = (await storage.read(key: keyUserToken))!;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Future.delayed(const Duration(seconds: 2), () {
        popularMedicineBloc.add(GetPopularMedicineList());
        getCartList();
        // homeBloc.add(GetHomeCartListEvent());
        featureBrandBloc.add(GetFeatureBrandList());
        context.read<CartProvider>().getData();
      });
    });
  }

  void disposeController() {
    // _searchMedicineController.dispose();
  }

  @override
  void initState() {
    ifPop = false;
    initController();
    // BackButtonInterceptor.add(myInterceptor, name: "home", context: context);
    super.initState();

    // BackButtonInterceptor.add(myInterceptor);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    // BackButtonInterceptor.remove(myInterceptor);
    super.dispose();
    disposeController();
  }

  Widget imageAppLogo() => SvgPicture.asset(
        appLogo_,
        height: SizeConfig.safeBlockVertical! * 2,
        width: SizeConfig.safeBlockHorizontal! * 12.6,
      );

  Widget profilePicImage() => InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyProfileScreen()),
        );
      },
      child: SvgPicture.asset(
        userPicPlaceHolder,
        height: SizeConfig.safeBlockVertical! * 5,
        width: SizeConfig.safeBlockHorizontal! * 5,
      ));

  // bool myInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
  //   print("BACK BUTTON!"); // Do
  //   if (stopDefaultButtonEvent) return false;
  //
  //   // If a dialog (or any other route) is open, don't run the interceptor.
  //   if (info.ifRouteChanged(context)) {
  //     getCartList();
  //     return false;
  //   }
  //
  //   if (ifPop) {
  //     getCartList();
  //
  //     return false;
  //   } else {
  //     getCartList();
  //     pop();
  //
  //     return true;
  //   }
  //   // Navigator.of(context).pop();
  //   // getCartList();
  //   // return true;
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    cart = Provider.of<CartProvider>(context);

    // return WillPopScope(
    //     onWillPop: () async {
    //       getCartList();
    //       return false;
    //     },
    //     child:
    return Scaffold(
        body: SafeArea(
            child: Stack(children: [
      SingleChildScrollView(
          child: Column(children: [
        topHeader(),
        bottomContent(),
      ])),
      isLoading
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.black.withOpacity(0.4),
              child: const Center(child: CustomLoader()))
          : const SizedBox(),
    ])));
  }

  Widget bottomContent() {
    return Container(
      transform: Matrix4.translationValues(0.0, -15.0, 0.0),
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
            create: (context) => bannerListBloc,
            child: topSlider(),
          ),
          BlocProvider(
              create: (context) => currentOrdersBloc,
              child: currentOrderPopularList()),
          BlocProvider(
              create: (context) => popularMedicineBloc,
              child: popularMedicineList()),
          BlocProvider(
            create: (context) => bannerListBloc,
            child: middleSlider(),
          ),
          BlocProvider(
            create: (context) => featureBrandBloc,
            child: featureBrandList(),
          ),
          BlocProvider(
            create: (context) => bannerListBloc,
            child: bottomSlider(),
          ),
          trendingProductCategory()
        ],
      ),
    );
  }

  /// Determine the current position of the device.
  ///
  /// When the location services are not enabled or permissions
  /// are denied the `Future` will return an error.

  Widget topHeader() {
    return BlocProvider(
      create: (context) => homeBloc,
      child: Container(
        height: MediaQuery.of(context).size.height * .25,
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
        child: BlocConsumer<HomeBloc, HomeState>(
          listener: (context, state) async {
            // TODO: implement listener
            if (state is OnLocationLoadedState) {
              currentLocation = state.strLocation!;
              // homeBloc.add(await GetBannerList());
              // homeBloc.add(await GetCategoryList());
            }
            debugPrint(
                "vcarez OnHomeCartListLoaded active is " + state.toString());

            if (state is AddToCartSuccessState) {
              // homeBloc.add(GetHomeCartListEvent());
              getCartList();
              // homeBloc.add(await GetCategoryList());
            }
            if (state is OnHomeCartListLoaded) {
              cartListModel = state.cartListModel;
              // homeBloc.add(await GetBannerList());
              // homeBloc.add(await GetCategoryList());
            }
          },

          // TODO: implement listener
          builder: (context, state) {
            return Column(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          profilePicImage(),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: imageAppLogo(),
                          ),
                        ],
                      ),
                      InkWell(
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
                      //),

                      // SvgPicture.asset(
                      //   cartIcon,
                      //   height: SizeConfig.safeBlockVertical! * 3.2,
                      //   width: SizeConfig.safeBlockHorizontal! * 3.2,
                      // )),
                    ],
                  ),
                ),
                SizedBox(
                  // height: 30.0,
                  height: SizeConfig.safeBlockVertical! * 2.5,
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      locationMarkerIcon,
                      height: SizeConfig.safeBlockVertical! * 1.8,
                      width: SizeConfig.safeBlockHorizontal! * 1.4,
                    ),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 1.7,
                    ),
                    Align(
                        alignment: Alignment.bottomLeft,
                        child: StandardCustomText(
                          label: currentLocation,
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: SizeConfig.safeBlockVertical! * 1.8,
                        )),
                    SizedBox(
                      width: SizeConfig.safeBlockHorizontal! * 1.5,
                    ),
                    SvgPicture.asset(
                      downArrowIcon,
                      height: SizeConfig.safeBlockVertical! * 1.4,
                      width: SizeConfig.safeBlockHorizontal! * 1.4,
                    ),
                  ],
                ),
                Container(
                  margin:
                      EdgeInsets.only(top: SizeConfig.safeBlockVertical! * 2.0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                    child: TypeAheadField(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller: medicineNameSearchController,
                        autofocus: false,
                        style: const TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 14),
                        decoration: InputDecoration(
                            enabledBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: whiteColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: const BorderSide(
                                color: whiteColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),

                            // icon: Icons.search,
                            filled: true,
                            fillColor: whiteColor,
                            prefixIcon: const Icon(
                              Icons.search,
                              color: Color(0xFF8A8F9C),
                              size: 24,
                            ),
                            hintText: "Search Medicine"),
                      ),
                      suggestionsCallback: (pattern) {
                        if (pattern.length > 2) {
                          // pattern="dollo";
                          return fetchSearchSuggestions(pattern);
                        } else {
                          return fetchSearchSuggestions("all");
                        }
                      },
                      transitionBuilder: (context, suggestionsBox, controller) {
                        return suggestionsBox;
                      },
                      itemBuilder: (context, SearchMedicines suggestion) {
                        return ListTile(
                            trailing: Text(suggestion.mrp != null
                                ? "$rupeesString ${suggestion.mrp}"
                                : ""),
                            title: Text(suggestion.name != null
                                ? suggestion.name.toString()
                                : ""));
                      },
                      onSuggestionSelected: (SearchMedicines suggestion) {
                        // your implementation here
                        if (mounted) {
                          setState(() {
                            medicineNameSearchController!.text =
                                suggestion.name!;
                            Navigator.pushNamed(context, routeMedicineDetails,
                                arguments: {
                                  'type': suggestion.type,
                                  'id': suggestion.id.toString(),
                                });

                            medicineNameSearchController!.text = "";
                            // textMRPController!.text = suggestion.mrp!.toString();
                            // textRateController!.text = suggestion.mrp!.toString();
                            // medicineID = suggestion.id;
                            // medicineType = suggestion.type;
                            // textQuantityController!.text = "1";
                          });
                        }
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget topSlider() {
    return BlocProvider(
      create: (context) => bannerListBloc,
      child: BlocConsumer<BannerListBloc, BannerListState>(
        listener: (context, state) {
          if (state is OnBannerLoaded) {
            topBanners = state.bannerListModel.data!.topBanners!;
          }
        },
        builder: (context, state) {
          debugPrint("vcarez the state bannerListBloc state is $state");

          return state is OnBannerLoaded
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: CarouselSlider(
                        // options: CarouselOptions(height: 200.0),
                        options: CarouselOptions(
                          height: SizeConfig.blockSizeVertical! * 26,
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.97,
                          aspectRatio: 2.0,
                          initialPage: 2,
                          onPageChanged: (index, reason) {
                            if (mounted) {
                              setState(() {
                                _current = index;
                              });
                            }
                          },
                        ),
                        items: topBanners!.map((element) {
                          return Builder(
                            builder: (BuildContext context) {
                              return InkWell(
                                  onTap: () {
                                    if (element.type == strBannerTypeSingle) {
                                      Navigator.pushNamed(
                                          context, routeMedicineDetails,
                                          // arguments: element.id.toString());
                                          arguments: {
                                            'type': element.type,
                                            'id': element.medicineId.toString(),
                                          });
                                    }
                                  },
                                  child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5.0),
                                      decoration: BoxDecoration(
                                          color: bgColor,
                                          borderRadius: const BorderRadius.all(
                                              const Radius.circular(20)),
                                          image: DecorationImage(
                                            image: NetworkImage(element.image!),
                                            fit: BoxFit.cover,
                                          )),
                                      child: Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                color: bgColor,
                                              ),
                                              color:
                                                  blackColor.withOpacity(0.5),
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(20))),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                15.0, 15.0, 8.0, 8.0),
                                            child: Column(
                                              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: const [
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: StandardCustomText(
                                                      label: 'Get',
                                                      color:
                                                          whiteTransparentColor,
                                                      fontWeight:
                                                          FontWeight.w100,
                                                      fontSize: 16.0),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: StandardCustomText(
                                                      label: '30% of',
                                                      color: whiteColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18.0),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: StandardCustomText(
                                                      label:
                                                          'on every order from',
                                                      color:
                                                          whiteTransparentColor,
                                                      fontSize: 16.0),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.all(4.0),
                                                  child: StandardCustomText(
                                                      label:
                                                          'Fast Med Pharmacy',
                                                      color: whiteColor,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 18.0),
                                                ),
                                              ],
                                            ),
                                          ))));
                            },
                          );
                        }).toList(),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: topBanners!.asMap().entries.map((entry) {
                        return GestureDetector(
//onTap: () => _controller.animateToPage(entry.key),
                          child: Container(
                            width: 7.0,
                            height: 7.0,
                            margin: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: (Theme.of(context).brightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                )
              : Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: _buildImage(),
                );
        },
      ),
    );
  }

  Future<List<SearchMedicines>> fetchSearchSuggestions(String pattern) async {
    debugPrint("vcarez the query is " + pattern);
    searchResultModel =
        await ApiController().getSearchMedicineList(token, pattern);
    return Future.value(searchResultModel.medicines ?? []);
  }

  Widget _buildImage() {
    return Container(
      child:
          // ListView.builder(
          //   physics: NeverScrollableScrollPhysics(),
          //   itemCount: 5,
          //   itemBuilder: (context, index) =>
          Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white),
          child: SkeletonItem(
              child: Column(
            children: [
              SkeletonAvatar(
                style: SkeletonAvatarStyle(
                  width: double.infinity,
                  height: SizeConfig.blockSizeVertical! * 25,
                  // minHeight: MediaQuery.of(context).size.height / 8,
                  // minHeight:   SizeConfig.blockSizeVertical! * 15,
                  // maxHeight: MediaQuery.of(context).size.height / 3,
                ),
              ),
            ],
          )),
        ),
      ),
      // ),
    );
  }

  Widget currentOrderPopularList() {
    return BlocConsumer<CurrentOrdersBloc, CurrentOrdersState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is OnCurrentOrderLoaded) {
          currentOrdersModel = state.currentOrdersModel;
        }
      },
      builder: (context, state) {
        return state is OnErrorCurrentOrder
            ? const SizedBox()
            : currentOrdersModel.orders != null &&
                    currentOrdersModel.orders!.length > 1
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    color: currentOrderBG,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(20),
                          // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                          child: StandardCustomText(
                              label: 'CURRENT ORDERS',
                              color: textColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        ),
                        state is OnCurrentOrderLoading
                            ? const Center(child: CustomLoader())
                            : state is OnCurrentOrderLoaded
                                ? Column(
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 5, 20, 5),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                routeQuotationHistory,
                                              ); //
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const QuotationsReceivedListScreen()),
                                              // );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                    border: Border.all(
                                                      color: whiteColor,
                                                    ),
                                                    color: whiteColor,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15.0,
                                                          15.0,
                                                          8.0,
                                                          15.0),
                                                  child: state
                                                          is OnCurrentOrderLoading
                                                      ? const CustomLoader()
                                                      : state
                                                              is OnCurrentOrderLoaded
                                                          ? currentOrdersModel
                                                                          .orders !=
                                                                      null &&
                                                                  currentOrdersModel
                                                                      .orders!
                                                                      .isNotEmpty
                                                              ? Column(
                                                                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child: StandardCustomText(
                                                                          label:
                                                                              "Order No. - ${currentOrdersModel.orders![0].quotationNo!}",
                                                                          color:
                                                                              textColor,
                                                                          fontWeight: FontWeight
                                                                              .w700,
                                                                          fontSize:
                                                                              18.0),
                                                                    ),
                                                                    Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              4.0),
                                                                      child: StandardCustomText(
                                                                          label:
                                                                              "Status - ${currentOrdersModel.orders![0].quotCount!} Quotes Received",
                                                                          color:
                                                                              greyColor,
                                                                          fontWeight: FontWeight
                                                                              .w100,
                                                                          fontSize:
                                                                              16.0),
                                                                    ),
                                                                  ],
                                                                )
                                                              : const SizedBox()
                                                          : const SizedBox(),
                                                )),
                                          )),
                                      Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20.0, 20, 20, 5),
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.pushNamed(
                                                context,
                                                routeQuotationHistory,
                                              ); //
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const QuotationsReceivedListScreen()),
                                              // );
                                            },
                                            child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                decoration: BoxDecoration(
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.grey
                                                            .withOpacity(0.5),
                                                        spreadRadius: 5,
                                                        blurRadius: 7,
                                                        offset: const Offset(0,
                                                            3), // changes position of shadow
                                                      ),
                                                    ],
                                                    border: Border.all(
                                                      color: whiteColor,
                                                    ),
                                                    color: whiteColor,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(
                                                                10))),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          15.0,
                                                          15.0,
                                                          8.0,
                                                          15.0),
                                                  child: currentOrdersModel
                                                                  .orders !=
                                                              null &&
                                                          currentOrdersModel
                                                                  .orders!
                                                                  .length >
                                                              1
                                                      ? Column(
                                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: StandardCustomText(
                                                                  label:
                                                                      "Order No. - ${currentOrdersModel.orders![1].quotationNo!}",
                                                                  color:
                                                                      textColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  fontSize:
                                                                      18.0),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: StandardCustomText(
                                                                  label:
                                                                      "Status - ${currentOrdersModel.orders![1].quotCount!} Quotes Received",
                                                                  color:
                                                                      greyColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w100,
                                                                  fontSize:
                                                                      16.0),
                                                            ),
                                                          ],
                                                        )
                                                      : const SizedBox(),
                                                )),
                                          )),
                                    ],
                                  )
                                : const SizedBox(),
                      ],
                    ),
                  )
                : const SizedBox();
      },
    );
  }

  Widget popularMedicineList() {
    return BlocProvider(
        create: (context) => popularMedicineBloc,
        child: BlocConsumer<PopularMedicineBloc, PopularMedicineState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is OnPopularLoaded) {
              popularMedicineModel = state.popularMedicineModel;
              // popularMedicineModel.medicines!.clear();
              debugPrint("vcarez the popular  is called " +
                  popularMedicineModel.medicines!.length.toString());
            }
          },
          // TODO: implement listener
          // },
          builder: (context, state) {
            return (popularMedicineModel.medicines != null &&
                    popularMedicineModel.medicines!.isNotEmpty)
                ? Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Padding(
                            padding: EdgeInsets.fromLTRB(7, 15, 7, 10),
                            // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                            child: StandardCustomText(
                                label: 'POPULAR MEDICINES',
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0),
                          ),
                          Padding(
                              padding: const EdgeInsets.all(20),
                              // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, routeMedicineList,
                                      arguments: {
                                        'title': 'Popular Medicine',
                                        'model': popularMedicineModel,
                                      });
                                  // arguments: ScreenArguments(
                                  //   'Extract Arguments Screen',
                                  //   'This message is extracted in the build method.',
                                  // ),
                                  // Navigator.push(
                                  //   context,
                                  //   MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           const MedicineListScreen()),
                                  // );
                                },
                                child: const StandardCustomText(
                                    label: 'VIEW ALL',
                                    color: darkSkyBluePrimaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              )),
                        ],
                      ),
                      SizedBox(
                          height: 250,
                          width: MediaQuery.of(context).size.width,
                          child:

                              // BlocConsumer<PopularMedicineBloc,
                              //     PopularMedicineState>(
                              //   listener: (context, state) {
                              //     // TODO: implement listener
                              //     if (state is OnPopularLoaded) {
                              //       popularMedicineModel = state.popularMedicineModel;
                              //
                              //       debugPrint("vacrez the popular  is called ");
                              //     }
                              //   },
                              //   builder: (context, state) {
                              //     return

                              state is PopularLoading
                                  ? const CustomHorizontalPlaceLoader()
                                  : state is OnPopularLoaded
                                      // ? popularMedicineModel.medicines != null
                                      ? ListView.builder(
                                          itemCount:
                                              popularMedicineModel.medicines !=
                                                      null
                                                  ? popularMedicineModel
                                                      .medicines!.length
                                                  : 0,
                                          shrinkWrap: true,
                                          padding: EdgeInsets.zero,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      8, 5, 7, 5),
                                              child: GestureDetector(
                                                  onTap: () {
                                                    debugPrint(
                                                        "vacrez the click is called ");

                                                    Navigator.pushNamed(context,
                                                        routeMedicineDetails,
                                                        arguments: {
                                                          'type':
                                                              popularMedicineModel
                                                                  .medicines![
                                                                      index]
                                                                  .type,
                                                          'id':
                                                              popularMedicineModel
                                                                  .medicines![
                                                                      index]
                                                                  .id
                                                                  .toString(),
                                                        }).then(
                                                      (value) async {
                                                        if (value != null) {
                                                          // debugPrint(
                                                          //     "vcarez geting token reading access token have is $token");

                                                          getCartList();
                                                          // homeBloc.add(GetHomeCartListEvent());
                                                          //refresh here
                                                        }
                                                      },
                                                    );
                                                    // Navigator.pushNamed(
                                                    //     context, routeMedicineDetails,
                                                    //     arguments: {
                                                    //       'type': popularMedicineModel
                                                    //           .medicines![index].type,
                                                    //       'id': popularMedicineModel
                                                    //           .medicines![index].id
                                                    //           .toString(),
                                                    //     }).then(value) async {
                                                    //   if (value != null) {
                                                    //     token = await storage.read(
                                                    //         key: keyUserToken);
                                                    //
                                                    //     debugPrint(
                                                    //         "vcarez geting token reading access token have is $token");
                                                    //
                                                    //     registerBloc.add(GetProfileEvent());
                                                    //     //refresh here
                                                    //   }
                                                    // },
                                                    // arguments: popularMedicineModel
                                                    //     .medicines![index].id
                                                    //     .toString());
                                                  },
                                                  child: Container(
                                                      width: 168,
                                                      height: 218,
                                                      decoration: BoxDecoration(
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors.grey
                                                                  .withOpacity(
                                                                      0.5),
                                                              spreadRadius: 1,
                                                              blurRadius: 1,
                                                              offset: const Offset(
                                                                  0,
                                                                  3), // changes position of shadow
                                                            ),
                                                          ],
                                                          border: Border.all(
                                                            color: whiteColor,
                                                          ),
                                                          color: whiteColor,
                                                          borderRadius:
                                                              const BorderRadius
                                                                      .all(
                                                                  Radius
                                                                      .circular(
                                                                          10))),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                5.0,
                                                                5.0,
                                                                5.0,
                                                                5.0),
                                                        child: Column(
                                                          // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(2.0),
                                                              child: SizedBox(
                                                                width: 150,
                                                                child: Text(
                                                                    popularMedicineModel
                                                                        .medicines![
                                                                            index]
                                                                        .name!,
                                                                    maxLines: 2,
                                                                    style: const TextStyle(
                                                                        color:
                                                                            textColor,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w700,
                                                                        fontSize:
                                                                            12.0)),
                                                              ),
                                                            ),
                                                            StandardCustomText(
                                                                label: popularMedicineModel
                                                                    .medicines![
                                                                        index]
                                                                    .packInfo!,
                                                                color:
                                                                    greyColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w100,
                                                                fontSize: 10.0),
                                                            Expanded(
                                                                child: Row(
                                                              children: [
                                                                StandardCustomText(
                                                                    label:
                                                                        '$rupeesString ${popularMedicineModel.medicines![index].mrp.toString()}',
                                                                    color:
                                                                        greyColor,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w900,
                                                                    fontSize:
                                                                        12.0),
                                                                const Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              5.0),
                                                                  child: StandardCustomText(
                                                                      label:
                                                                          '9% off',
                                                                      color:
                                                                          darkSkyBluePrimaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontSize:
                                                                          11.0),
                                                                ),
                                                              ],
                                                            )),
                                                            Align(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .center,
                                                              child: popularMedicineModel
                                                                          .medicines![
                                                                              index]
                                                                          .imageUrl !=
                                                                      null
                                                                  ? Image(
                                                                      width: 75,
                                                                      height:
                                                                          81,
                                                                      image: NetworkImage(popularMedicineModel
                                                                          .medicines![
                                                                              index]
                                                                          .imageUrl!),
                                                                      fit: BoxFit
                                                                          .scaleDown,
                                                                    )
                                                                  : const Image(
                                                                      image: AssetImage(
                                                                          noImage),
                                                                      width: 75,
                                                                      height:
                                                                          81,
                                                                    ),

                                                              // Image(
                                                              //   width: 75,
                                                              //   height: 81,
                                                              //   // image: AssetImage(demoProductImage_),
                                                              //   fit: BoxFit.cover,
                                                              // ),
                                                            ),
                                                            BlocProvider(
                                                              create:
                                                                  (context) =>
                                                                      homeBloc,
                                                              child: Align(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .center,
                                                                  child:
                                                                      Padding(
                                                                          padding: const EdgeInsetsDirectional.fromSTEB(
                                                                              10,
                                                                              0,
                                                                              20,
                                                                              0),
                                                                          child: BlocBuilder<
                                                                              HomeBloc,
                                                                              HomeState>(
                                                                            builder:
                                                                                (context, state) {
                                                                              // if(state is AddToCartSuccessState)
                                                                              //   {
                                                                              //     homeBloc.add(GetHomeCartListEvent());
                                                                              //   }
                                                                              return TextButton(
                                                                                style: TextButton.styleFrom(
                                                                                  backgroundColor: currentOrderBG, // Background Color
                                                                                ),
                                                                                onPressed: () async {
                                                                                  var connectivityResult = await (Connectivity().checkConnectivity());
                                                                                  if (connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi) {
                                                                                    // onAddToCart(String strMedicineID, String? strMedicineName,
                                                                                    // String? strMedicineImageUrl, String? strMedicineMrp,
                                                                                    // String? strMedicineType, String? strPackaging,
                                                                                    // String? strPackageInfo) {

                                                                                    intPopular = index;
                                                                                    intTrending = -1;

                                                                                    if (mounted) {
                                                                                      setState(() {
                                                                                        isLoading = true;
                                                                                      });
                                                                                    }

                                                                                    cart!.addCounter();
                                                                                    handleAddToCart(popularMedicineModel.medicines![index].id.toString(), popularMedicineModel.medicines![index].name!, popularMedicineModel.medicines![index].imageUrl!, popularMedicineModel.medicines![index].mrp.toString(), popularMedicineModel.medicines![index].type, popularMedicineModel.medicines![index].packInfo, popularMedicineModel.medicines![index].packInfo);
                                                                                  } else {
                                                                                    ScaffoldMessenger.of(context).showSnackBar(createMessageSnackBar(errorNoInternet));
                                                                                  }

                                                                                  // Navigator.push(
                                                                                  //   context,
                                                                                  //   MaterialPageRoute(
                                                                                  //       builder: (context) =>
                                                                                  //           const UploadPrescriptionWidget()),
                                                                                  // );
                                                                                },
                                                                                child: Padding(
                                                                                  padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 5, bottom: 5),
                                                                                  child: Center(
                                                                                    child: (state is AddToCartSubmittingState)
                                                                                        ? intPopular == index
                                                                                            ? const SizedBox(
                                                                                                width: 20,
                                                                                                height: 20,
                                                                                                child: CircularProgressIndicator(
                                                                                                  color: darkSkyBluePrimaryColor,
                                                                                                ),
                                                                                              )
                                                                                            : (state is AddToCartSuccessState)
                                                                                                ? const StandardCustomText(fontSize: 12, color: darkSkyBluePrimaryColor, label: "ADD TO CART")
                                                                                                : const StandardCustomText(fontSize: 12, color: darkSkyBluePrimaryColor, label: "ADD TO CART")
                                                                                        : const StandardCustomText(fontSize: 12, color: darkSkyBluePrimaryColor, label: "ADD TO CART"),
                                                                                  ),
                                                                                ),
                                                                              );
                                                                            },
                                                                          ))),
                                                            ),
                                                          ],
                                                        ),
                                                      ))),
                                            );
                                          })
                                      : const SizedBox()
                          //   },
                          // ),
                          ),
                    ],
                  )
                : SizedBox();
          },
        ));
  }

  void onAddToCart(
      String strMedicineID,
      String? strMedicineName,
      String? strMedicineImageUrl,
      String? strMedicineMrp,
      String? strMedicineType,
      String? strPackaging,
      String? strPackageInfo,
      BuildContext context) {
    // Medicine? medicine = popularMedicineModel.medicine;

    if (!homeBloc.isClosed) {
      homeBloc.add(AddToCartMedicineEvent(
        strMedicineID,
        strMedicineName ?? "",
        strMedicineImageUrl,
        strMedicineType ?? "",
        strMedicineMrp ?? "",
        strPackaging ?? "",
        strPackageInfo ?? "",
      ));
    } else {
      homeBloc.add(AddToCartMedicineEvent(
        strMedicineID,
        strMedicineName ?? "",
        strMedicineImageUrl,
        strMedicineType ?? "",
        strMedicineMrp ?? "",
        strPackaging ?? "",
        strPackageInfo ?? "",
      ));
    }
  }

  handleAddToCart(
      String strMedicineID,
      String? strMedicineName,
      String? strMedicineImageUrl,
      String? strMedicineMrp,
      String? strMedicineType,
      String? strPackaging,
      String? strPackageInfo) async {
    var requestBody = {
      "medicine_id": strMedicineID,
      "name": strMedicineName,
      "image_url": strMedicineImageUrl,
      "type": strMedicineType,
      "mrp": strMedicineMrp,
      "packaging": strPackaging,
      "pack_info": strPackageInfo,
    };

    var storage = FlutterSecureStorage();

    String? token = await storage.read(key: keyUserToken);
    debugPrint("vcarez customer reading access token have is $token");
    ApiResponse responseData =
        await ApiController().addToCart(token!, requestBody);
    // showLoader.value = false;
    debugPrint("vcarez customer update we have is ${responseData.message}");

    if (responseData.success) {
      CommonUtils.utils.showToast(responseData.message);
      // emit.call(AddToCartSuccessState());
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      getCartList();
    } else {
      CommonUtils.utils.showToast(
          // responseData.status as int+
          responseData.message as String);
      // emit.call(AddToCartFailureState());
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      getCartList();
      // showLoader = false;
    }
  }

  getCartList() async {
    var storage = const FlutterSecureStorage();

    String? token = await storage.read(key: keyUserToken);
    debugPrint("vcarez customer reading access token have is $token");
    CartListModel responseData = await ApiController().getCartList(token!);

    if (responseData.success!) {
      // CommonUtils.utils.showToast(responseData.message as String);
      debugPrint("vcarez OnBannerLoaded emited ");
      if (mounted) {
        setState(() {
          cartListModel = responseData;
          CommonUtils.cartListModel = responseData;
          context.read<CartProvider>().setData(cartListModel.cartItems!.length);
        });
      }
      // emit(OnHomeCartListLoaded(responseData));
    } else {
      CommonUtils.utils.showToast(responseData.message as String);
      debugPrint("vcarez ErrorDataLoading emited ");
    }
  }

  Widget trendingMedicineList() {
    return BlocProvider(
      create: (context) => trendingMedicineBloc,
      child: SizedBox(
        height: 250,
        width: MediaQuery.of(context).size.width,
        child: BlocConsumer<TrendingMedicineBloc, TrendingMedicineState>(
          listener: (context, state) {
            // TODO: implement listener
            if (state is OnTrendingLoaded) {
              trendingMedicineModel = state.trendingMedicineModel;
            }
          },
          builder: (context, state) {
            return state is TrendingLoading
                ? const CustomHorizontalPlaceLoader()
                : state is OnTrendingLoaded
                    ? (trendingMedicineModel.medicines != null &&
                            trendingMedicineModel.medicines!.isNotEmpty)
                        ? ListView.builder(
                            itemCount: trendingMedicineModel.medicines!.length,
                            shrinkWrap: true,
                            padding: EdgeInsets.zero,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.fromLTRB(8, 5, 7, 5),
                                child: GestureDetector(
                                    onTap: () {
                                      debugPrint("vacrez the click is called ");

                                      Navigator.pushNamed(
                                          context, routeMedicineDetails,
                                          arguments: {
                                            // 'type': "non-rx",
                                            'type': trendingMedicineModel
                                                .medicines![index].type,
                                            'id': trendingMedicineModel
                                                .medicines![index].id
                                                .toString(),
                                          });
                                      // arguments: trendingMedicineModel
                                      //     .medicines![index].id
                                      //     .toString());
                                    },
                                    child: Container(
                                        width: 168,
                                        height: 218,
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.5),
                                                spreadRadius: 1,
                                                blurRadius: 1,
                                                offset: const Offset(0,
                                                    3), // changes position of shadow
                                              ),
                                            ],
                                            border: Border.all(
                                              color: whiteColor,
                                            ),
                                            color: whiteColor,
                                            borderRadius:
                                                const BorderRadius.all(
                                                    Radius.circular(10))),
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              5.0, 5.0, 5.0, 5.0),
                                          child: Column(
                                            // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: SizedBox(
                                                  width: 150,
                                                  child: Text(
                                                      trendingMedicineModel
                                                          .medicines![index]
                                                          .name!,
                                                      maxLines: 2,
                                                      style: const TextStyle(
                                                          color: textColor,
                                                          fontWeight:
                                                              FontWeight.w700,
                                                          fontSize: 12.0)),
                                                ),
                                              ),
                                              StandardCustomText(
                                                  label: trendingMedicineModel
                                                      .medicines![index]
                                                      .packInfo!,
                                                  color: greyColor,
                                                  fontWeight: FontWeight.w100,
                                                  fontSize: 10.0),
                                              Expanded(
                                                  child: Row(
                                                children: [
                                                  StandardCustomText(
                                                      label:
                                                          '$rupeesString ${trendingMedicineModel.medicines![index].mrp.toString()}',
                                                      color: greyColor,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                      fontSize: 12.0),
                                                  const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5.0),
                                                    child: StandardCustomText(
                                                        label: '9% off',
                                                        color:
                                                            darkSkyBluePrimaryColor,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 11.0),
                                                  ),
                                                ],
                                              )),
                                              Align(
                                                alignment:
                                                    AlignmentDirectional.center,
                                                child: trendingMedicineModel
                                                            .medicines![index]
                                                            .imageUrl !=
                                                        null
                                                    ? Image(
                                                        width: 75,
                                                        height: 81,
                                                        image: NetworkImage(
                                                            trendingMedicineModel
                                                                .medicines![
                                                                    index]
                                                                .imageUrl!),
                                                        fit: BoxFit.scaleDown,
                                                      )
                                                    : const Image(
                                                        image:
                                                            AssetImage(noImage),
                                                        width: 75,
                                                        height: 81,
                                                      ),

                                                // Image(
                                                //   width: 75,
                                                //   height: 81,
                                                //   // image: AssetImage(demoProductImage_),
                                                //   fit: BoxFit.cover,
                                                // ),
                                              ),
                                              Align(
                                                  alignment:
                                                      AlignmentDirectional
                                                          .center,
                                                  child: BlocProvider(
                                                    create: (context) =>
                                                        homeBloc,
                                                    child: Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                        child: Padding(
                                                            padding:
                                                                const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                    10,
                                                                    0,
                                                                    20,
                                                                    0),
                                                            child: BlocBuilder<
                                                                HomeBloc,
                                                                HomeState>(
                                                              builder: (context,
                                                                  state) {
                                                                return TextButton(
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    backgroundColor:
                                                                        currentOrderBG, // Background Color
                                                                  ),
                                                                  onPressed:
                                                                      () async {
                                                                    var connectivityResult =
                                                                        await (Connectivity()
                                                                            .checkConnectivity());
                                                                    if (connectivityResult ==
                                                                            ConnectivityResult
                                                                                .mobile ||
                                                                        connectivityResult ==
                                                                            ConnectivityResult.wifi) {
                                                                      // onAddToCart(String strMedicineID, String? strMedicineName,
                                                                      // String? strMedicineImageUrl, String? strMedicineMrp,
                                                                      // String? strMedicineType, String? strPackaging,
                                                                      // String? strPackageInfo) {
                                                                      intTrending =
                                                                          index;
                                                                      intPopular =
                                                                          -1;
                                                                      if (mounted) {
                                                                        setState(
                                                                            () {
                                                                          isLoading =
                                                                              true;
                                                                        });
                                                                      }
                                                                      cart!
                                                                          .addCounter();
                                                                      handleAddToCart(
                                                                        trendingMedicineModel
                                                                            .medicines![index]
                                                                            .id
                                                                            .toString(),
                                                                        trendingMedicineModel
                                                                            .medicines![index]
                                                                            .name!,
                                                                        trendingMedicineModel
                                                                            .medicines![index]
                                                                            .imageUrl!,
                                                                        trendingMedicineModel
                                                                            .medicines![index]
                                                                            .mrp
                                                                            .toString(),
                                                                        trendingMedicineModel
                                                                            .medicines![index]
                                                                            .type,
                                                                        trendingMedicineModel
                                                                            .medicines![index]
                                                                            .packInfo,
                                                                        trendingMedicineModel
                                                                            .medicines![index]
                                                                            .packInfo,
                                                                      );
                                                                    } else {
                                                                      ScaffoldMessenger.of(
                                                                              context)
                                                                          .showSnackBar(
                                                                              createMessageSnackBar(errorNoInternet));
                                                                    }

                                                                    // Navigator.push(
                                                                    //   context,
                                                                    //   MaterialPageRoute(
                                                                    //       builder: (context) =>
                                                                    //           const UploadPrescriptionWidget()),
                                                                    // );
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left:
                                                                            5.0,
                                                                        right:
                                                                            5.0,
                                                                        top: 5,
                                                                        bottom:
                                                                            5),
                                                                    child:
                                                                        Center(
                                                                      child: (state
                                                                              is AddToCartSubmittingState)
                                                                          ? intTrending == index
                                                                              ? const SizedBox(
                                                                                  width: 20,
                                                                                  height: 20,
                                                                                  child: CircularProgressIndicator(
                                                                                    color: darkSkyBluePrimaryColor,
                                                                                  ),
                                                                                )
                                                                              : (state is AddToCartSuccessState)
                                                                                  ? const StandardCustomText(fontSize: 12, color: darkSkyBluePrimaryColor, label: "ADD TO CART")
                                                                                  : const StandardCustomText(fontSize: 12, color: darkSkyBluePrimaryColor, label: "ADD TO CART")
                                                                          : const StandardCustomText(fontSize: 12, color: darkSkyBluePrimaryColor, label: "ADD TO CART"),
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ))),
                                                  )),
                                              // Padding(
                                              //   padding: EdgeInsets.all(4.0),
                                              //   child: StandardCustomText(
                                              //       label:
                                              //           'Status - 3 Quotes Received',
                                              //       color: greyColor,
                                              //       fontWeight: FontWeight.w100,
                                              //       fontSize: 16.0),
                                              // ),
                                            ],
                                          ),
                                        ))),
                              );
                            })
                        : const SizedBox()
                    : const SizedBox();
            // : const SizedBox();
          },
        ),
      ),
    );
  }

  Widget middleSlider() {
    return BlocConsumer<BannerListBloc, BannerListState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is OnBannerLoaded) {
          middleBanners = state.bannerListModel.data!.middleBanners;
        }
      },
      builder: (context, state) {
        return state is OnBannerLoaded
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CarouselSlider(
                      // options: CarouselOptions(height: 200.0),
                      options: CarouselOptions(
                        height: SizeConfig.blockSizeVertical! * 26,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.97,
                        aspectRatio: 2.0,
                        initialPage: 2,
                        onPageChanged: (index, reason) {
                          if (mounted) {
                            setState(() {
                              _current = index;
                            });
                          }
                        },
                      ),
                      items: middleBanners!.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return InkWell(
                                onTap: () {
                                  if (i.type == strBannerTypeSingle) {
                                    Navigator.pushNamed(
                                        context, routeMedicineDetails,
                                        arguments: {
                                          'type': i.type,
                                          'id': i.medicineId.toString(),
                                        } // arguments: i.id.toString()
                                        );
                                  }
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(20)),
                                        image: DecorationImage(
                                          image: NetworkImage(i.image!),
                                          fit: BoxFit.cover,
                                        )),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: bgColor,
                                          ),
                                          color: blackColor.withOpacity(0.5),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                    )));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: middleBanners!.asMap().entries.map((entry) {
                      return GestureDetector(
                        //onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 7.0,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _buildImage(),
              );
      },
    );
  }

  Widget featureBrandList() {
    return BlocConsumer<FeatureBrandBloc, FeatureBrandState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is OnFeatureBrandLoaded) {
          featureBrandModel = state.featureBrandModel;
        }
      },
      builder: (context, state) {
        return state is OnFeatureBrandLoaded
            ? featureBrandModel.brands != null &&
                    featureBrandModel.brands!.isNotEmpty
                ? Container(
                    height: 240,
                    width: MediaQuery.of(context).size.width,
                    color: currentOrderBG,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: const EdgeInsets.fromLTRB(7, 15, 7, 10),
                              // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                              child: const StandardCustomText(
                                  label: 'FEATURED BRANDS',
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(20),
                            //   // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                            //   child: InkWell(
                            //       onTap: () {
                            //         Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //               builder: (context) =>
                            //                   const FeaturedBrandListScreen()),
                            //         );
                            //       },
                            //       child: const StandardCustomText(
                            //           label: 'VIEW ALL',
                            //           color: darkSkyBluePrimaryColor,
                            //           fontWeight: FontWeight.bold,
                            //           fontSize: 12.0)),
                            // ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: SizeConfig.safeBlockVertical! * 18,
                            width: MediaQuery.of(context).size.width,
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
                            child: ListView.builder(
                                itemCount: featureBrandModel.brands != null
                                    ? featureBrandModel.brands!.isNotEmpty
                                        ? featureBrandModel.brands!.length
                                        : 0
                                    : 0,
                                shrinkWrap: true,
                                padding: EdgeInsets.zero,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  Brands brand =
                                      featureBrandModel.brands![index];
                                  return Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 5, 0, 5),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, routeFeatureBrandDetail);

                                          // Navigator.push(
                                          //   context,
                                          //   MaterialPageRoute(
                                          //       builder: (context) =>
                                          //           const FeaturedBrandListScreen()),
                                          // );
                                        },
                                        child: Container(
                                            width: SizeConfig
                                                    .safeBlockHorizontal! *
                                                20.0,
                                            height:
                                                SizeConfig.safeBlockVertical! *
                                                    20.0,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: whiteColor,
                                                ),
                                                color: whiteColor,
                                                borderRadius:
                                                    const BorderRadius.all(
                                                        Radius.circular(1))),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      5.0, 10.0, 5.0, 5.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Align(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      child:
                                                          // Image(
                                                          //     width: SizeConfig
                                                          //         .safeBlockHorizontal! *
                                                          //         11.2,
                                                          //     height: SizeConfig
                                                          //         .safeBlockVertical! *
                                                          //         9,
                                                          //     image: AssetImage(mamaEarthLogo),

                                                          brand.image != null
                                                              ? Image(
                                                                  width: SizeConfig
                                                                          .safeBlockHorizontal! *
                                                                      11.2,
                                                                  height: SizeConfig
                                                                          .safeBlockVertical! *
                                                                      9,
                                                                  image: NetworkImage(
                                                                      brand
                                                                          .image!),
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )
                                                              : Image(
                                                                  image: AssetImage(
                                                                      noImage),
                                                                  width: SizeConfig
                                                                          .safeBlockHorizontal! *
                                                                      11.2,
                                                                  height: SizeConfig
                                                                          .safeBlockVertical! *
                                                                      9,
                                                                  fit: BoxFit
                                                                      .fill,
                                                                )),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                            .fromLTRB(
                                                        2, 10, 2, 2.0),
                                                    child: SizedBox(
                                                      child: Center(
                                                        child: Text(
                                                            brand.name != null
                                                                ? brand.name!
                                                                : "",
                                                            textAlign: TextAlign
                                                                .center,
                                                            style: TextStyle(
                                                                color:
                                                                    textColor,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                fontSize: SizeConfig
                                                                        .safeBlockVertical! *
                                                                    1.2)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ))),
                                  );
                                }),
                          ),
                        ),

                        // ),
                      ],
                    ),
                  )
                : SizedBox()
            : SizedBox();
      },
    );
  }

  Widget bottomSlider() {
    return BlocConsumer<BannerListBloc, BannerListState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is OnBannerLoaded) {
          bottomBanners = state.bannerListModel.data!.bottomBanners;
        }
      },
      builder: (context, state) {
        return state is OnBannerLoaded
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: CarouselSlider(
                      // options: CarouselOptions(height: 200.0),
                      options: CarouselOptions(
                        height: SizeConfig.blockSizeVertical! * 26,
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.97,
                        aspectRatio: 2.0,
                        initialPage: 2,
                        onPageChanged: (index, reason) {
                          if (mounted) {
                            setState(() {
                              _current = index;
                            });
                          }
                        },
                      ),
                      items: bottomBanners!.map((i) {
                        return Builder(
                          builder: (BuildContext context) {
                            return InkWell(
                                onTap: () {
                                  if (i.type == strBannerTypeSingle) {
                                    Navigator.pushNamed(
                                        context, routeMedicineDetails,
                                        arguments: {
                                          'type': i.type,
                                          'id': i.medicineId.toString(),
                                        } // arguments: i.id.toString()
                                        );
                                    // arguments: i.id.toString());
                                  }
                                },
                                child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius: const BorderRadius.all(
                                            const Radius.circular(20)),
                                        image: DecorationImage(
                                          image: NetworkImage(i.image!),
                                          fit: BoxFit.cover,
                                        )),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: bgColor,
                                          ),
                                          color: blackColor.withOpacity(0.5),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                    )));
                          },
                        );
                      }).toList(),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: middleBanners!.asMap().entries.map((entry) {
                      return GestureDetector(
                        //onTap: () => _controller.animateToPage(entry.key),
                        child: Container(
                          width: 7.0,
                          height: 7.0,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 4.0),
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: (Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.white
                                      : Colors.black)
                                  .withOpacity(
                                      _current == entry.key ? 0.9 : 0.4)),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              )
            : Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: _buildImage(),
              );
      },
    );
  }

  Widget trendingProductCategory() {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: currentOrderBG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Padding(
                padding: const EdgeInsets.fromLTRB(7, 15, 7, 10),
                // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                child: const StandardCustomText(
                    label: 'TRENDING PRODUCTS',
                    color: textColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, routeTrendingMedicineList,
                          arguments: {
                            'title': 'Trending Products',
                            'model': trendingMedicineModel,
                          });
                    },
                    child: const StandardCustomText(
                        label: 'VIEW ALL',
                        color: darkSkyBluePrimaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 12.0)),
              ),
            ],
          ),
          trendingMedicineList(),
          BlocProvider(
            create: (context) => categoryListBloc,
            child: categoryList(),
          ),
          // ),
        ],
      ),
    );
  }

  Widget categoryList() {
    return BlocConsumer<CategoryListBloc, CategoryListState>(
      listener: (context, state) {
        // TODO: implement listener

        if (state is OnCategoryLoaded) {
          categoriesList = state.categoriesListModel.categories!;
        }
      },
      builder: (context, state) {
        debugPrint("vcarez the state CategoryListBloc state is $state");
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Padding(
                  padding: EdgeInsets.fromLTRB(7, 15, 7, 10),
                  // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                  child: StandardCustomText(
                      label: 'SEARCH BY CATEGORY',
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
                // Padding(
                //   padding: EdgeInsets.all(20),
                //   // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                //   child: StandardCustomText(
                //       label: 'VIEW ALL',
                //       color: darkSkyBluePrimaryColor,
                //       fontWeight: FontWeight.bold,
                //       fontSize: 12.0),
                // ),
              ],
            ),
            state is OnCategoryLoaded
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GridView.builder(
                        itemCount: categoriesList.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 20,
                                mainAxisSpacing: 20,
                                mainAxisExtent: 77),
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, routeCategoryMedicineList,
                                    arguments: {
                                      'title': categoriesList[index].name,
                                      'id': categoriesList[index].id.toString(),
                                    }); //  arguments: categoriesList[index].id);
                                // CategoryMedicineListScreen
                              },
                              child: Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: const Offset(0,
                                              3), // changes position of shadow
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
                                        15.0, 15.0, 8.0, 15.0),
                                    child: Center(
                                      child: Row(
                                        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Image(
                                                  width: SizeConfig
                                                          .safeBlockVertical! *
                                                      4.2,
                                                  height: SizeConfig
                                                          .safeBlockVertical! *
                                                      4.2,

                                                  errorBuilder: (BuildContext
                                                          context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                    return Image(
                                                        width: SizeConfig
                                                                .safeBlockVertical! *
                                                            4.2,
                                                        height: SizeConfig
                                                                .safeBlockVertical! *
                                                            4.2,
                                                        image: const AssetImage(
                                                            noImage));
                                                  },
                                                  image: NetworkImage(
                                                      categoriesList[index]
                                                          .imageUrl!),
                                                  fit: BoxFit.cover,
                                                  // image: const AssetImage(
                                                  //     ayurvedicImage),
                                                  // fit: BoxFit.cover,
                                                )),
                                          ),
                                          Center(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Container(
                                                width: SizeConfig
                                                        .blockSizeHorizontal! *
                                                    25.0,
                                                child: StandardCustomText(
                                                    label: categoriesList[index]
                                                        .name!,
                                                    maxlines: 2,
                                                    align: TextAlign.start,
                                                    style: TextStyle(
                                                        color: greyColor,
                                                        // maxlines: 2,
                                                        fontWeight:
                                                            FontWeight.w100,
                                                        fontSize: SizeConfig
                                                                .safeBlockVertical! *
                                                            1.4)),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )));
                        }),
                  )
                : _buildImage(),
          ],
        );
      },
    );
  }
}
