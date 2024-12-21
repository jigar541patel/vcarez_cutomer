import 'package:badges/badges.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/trending_medicine_model.dart';
import 'package:vcarez_new/ui/trendingmedicinelist/bloc/trending_medicine_list_bloc.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/common_loader.dart';
import '../../../components/custom_snack_bar.dart';
import '../../../components/my_form_field.dart';
import '../../../components/standard_regular_text.dart';
import '../../../services/api/api_hitter.dart';
import '../../../services/repo/common_repo.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/route_names.dart';
import '../../../utils/strings.dart';
import '../../cart/model/cart_list_model.dart';
import '../../dashboard/pages/home/parentbloc/trendingmedicinebloc/trending_medicine_bloc.dart';
import '../../medicinedetails/view/medicine_details.dart';
import '../../storage/shared_pref_const.dart';

class TrendingMedicineListScreen extends StatefulWidget {
  const TrendingMedicineListScreen({Key? key}) : super(key: key);

  @override
  State<TrendingMedicineListScreen> createState() =>
      _TrendingMedicineListScreenState();
}

class _TrendingMedicineListScreenState
    extends State<TrendingMedicineListScreen> {
  late TextEditingController _userNameController;
  late TextEditingController _searchMedicineController;
  bool isLoading = false;

  TrendingMedicineListBloc medicineListBloc = TrendingMedicineListBloc();
  String strTitle = "";
  TrendingMedicineModel medicineListModel = TrendingMedicineModel();
  CartListModel cartListModel = CartListModel();

  void initController() {
    _userNameController = TextEditingController();
    _searchMedicineController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ModalRoute.of(context)!.settings.arguments != null) {
//        arguments: {'exampleArgument': exampleArgument},
        // arguments['exampleArgument']
        final arg = ModalRoute.of(context)!.settings.arguments as Map;
        strTitle = arg['title'];
        medicineListModel = arg['model'];
        debugPrint("vcarez medicine list strTitle $strTitle");
        medicineListBloc.add(GetMedicineList(strTitle, medicineListModel));

        context.read<CartProvider>().getData();
        // getCartList();
        // medicineDetailBloc.add(GetMedicineDetailEvent(strMedicineID));
      }
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
            child: Stack(children: [
          SingleChildScrollView(
            child: BlocProvider(
              create: (context) => medicineListBloc,
              child: BlocConsumer<TrendingMedicineListBloc,
                  TrendingMedicineListState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is OnMedicineListLoaded) {
                    strTitle = state.strTitle;
                    medicineListModel = state.popularMedicineModel;
                  }
                },
                builder: (context, state) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
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
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: imageAppLogo(),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, routeCartList);
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
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(7, 15, 7, 10),
                              // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                              child: Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: BlocConsumer<TrendingMedicineListBloc,
                                      TrendingMedicineListState>(
                                    listener: (context, state) {
                                      // TODO: implement listener
                                      if (state is OnMedicineListLoaded) {
                                        strTitle = state.strTitle;
                                        medicineListModel =
                                            state.popularMedicineModel;
                                      }
                                    },
                                    builder: (context, state) {
                                      return StandardCustomText(
//                                label: 'Popular Medicine',
                                          label: strTitle,
                                          align: TextAlign.start,
                                          color: whiteColor,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 22.0);
                                    },
                                  )),
                            ),
                            Container(
                              margin: const EdgeInsets.only(
                                  left: 5, top: 15.0, bottom: 15, right: 5),
                              child: CustomFormField(
                                controller: _searchMedicineController,
                                labelText: searchMedicine,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return usernameError;
                                  }
                                  return null;
                                },
                                icon: searchMenuIcon,
                                isRequire: true,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.text,
                              ),
                            ),
                          ],
                        ),
                      ),
                      popularMedicineList(),
                    ],
                  );
                },
              ),
            ),
          ),
          isLoading
              ? Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.black.withOpacity(0.4),
                  child: const Center(child: CustomLoader()))
              : const SizedBox(),
        ])));
  }

  Widget popularMedicineList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .75,
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: ListView.builder(
            itemCount: medicineListModel.medicines != null
                ? medicineListModel.medicines!.length
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
                      //     arguments: medicineListModel.medicines![index].id
                      //         .toString());

                      Navigator.pushNamed(context, routeMedicineDetails,
                          arguments: {
                            'type': medicineListModel.medicines![index].type,
                            'id': medicineListModel.medicines![index].id
                                .toString(),
                          } // arguments: i.id.toString()
                          );
                    },
                    child: Container(
                        height: 135,
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
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 15.0, 15.0, 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  Align(
                                    alignment: AlignmentDirectional.center,
                                    child: Align(
                                      alignment: AlignmentDirectional.center,
                                      child: medicineListModel
                                                  .medicines![index].imageUrl !=
                                              null
                                          ? Image(
                                              width: 75,
                                              height: 81,
                                              image: NetworkImage(
                                                  medicineListModel
                                                      .medicines![index]
                                                      .imageUrl!),
                                              fit: BoxFit.scaleDown,
                                            )
                                          : const Image(
                                              image: AssetImage(noImage),
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
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(2.0),
                                        child: SizedBox(
                                          child: Container(
                                            // width: 120,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: Text(
                                                medicineListModel
                                                    .medicines![index].name!,
                                                maxLines: 2,
                                                style: TextStyle(
                                                    color: textColor,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: 12.0)),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      StandardCustomText(
                                          label: medicineListModel
                                              .medicines![index].packInfo!,
                                          color: greyColor,
                                          fontWeight: FontWeight.w100,
                                          fontSize: 10.0),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                145,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                StandardCustomText(
                                                    label: medicineListModel
                                                                .medicines![
                                                                    index]
                                                                .mrp !=
                                                            null
                                                        ? "$rupeesString ${medicineListModel.medicines![index].mrp!}"
                                                        : "",
                                                    //'$rupeesString 200',
                                                    maxlines: 2,
                                                    color: greyColor,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12.0),
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
                                                alignment: AlignmentDirectional
                                                    .bottomEnd,
                                                child: InkWell(
                                                    onTap: () async {
                                                      var connectivityResult =
                                                          await (Connectivity()
                                                              .checkConnectivity());
                                                      if (connectivityResult ==
                                                              ConnectivityResult
                                                                  .mobile ||
                                                          connectivityResult ==
                                                              ConnectivityResult
                                                                  .wifi) {
                                                        // onAddToCart(String strMedicineID, String? strMedicineName,
                                                        // String? strMedicineImageUrl, String? strMedicineMrp,
                                                        // String? strMedicineType, String? strPackaging,
                                                        // String? strPackageInfo) {

                                                        // intPopular =
                                                        //     index;
                                                        // intTrending =
                                                        // -1;

                                                        if (mounted) {
                                                          setState(() {
                                                            isLoading = true;
                                                          });
                                                        }
                                                        handleAddToCart(
                                                            medicineListModel
                                                                .medicines![
                                                                    index]
                                                                .id
                                                                .toString(),
                                                            medicineListModel
                                                                .medicines![
                                                                    index]
                                                                .name!,
                                                            medicineListModel
                                                                .medicines![
                                                                    index]
                                                                .imageUrl!,
                                                            medicineListModel
                                                                .medicines![
                                                                    index]
                                                                .mrp
                                                                .toString(),
                                                            medicineListModel
                                                                .medicines![
                                                                    index]
                                                                .type,
                                                            medicineListModel
                                                                .medicines![
                                                                    index]
                                                                .packInfo,
                                                            medicineListModel
                                                                .medicines![
                                                                    index]
                                                                .packInfo);
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                                createMessageSnackBar(
                                                                    errorNoInternet));
                                                      }

                                                      // Navigator.push(
                                                      //   context,
                                                      //   MaterialPageRoute(
                                                      //       builder: (context) =>
                                                      //           const UploadPrescriptionWidget()),
                                                      // );
                                                    },
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          1.0, 5, 5, 5),
                                                      child: Container(
                                                        // width: 110,
//                                                color: currentOrderBG,
                                                        margin: const EdgeInsets
                                                            .only(top: 1.0),
                                                        decoration:
                                                            BoxDecoration(
                                                                border:
                                                                    Border.all(
                                                                  color:
                                                                      currentOrderBG,
                                                                ),
                                                                color:
                                                                    currentOrderBG,
                                                                borderRadius:
                                                                    const BorderRadius
                                                                            .all(
                                                                        Radius.circular(
                                                                            7))),
                                                        child: const Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                          child:
                                                              StandardCustomText(
                                                            label: 'ADD',
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w900,
                                                            color:
                                                                darkSkyBluePrimaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ))),
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
    );
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
          responseData.message);
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
          context.read<CartProvider>().setData(cartListModel.cartItems!.length);
        });
      }
      // emit(OnHomeCartListLoaded(responseData));
    } else {
      CommonUtils.utils.showToast(responseData.message as String);
      debugPrint("vcarez ErrorDataLoading emited ");
    }
  }
}
