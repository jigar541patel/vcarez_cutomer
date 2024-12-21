import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/commonmodel/cart_provider.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/trending_medicine_model.dart';
import 'package:vcarez_new/ui/searchdetailist/model/search_detail_result_list_model.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import '../../../components/standard_regular_text.dart';
import '../../../services/repo/common_repo.dart';
import '../../../utils/SizeConfig.dart';
import '../../../utils/route_names.dart';
import '../../../utils/strings.dart';
import '../../dashboard/pages/prescription/model/address_list_model.dart';
import '../../storage/shared_pref_const.dart';

class SearchDetailListScreen extends StatefulWidget {
  const SearchDetailListScreen({Key? key}) : super(key: key);

  @override
  State<SearchDetailListScreen> createState() => _SearchDetailListScreenState();
}

class _SearchDetailListScreenState extends State<SearchDetailListScreen> {
  late TextEditingController _searchMedicineController;
  var demoList = [1, 2, 3, 4, 5];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String strTitle = "Search";
  AddressListModel addressListModel = AddressListModel();
  TextEditingController medicineNameSearchController = TextEditingController();
  String strQuantity = "0";
  SearchDetailResultModel searchDetailResultModel = SearchDetailResultModel();
  TrendingMedicineModel trendingMedicineModel = TrendingMedicineModel();
  String? itemPrescriptionType = "all";
  String token = "";
  TextEditingController textDeliveryAddress = TextEditingController();

  void initController() {
    _searchMedicineController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var storage = const FlutterSecureStorage();

      token = (await storage.read(key: keyUserToken))!;

//       if (ModalRoute.of(context)!.settings.arguments != null) {
// //        arguments: {'exampleArgument': exampleArgument},
//         // arguments['exampleArgument']
//         final arg = ModalRoute.of(context)!.settings.arguments as Map;
//         strTitle = arg['title'];
//         medicineListModel = arg['model'];
//         debugPrint("vcarez medicine list strTitle $strTitle");
//       cartListBloc.add(GetCartListEvent());

      context.read<CartProvider>().getData();
      // medicineDetailBloc.add(GetMedicineDetailEvent(strMedicineID));
      // }
    });
  }

  void disposeController() {
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
    SizeConfig().init(context);
    Widget imageAppLogo() => SvgPicture.asset(
          appLogo_,
          height: 18.0,
          width: 116.0,
        );

    return Scaffold(
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * .20,
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
                  const SizedBox(
                    height: 30.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(7, 15, 7, 10),
                    // padding: EdgeInsets.fromLTRB(8.0,10,0,0),
                    child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: StandardCustomText(
                            label: strTitle,
                            align: TextAlign.start,
                            color: whiteColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 22.0)),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.all(SizeConfig.safeBlockVertical! * 2.0),
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
                  itemBuilder: (context, MedicinesSearchDetailList suggestion) {
                    return ListTile(
                        trailing: Text(suggestion.mrp != null
                            ? "$rupeesString ${suggestion.mrp}"
                            : ""),
                        title: Text(suggestion.name != null
                            ? suggestion.name.toString()
                            : ""));
                  },
                  onSuggestionSelected: (MedicinesSearchDetailList suggestion) {
                    // your implementation here
                    setState(() {
                      medicineNameSearchController.text = suggestion.name!;
                      // Navigator.pushNamed(context, routeMedicineDetails,
                      //     arguments: {
                      //       'type': suggestion.type,
                      //       'id': suggestion.id.toString(),
                      //     });
                      //
                      // medicineNameSearchController!.text = "";
                      // textMRPController!.text = suggestion.mrp!.toString();
                      // textRateController!.text = suggestion.mrp!.toString();
                      // medicineID = suggestion.id;
                      // medicineType = suggestion.type;
                      // textQuantityController!.text = "1";
                    });
                  },
                ),
              ),
            ),
            searchMedicineList()
          ],
        )),
      ),
    );
  }

  Widget searchMedicineList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .60,
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: ListView.builder(
            itemCount: searchDetailResultModel.medicines != null
                ? searchDetailResultModel.medicines!.length
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
                            'type':
                                searchDetailResultModel.medicines![index].type,
                            'id': searchDetailResultModel.medicines![index].id
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
                                      child: searchDetailResultModel
                                                  .medicines![index].imageUrl !=
                                              null
                                          ? Image(
                                              width: 75,
                                              height: 81,
                                              image: NetworkImage(
                                                  searchDetailResultModel
                                                      .medicines![index]
                                                      .imageUrl!),
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return Image(
                                                    width: 75,
                                                    height: 81,
                                                    image: AssetImage(noImage));
                                              },
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
                                                searchDetailResultModel
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
                                          label: searchDetailResultModel
                                                      .medicines![index]
                                                      .packInfo !=
                                                  null
                                              ? searchDetailResultModel
                                                  .medicines![index].packInfo!
                                              : "",
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
                                                    label: searchDetailResultModel
                                                                .medicines![
                                                                    index]
                                                                .mrp !=
                                                            null
                                                        ? "$rupeesString ${searchDetailResultModel.medicines![index].mrp!}"
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
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          1.0, 5, 5, 5),
                                                  child: Container(
                                                    // width: 110,
//                                                color: currentOrderBG,
                                                    margin:
                                                        const EdgeInsets.only(
                                                            top: 1.0),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                          color: currentOrderBG,
                                                        ),
                                                        color: currentOrderBG,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    7))),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.all(8.0),
                                                      child: StandardCustomText(
                                                        label: 'ADD',
                                                        fontSize: 12,
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
    );
  }

  Future<List<MedicinesSearchDetailList>> fetchSearchSuggestions(
      String pattern) async {
    debugPrint("vcarez the query is " + pattern);
    searchDetailResultModel =
        await ApiController().getDetailSearchMedicineList(token, pattern);
    debugPrint("vcarez the query reuslt searchDetailResultModel is " +
        searchDetailResultModel.medicines!.toString());
    return Future.value(searchDetailResultModel.medicines ?? []);
  }
}
