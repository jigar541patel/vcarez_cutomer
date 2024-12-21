import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/parentbloc/feature_brand_bloc/feature_brand_bloc.dart';
import 'package:vcarez_new/ui/feature_detail/bloc/feature_detail_bloc.dart';
import 'package:vcarez_new/ui/feature_detail/model/featured_detail_model.dart';
import 'package:vcarez_new/ui/privilegeplan/view/privilage_plan_screen.dart';
import 'package:vcarez_new/ui/quotationrecievedhistory/view/quotations_detail_screen.dart';
import 'package:vcarez_new/utils/SizeConfig.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/my_theme_button.dart';
import '../../../utils/route_names.dart';
import '../../../utils/strings.dart';
import '../model/feature_product_list_model.dart';

class FeaturedBrandDetailScreen extends StatefulWidget {
  const FeaturedBrandDetailScreen({Key? key}) : super(key: key);

  @override
  State<FeaturedBrandDetailScreen> createState() =>
      _FeaturedBrandDetailScreenState();
}

class _FeaturedBrandDetailScreenState extends State<FeaturedBrandDetailScreen> {
  FeatureDetailBloc featureDetailBloc = FeatureDetailBloc();
  FeaturedBrandDetailModel featuredBrandDetailModel =
      FeaturedBrandDetailModel();
  FeatureProductListModel featureProductListModel = FeatureProductListModel();

  @override
  void initState() {
    super.initState();
    featureDetailBloc.add(GetFeaturedBrandDetail());

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      //   Future.delayed(const Duration(seconds: 2), () {

      context.read<CartProvider>().getData();

      //   });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  var demoList = [1, 2, 3, 4, 5];
  int _current = 0;

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
        create: (context) => featureDetailBloc,
        child: Stack(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * .30,
              child: Container(
                padding:
                    const EdgeInsets.only(top: 24.0, bottom: 50.0, left: 16.0),
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
                      height: 40,
                    ),
                    const Align(
                      alignment: Alignment.bottomLeft,
                      child: StandardCustomText(
                        label: 'Featured Brands',
                        fontWeight: FontWeight.bold,
                        color: whiteColor,
                        fontSize: 24.0,
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
              child: BlocConsumer<FeatureDetailBloc, FeatureDetailState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is OnFeaturedBrandDetailLoaded) {
                    featuredBrandDetailModel = state.featuredBrandDetailModel;
                    // Future.delayed(const Duration(seconds: 2), () {
                    featureDetailBloc.add(GetFeaturedDetailProductList());

                    // });
                  }
                },
                builder: (context, state) {
                  return state is FeaturedBrandDetailLoading
                      // || FeaturedProductListLoading
                      ? Center(child: CustomLoader())
                      :
                      // state is OnFeaturedBrandDetailLoaded
                      SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              topDealsList(),
                              topSlider(),
                              topBrandList(),
                              popularMedicineList(),
                            ],
                          ),
                        );
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  Widget popularMedicineList() {
    return BlocConsumer<FeatureDetailBloc, FeatureDetailState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is OnFeaturedProductListLoaded) {
          featureProductListModel = state.featureProductListModel;
        }
      },
      builder: (context, state) {
        return featureProductListModel.medicines != null
            ? Container(
                color: currentOrderBG,
                //  height: MediaQuery.of(context).size.height * .75,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(7, 15, 7, 10),
                      // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                      child: StandardCustomText(
                          label: 'ALL PRODUCTS',
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
                    SingleChildScrollView(
                        physics: NeverScrollableScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: ListView.builder(
                              itemCount: featureProductListModel.medicines !=
                                      null
                                  ? featureProductListModel.medicines!.length
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
                                        debugPrint(
                                            "vacrez the click is called ");
                                        // Navigator.pushNamed(context, routeMedicineDetails,
                                        //     arguments: medicineListModel.medicines![index].id
                                        //         .toString());

                                        Navigator.pushNamed(
                                            context, routeMedicineDetails,
                                            arguments: {
                                              'type': featureProductListModel
                                                  .medicines![index].type,
                                              'id': featureProductListModel
                                                  .medicines![index].id
                                                  .toString(),
                                            } // arguments: i.id.toString()
                                            );
                                      },
                                      child: Container(
                                          height: 135,
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
                                                15.0, 15.0, 15.0, 5.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional
                                                              .center,
                                                      child: Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .center,
                                                        child: featureProductListModel
                                                                    .medicines![
                                                                        index]
                                                                    .imageUrl !=
                                                                null
                                                            ? Image(
                                                                width: 75,
                                                                height: 81,
                                                                image: NetworkImage(
                                                                    featureProductListModel
                                                                        .medicines![
                                                                            index]
                                                                        .imageUrl!),
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                              )
                                                            : const Image(
                                                                image:
                                                                    AssetImage(
                                                                        noImage),
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
                                                      // child: Image(
                                                      //   width: 75,
                                                      //   height: 81,
                                                      //   image: AssetImage(demoProductImage_),
                                                      //   fit: BoxFit.scaleDown,
                                                      // ),
                                                    ),
                                                    const SizedBox(
                                                      width: 20,
                                                    ),
                                                    Column(
                                                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  2.0),
                                                          child: SizedBox(
                                                            child: Container(
                                                              // width: 120,
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width -
                                                                  150,
                                                              child: Text(
                                                                  featureProductListModel
                                                                      .medicines![
                                                                          index]
                                                                      .name!,
                                                                  maxLines: 2,
                                                                  style: TextStyle(
                                                                      color:
                                                                          textColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          12.0)),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        StandardCustomText(
                                                            label:
                                                                featureProductListModel
                                                                    .medicines![
                                                                        index]
                                                                    .packInfo!,
                                                            color: greyColor,
                                                            fontWeight:
                                                                FontWeight.w100,
                                                            fontSize: 10.0),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width -
                                                              145,
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceBetween,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  StandardCustomText(
                                                                      label: featureProductListModel.medicines![index].mrp != null
                                                                          ? "$rupeesString ${featureProductListModel.medicines![index].mrp!}"
                                                                          : "",
                                                                      //'$rupeesString 200',
                                                                      maxlines:
                                                                          2,
                                                                      color:
                                                                          greyColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w900,
                                                                      fontSize:
                                                                          12.0),
                                                                  // Padding(
                                                                  //   padding: EdgeInsets.only(
                                                                  //       left: 5.0),
                                                                  //   child: StandardCustomText(
                                                                  //       label: '9% off',
                                                                  //       color:
                                                                  //           darkSkyBluePrimaryColor,
                                                                  //       fontWeight:
                                                                  //           FontWeight.w900,
                                                                  //       fontSize: 11.0),
                                                                  // ),
                                                                ],
                                                              ),
                                                              Align(
                                                                  alignment:
                                                                      AlignmentDirectional
                                                                          .bottomEnd,
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets.fromLTRB(
                                                                            1.0,
                                                                            5,
                                                                            5,
                                                                            5),
                                                                    child:
                                                                        Container(
                                                                      // width: 110,
//                                                color: currentOrderBG,
                                                                      margin: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              1.0),
                                                                      decoration: BoxDecoration(
                                                                          border: Border.all(
                                                                            color:
                                                                                currentOrderBG,
                                                                          ),
                                                                          color: currentOrderBG,
                                                                          borderRadius: const BorderRadius.all(Radius.circular(7))),
                                                                      child:
                                                                          const Padding(
                                                                        padding:
                                                                            EdgeInsets.all(8.0),
                                                                        child:
                                                                            StandardCustomText(
                                                                          label:
                                                                              'ADD',
                                                                          fontSize:
                                                                              12,
                                                                          fontWeight:
                                                                              FontWeight.w900,
                                                                          color:
                                                                              darkSkyBluePrimaryColor,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  )),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ))),
                                );
                              }),
                        )),
                  ],
                ),
              )
            : SizedBox();
      },
    );
  }

  Widget topDealsList() {
    return featuredBrandDetailModel.deals != null
        ? Container(
            height: 240,
            width: MediaQuery.of(context).size.width,
            color: currentOrderBG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(7, 15, 7, 10),
                      // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                      child: StandardCustomText(
                          label: 'TOP DEALS',
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: ListView.builder(
                        itemCount: featuredBrandDetailModel.deals!.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Deals deal = featuredBrandDetailModel.deals![index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Container(
                                width: SizeConfig.safeBlockHorizontal! * 20.0,
                                height: SizeConfig.safeBlockVertical! * 20.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: whiteColor,
                                    ),
                                    color: whiteColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(1))),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 10.0, 5.0, 5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Align(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: deal.image != null
                                              ? Image(
                                                  width: SizeConfig
                                                          .safeBlockHorizontal! *
                                                      11.2,
                                                  height: SizeConfig
                                                          .safeBlockVertical! *
                                                      9,
                                                  image:
                                                      NetworkImage(deal.image!),
                                                  fit: BoxFit.fill,
                                                )
                                              : Image(
                                                  image: AssetImage(noImage),
                                                  width: SizeConfig
                                                          .safeBlockHorizontal! *
                                                      11.2,
                                                  height: SizeConfig
                                                          .safeBlockVertical! *
                                                      9,
                                                  fit: BoxFit.fill,
                                                )),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            2, 10, 2, 2.0),
                                        child: SizedBox(
                                          child: Center(
                                            child: Text(
                                                deal.name != null
                                                    ? deal.name!
                                                    : "",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: SizeConfig
                                                            .safeBlockVertical! *
                                                        1.2)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                  ),
                ),

                // ),
              ],
            ),
          )
        : SizedBox();
  }

  Widget topBrandList() {
    return featuredBrandDetailModel.brands != null
        ? Container(
            height: 240,
            width: MediaQuery.of(context).size.width,
            color: currentOrderBG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(7, 15, 7, 10),
                      // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                      child: StandardCustomText(
                          label: 'TOP BRANDS',
                          color: textColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10))),
                    child: ListView.builder(
                        itemCount: featuredBrandDetailModel.brands!.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          Brands brand =
                              featuredBrandDetailModel.brands![index];
                          return Padding(
                            padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                            child: Container(
                                width: SizeConfig.safeBlockHorizontal! * 20.0,
                                height: SizeConfig.safeBlockVertical! * 20.0,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                      color: whiteColor,
                                    ),
                                    color: whiteColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(1))),
                                child: Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                      5.0, 10.0, 5.0, 5.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Align(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: brand.image != null
                                              ? Image(
                                                  width: SizeConfig
                                                          .safeBlockHorizontal! *
                                                      11.2,
                                                  height: SizeConfig
                                                          .safeBlockVertical! *
                                                      9,
                                                  image: NetworkImage(
                                                      brand.image!),
                                                  fit: BoxFit.fill,
                                                )
                                              : Image(
                                                  image: AssetImage(noImage),
                                                  width: SizeConfig
                                                          .safeBlockHorizontal! *
                                                      11.2,
                                                  height: SizeConfig
                                                          .safeBlockVertical! *
                                                      9,
                                                  fit: BoxFit.fill,
                                                )),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            2, 10, 2, 2.0),
                                        child: SizedBox(
                                          child: Center(
                                            child: Text(
                                                brand.name != null
                                                    ? brand.name!
                                                    : "",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: SizeConfig
                                                            .safeBlockVertical! *
                                                        1.2)),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          );
                        }),
                  ),
                ),

                // ),
              ],
            ),
          )
        : SizedBox();
  }

  Widget topSlider() {
    return featuredBrandDetailModel.banners != null
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
                  items: featuredBrandDetailModel.banners!.map((element) {
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
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
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
                                        color: blackColor.withOpacity(0.5),
                                        borderRadius: const BorderRadius.all(
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
                                                color: whiteTransparentColor,
                                                fontWeight: FontWeight.w100,
                                                fontSize: 16.0),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: StandardCustomText(
                                                label: '30% of',
                                                color: whiteColor,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 18.0),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: StandardCustomText(
                                                label: 'on every order from',
                                                color: whiteTransparentColor,
                                                fontSize: 16.0),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(4.0),
                                            child: StandardCustomText(
                                                label: 'Fast Med Pharmacy',
                                                color: whiteColor,
                                                fontWeight: FontWeight.w700,
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
                children: featuredBrandDetailModel.banners!
                    .asMap()
                    .entries
                    .map((entry) {
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
                              .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                    ),
                  );
                }).toList(),
              ),
            ],
          )
        : const SizedBox();
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
              itemCount: demoList.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
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
                                        const Align(
                                          alignment:
                                              AlignmentDirectional.center,
                                          child: Image(
                                            width: 75,
                                            height: 81,
                                            image:
                                                AssetImage(demoProductImage_),
                                            fit: BoxFit.scaleDown,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              // mainAxisAlignment:
                                              //     MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text('Sr.No : ${index + 1}',
                                                    style: const TextStyle(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 10.0)),
                                                // const VerticalDivider(),
                                                const SizedBox(
                                                  width: 10,
                                                ),

                                                const Text('|'),
                                                const SizedBox(
                                                  width: 10,
                                                ),

                                                Text('Medicine ${index + 1}',
                                                    style: const TextStyle(
                                                        color: primaryTextColor,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                        fontSize: 14.0)),
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    130,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text('Mrp',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  descriptionTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: SizeConfig
                                                                      .safeBlockVertical! *
                                                                  1.2)),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text('Disc',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  descriptionTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: SizeConfig
                                                                      .safeBlockVertical! *
                                                                  1.2)),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text('Rate',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  descriptionTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: SizeConfig
                                                                      .safeBlockVertical! *
                                                                  1.2)),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text('Exp Date',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  descriptionTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: SizeConfig
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
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width -
                                                    130,
                                                child: Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                          '2500$index.00',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  primaryTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: SizeConfig
                                                                      .safeBlockVertical! *
                                                                  1.2)),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text('1$index%',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  primaryTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: SizeConfig
                                                                      .safeBlockVertical! *
                                                                  1.2)),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text(
                                                          '2400$index.00',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  primaryTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: SizeConfig
                                                                      .safeBlockVertical! *
                                                                  1.2)),
                                                    ),
                                                    Expanded(
                                                      flex: 2,
                                                      child: Text('06/23',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                              color:
                                                                  primaryTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              fontSize: SizeConfig
                                                                      .safeBlockVertical! *
                                                                  1.2)),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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

                                            SizedBox(),
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
                                                Text('3',
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
                                                    '$rupeesString 75$index.00',
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
}
