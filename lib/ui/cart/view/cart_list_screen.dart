import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/ui/cart/bloc/cart_list_bloc.dart';
import 'package:vcarez_new/ui/cart/model/cart_list_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/popular_medicine_model.dart';
import 'package:vcarez_new/ui/dashboard/pages/home/model/trending_medicine_model.dart';
import 'package:vcarez_new/ui/medicine_list/bloc/medicine_list_bloc.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vibration/vibration.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/custom_snack_bar.dart';
import '../../../components/my_form_field.dart';
import '../../../components/my_theme_button.dart';
import '../../../components/standard_regular_text.dart';
import '../../../dialog/popup_dialog.dart';
import '../../../services/configuration_service.dart';
import '../../../utils/SizeConfig.dart';
import '../../../utils/route_names.dart';
import '../../../utils/strings.dart';
import '../../dashboard/pages/prescription/model/address_list_model.dart';
import '../../medicinedetails/view/medicine_details.dart';
import '../../storage/shared_pref_const.dart';

class CartListScreen extends StatefulWidget {
  const CartListScreen({Key? key}) : super(key: key);

  @override
  State<CartListScreen> createState() => _CartListScreenState();
}

class _CartListScreenState extends State<CartListScreen> {
  late TextEditingController _searchMedicineController;
  var demoList = [1, 2, 3, 4, 5];
  File? _profileImageFile;
  final ConfigurationService? configurationService = ConfigurationService();

  CartListBloc cartListBloc = CartListBloc();
  String strTitle = "My Cart";
  AddressListModel addressListModel = AddressListModel();

  String strQuantity = "0";
  CartListModel cartListModel = CartListModel();
  TrendingMedicineModel trendingMedicineModel = TrendingMedicineModel();
  String? itemPrescriptionType = "all";

  TextEditingController textDeliveryAddress = TextEditingController();

  void initController() {
    _searchMedicineController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
//       if (ModalRoute.of(context)!.settings.arguments != null) {
// //        arguments: {'exampleArgument': exampleArgument},
//         // arguments['exampleArgument']
//         final arg = ModalRoute.of(context)!.settings.arguments as Map;
//         strTitle = arg['title'];
//         medicineListModel = arg['model'];
//         debugPrint("vcarez medicine list strTitle $strTitle");
      cartListBloc.add(GetCartListEvent());

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
            child: BlocProvider(
              create: (context) => cartListBloc,
              child: BlocConsumer<CartListBloc, CartListState>(
                listener: (context, state) {
                  // TODO: implement listener
                  if (state is OnCartListLoaded) {
                    cartListModel = state.cartListModel;
                    context
                        .read<CartProvider>()
                        .setData(cartListModel.cartItems!.length);
                  } else if (state is PlaceOrderSuccessState) {
                    cartListBloc.add(GetCartListEvent());
                  } else if (state is UpdateCartSuccessState) {
                    cartListBloc.add(GetCartListEvent());
                  }
                },
                builder: (context, state) {
                  return (state is CartLoadingState ||
                          state is PlaceOrderLoadingState ||
                          state is UpdateCartLoadingState)
                      ? Center(
                          child: SizedBox(
                              height: MediaQuery.of(context).size.height * .70,
                              child: const Center(child: CustomLoader())),
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
                                        child: BlocConsumer<CartListBloc,
                                            CartListState>(
                                          listener: (context, state) {
                                            // TODO: implement listener
                                            if (state is OnCartListLoaded) {
                                              cartListModel =
                                                  state.cartListModel;
                                            }
                                          },
                                          builder: (context, state) {
                                            return StandardCustomText(
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
                                        left: 5,
                                        top: 15.0,
                                        bottom: 15,
                                        right: 5),
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
                            state is CartLoadingState ||
                                    state is UpdateCartLoadingState
                                ? SizedBox(
                                    height: MediaQuery.of(context).size.height *
                                        .75,
                                    child: const Center(child: CustomLoader()))
                                : state is OnCartListLoaded ||
                                        state is UpdateCartSuccessState
                                    ? (cartListModel.cartItems != null &&
                                            cartListModel.cartItems!.isNotEmpty)
                                        ? cartMedicineList()
                                        : CommonUtils.NoDataFoundPlaceholder(
                                            context,
                                            message: lblCartListEmpty,
                                            strAssetImage: cartEmptyImage)
                                    :
                                    // SizedBox(
                                    //     height: MediaQuery.of(context).size.height *
                                    //         .65,
                                    //     child: const Center(child: CustomLoader())),
                                    CommonUtils.NoDataFoundPlaceholder(context,
                                        message: "Loading Cart...",
                                        strAssetImage: cartEmptyImage),
                            (cartListModel.cartItems != null &&
                                    cartListModel.cartItems!.isNotEmpty)
                                ? Container(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, left: 20.0, top: 45),
                                    child: MyThemeButton(
                                      buttonText: 'Send for Quotation',
                                      onPressed: () {
                                        showPrescriptionDialog();
                                      },
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        );
                },
              ),
            ),
          ),
        ));
  }

  Widget cartMedicineList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .55,
      child: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.only(bottom: 40.0),
        child: ListView.builder(
            itemCount: cartListModel.cartItems != null
                ? cartListModel.cartItems!.length
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
                      Navigator.pushNamed(context, routeMedicineDetails,
                          // arguments: element.id.toString());

                          arguments: {
                            'type': cartListModel.cartItems![index].type,
                            'id': cartListModel.cartItems![index].medicineId
                                .toString(),
                          });
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
                                        child: cartListModel.cartItems![index]
                                                    .imageUrl !=
                                                null
                                            ? Image(
                                                width: 75,
                                                height: 81,
                                                image: NetworkImage(
                                                    cartListModel
                                                        .cartItems![index]
                                                        .imageUrl!),
                                                fit: BoxFit.scaleDown,
                                              )
                                            : const Image(
                                                image: AssetImage(noImage),
                                                width: 75,
                                                height: 81,
                                              ),

                                        // child: Image(
                                        //   width: 75,
                                        //   height: 81,
                                        //   image: AssetImage(demoProductImage_),
                                        //   fit: BoxFit.cover,
                                        // ),
                                      )),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(2.0),
                                        child: SizedBox(
                                          child: Container(
                                            // width: 120,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                150,
                                            child: Text(
                                                cartListModel
                                                    .cartItems![index].name!,
                                                maxLines: 2,
                                                style: const TextStyle(
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
                                          label: cartListModel.cartItems![index]
                                                      .packInfo !=
                                                  null
                                              ? cartListModel
                                                  .cartItems![index].packInfo!
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
                                                    label: cartListModel
                                                                .cartItems![
                                                                    index]
                                                                .mrp !=
                                                            null
                                                        ? "$rupeesString ${cartListModel.cartItems![index].mrp!}"
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
                                            Row(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: InkWell(
                                                      onTap: () {
                                                        int intQuantity =
                                                            cartListModel
                                                                    .cartItems![
                                                                        index]
                                                                    .quantity! -
                                                                1;
                                                        cartListBloc.add(
                                                            UpdateCartListEvent(
                                                                cartListModel
                                                                    .cartItems![
                                                                        index]
                                                                    .id
                                                                    .toString(),
                                                                intQuantity
                                                                    .toString()));
                                                      },
                                                      child: SvgPicture.asset(
                                                        minusGreyIcon,
                                                      ),
                                                    )),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                StandardCustomText(
                                                    label: cartListModel
                                                        .cartItems![index]
                                                        .quantity!
                                                        .toString(),
                                                    color: greyColor,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 12.0),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(5),
                                                    child: BlocConsumer<
                                                        CartListBloc,
                                                        CartListState>(
                                                      listener:
                                                          (context, state) {
                                                        if (state
                                                            is UpdateCartSuccessState) {
                                                          cartListBloc.add(
                                                              GetCartListEvent());
                                                        }
                                                        // TODO: implement listener
                                                      },
                                                      builder:
                                                          (context, state) {
                                                        return InkWell(
                                                            onTap: () {
                                                              int intQuantity =
                                                                  cartListModel
                                                                          .cartItems![
                                                                              index]
                                                                          .quantity! +
                                                                      1;
                                                              cartListBloc.add(UpdateCartListEvent(
                                                                  cartListModel
                                                                      .cartItems![
                                                                          index]
                                                                      .id
                                                                      .toString(),
                                                                  intQuantity
                                                                      .toString()));
                                                            },
                                                            child: SvgPicture
                                                                .asset(
                                                              plusBlueIcon,
                                                            ));
                                                      },
                                                    )),
                                              ],
                                            ),
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

  Future<void> showPrescriptionDialog() async {
    return await showDialog(
        context: context,
        builder: (context) {
          // bool isChecked = false;
          int alternativeType = 0;
          String? deliveryType = "deliver";
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(20),
              content: BlocProvider(
                create: (context) => cartListBloc,
                child: Form(
                    // key: _formKey,
                    child: Material(
                        color: Colors.transparent,
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SingleChildScrollView(
                            child: Container(
                                // height: SizeConfig.blockSizeVertical! * 80,
                                // height: MediaQuery.of(context).size.height * .80,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 0),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(1.0),
                                    child: Column(
                                      children: [
                                        SingleChildScrollView(
                                            child: Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10.0),
                                          child: Padding(
                                            padding: const EdgeInsetsDirectional
                                                .fromSTEB(10, 10, 10, 10),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(7, 0, 0, 0),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    uploadPrescriptionTypeList(),
                                                    const Align(
                                                        alignment:
                                                            AlignmentDirectional
                                                                .topStart,
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      10, 0, 0),
                                                          child: Text(
                                                            'Delivery OR Pickup',
                                                            style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 15),
                                                          ),
                                                        )),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                              5, 10, 0, 20),
                                                      child: Column(
                                                        // mainAxisSize: MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                            // width: 100,
                                                            child: Row(
                                                              children: [
                                                                Radio(
                                                                  value:
                                                                      "deliver",
                                                                  visualDensity: const VisualDensity(
                                                                      horizontal:
                                                                          VisualDensity
                                                                              .minimumDensity,
                                                                      vertical:
                                                                          VisualDensity
                                                                              .minimumDensity),
                                                                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  // contentPadding: EdgeInsets.all(0),
                                                                  groupValue:
                                                                      deliveryType,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      deliveryType =
                                                                          value
                                                                              .toString();
                                                                    });
                                                                  },
                                                                ),
                                                                StandardCustomText(
                                                                    label:
                                                                        'Delivery',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        SizeConfig.safeBlockVertical! *
                                                                            1.7),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Radio(
                                                                  value:
                                                                      "pickup",
                                                                  visualDensity: const VisualDensity(
                                                                      horizontal:
                                                                          VisualDensity
                                                                              .minimumDensity,
                                                                      vertical:
                                                                          VisualDensity
                                                                              .minimumDensity),
                                                                  groupValue:
                                                                      deliveryType,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      deliveryType =
                                                                          value
                                                                              .toString();
                                                                    });
                                                                  },
                                                                ),
                                                                StandardCustomText(
                                                                    label:
                                                                        'Pickup',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        SizeConfig.safeBlockVertical! *
                                                                            1.7),
                                                              ],
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 10,
                                                          ),
                                                          Visibility(
                                                              child: deliveryType ==
                                                                      "deliver"
                                                                  ? Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          SizedBox(
                                                                        width: SizeConfig.safeBlockHorizontal! *
                                                                            55.0,
                                                                        // child:
                                                                        child:
                                                                            TextButton(
                                                                          style:
                                                                              TextButton.styleFrom(
                                                                            primary:
                                                                                darkSkyBluePrimaryColor,
                                                                            backgroundColor:
                                                                                currentOrderBG, // Background Color
                                                                          ),
                                                                          onPressed:
                                                                              () {
                                                                            showAddressDialog(context);
                                                                          },
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                const EdgeInsets.only(left: 28.0, right: 28.0),
                                                                            child:
                                                                                Row(
                                                                              children: [
                                                                                SvgPicture.asset(
                                                                                  locationMarkerDarkIcon,
                                                                                  height: 17.0,
                                                                                  color: darkSkyBluePrimaryColor,
                                                                                  width: 15.0,
                                                                                ),
                                                                                const SizedBox(
                                                                                  width: 15,
                                                                                ),
                                                                                const Text(
                                                                                  "Choose Address",
                                                                                  style: TextStyle(
                                                                                    color: darkSkyBluePrimaryColor,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                      // )
                                                                      // ),
                                                                      // ),
                                                                      )
                                                                  : const SizedBox()),
                                                          Visibility(
                                                              child: deliveryType ==
                                                                      "deliver"
                                                                  ? Padding(
                                                                      padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                          10,
                                                                          20,
                                                                          17,
                                                                          20),
                                                                      child:
                                                                          TextFormField(
                                                                        readOnly:
                                                                            true,
                                                                        controller:
                                                                            textDeliveryAddress,
                                                                        maxLines:
                                                                            5,
                                                                        validator:
                                                                            (value) {
                                                                          if (deliveryType ==
                                                                              "deliver") {
                                                                            if (value == null ||
                                                                                value.isEmpty) {
                                                                              return deliveryAddressError;
                                                                            }
                                                                            return null;
                                                                          }
                                                                          return null;
                                                                        },
                                                                        autofocus:
                                                                            false,
                                                                        obscureText:
                                                                            false,
                                                                        decoration:
                                                                            InputDecoration(
                                                                          enabledBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                const BorderSide(
                                                                              color: currentOrderBG,
                                                                              width: 1,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                          hintText:
                                                                              "Address",
                                                                          focusedBorder:
                                                                              UnderlineInputBorder(
                                                                            borderSide:
                                                                                const BorderSide(
                                                                              color: currentOrderBG,
                                                                              width: 1,
                                                                            ),
                                                                            borderRadius:
                                                                                BorderRadius.circular(20),
                                                                          ),
                                                                          filled:
                                                                              true,
                                                                          fillColor:
                                                                              currentOrderBG,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : const SizedBox()),
                                                          const Align(
                                                              alignment:
                                                                  AlignmentDirectional
                                                                      .topStart,
                                                              child: Padding(
                                                                padding:
                                                                    EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            10,
                                                                            0,
                                                                            0),
                                                                child: Text(
                                                                  'Are you ok with alternative medicine ?',
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          15),
                                                                ),
                                                              )),
                                                          //
                                                          Container(
                                                            // width: 100,
                                                            child: Row(
                                                              children: [
                                                                Radio(
                                                                  value: 1,
                                                                  visualDensity: const VisualDensity(
                                                                      horizontal:
                                                                          VisualDensity
                                                                              .minimumDensity,
                                                                      vertical:
                                                                          VisualDensity
                                                                              .minimumDensity),
                                                                  // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                                  // contentPadding: EdgeInsets.all(0),
                                                                  groupValue:
                                                                      alternativeType,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      alternativeType =
                                                                          value
                                                                              as int;
                                                                    });
                                                                  },
                                                                ),
                                                                StandardCustomText(
                                                                    label:
                                                                        'Yes',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        SizeConfig.safeBlockVertical! *
                                                                            1.7),
                                                                const SizedBox(
                                                                  width: 20,
                                                                ),
                                                                Radio(
                                                                  value: 0,
                                                                  visualDensity: const VisualDensity(
                                                                      horizontal:
                                                                          VisualDensity
                                                                              .minimumDensity,
                                                                      vertical:
                                                                          VisualDensity
                                                                              .minimumDensity),
                                                                  groupValue:
                                                                      alternativeType,
                                                                  onChanged:
                                                                      (value) {
                                                                    setState(
                                                                        () {
                                                                      alternativeType =
                                                                          value
                                                                              as int;
                                                                    });
                                                                  },
                                                                ),
                                                                StandardCustomText(
                                                                    label: 'No',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    fontSize:
                                                                        SizeConfig.safeBlockVertical! *
                                                                            1.7),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    right: 20.0,
                                                                    left: 20.0,
                                                                    top: 45),
                                                            child:
                                                                MyThemeButton(
                                                              buttonText:
                                                                  'Confirm Order',
                                                              onPressed:
                                                                  () async {
                                                                if (deliveryType ==
                                                                        "deliver" &&
                                                                    textDeliveryAddress
                                                                            .text ==
                                                                        "") {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              "Please Enter Address for Delivery");
                                                                } else {
                                                                  Navigator.pop(
                                                                      context);
                                                                  var storage =
                                                                      const FlutterSecureStorage();

                                                                  String?
                                                                      strLat =
                                                                      await storage
                                                                          .read(
                                                                              key: keyUserLat);
                                                                  String?
                                                                      strLong =
                                                                      await storage
                                                                          .read(
                                                                              key: keyUserLong);

                                                                  // cartListBloc.add(PlaceOrderEvent(deliveryType, alternativeType, textDeliveryAddress
                                                                  //     .text, doubleLatitude, doubleLongitude));
                                                                  // Navigator.push(
                                                                  //   context,
                                                                  //   MaterialPageRoute(
                                                                  //       builder: (context) => const OrderConfirmationScreen()),
                                                                  // );
                                                                  // Navigator.pushNamed(
                                                                  //     context,
                                                                  //     routePaymentMethod);
                                                                }
                                                              },
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                          ),
                                          // submitButtonQuotation(),
                                        )),
                                        // uploadPrescriptionList(context),
                                      ],
                                    ),
                                  ),
                                ))))),
              ),
              title: const Text('Delivery Information'),
            );
          });
        });
  }

  void showAddressDialog(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: const Duration(milliseconds: 700),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Material(
              color: Colors.transparent,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                height: SizeConfig.blockSizeVertical! * 80,
                // height: MediaQuery.of(context).size.height * .80,

                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      addressList(),
                    ],
                  ),
                ),
              )),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        Tween<Offset> tween;
        if (anim.status == AnimationStatus.reverse) {
          tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
        } else {
          tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
        }

        return SlideTransition(
          position: tween.animate(anim),
          child: FadeTransition(
            opacity: anim,
            child: child,
          ),
        );
      },
    );
  }

  uploadPrescriptionTypeList() {
    return Container(
      transform: Matrix4.translationValues(
          0.0, -SizeConfig.safeBlockVertical! * 5.9, 0.0),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
        child: Material(
          color: Colors.transparent,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Container(
            width: double.infinity,
            height: SizeConfig.safeBlockVertical! * 18.0,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                      onTap: () {
                        // setState(() {
                        //   openMedicineTab = false;
                        // });
                        getImageFromCamera();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 20),
                            child: Container(
                              // width: SizeConfig.safeBlockHorizontal! * 5.5,
                              // height: SizeConfig.safeBlockVertical! * 5.5,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: InkWell(
                                  onTap: () {
                                    getImageFromCamera();
                                  },
                                  child: SvgPicture.asset(
                                    cameraIcon,
                                    height: SizeConfig.safeBlockVertical! * 6.2,
                                    width:
                                        SizeConfig.safeBlockHorizontal! * 6.2,
                                  )),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: StandardCustomText(
                              label: 'Take a picture of\nyour prescription',
                              fontSize: SizeConfig.safeBlockVertical! * 1.4,
                            ),
                          ),
                        ],
                      )),
                  InkWell(
                      onTap: () {
                        // setState(() {
                        //   openMedicineTab = false;
                        // });

                        getImageFromGallery();
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 20),
                            child: InkWell(
                                onTap: () {
                                  getImageFromGallery();
                                },
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                  ),
                                  child: InkWell(
                                      onTap: () {
                                        getImageFromGallery();
                                      },
                                      child: SvgPicture.asset(
                                        galleryIcon,
                                      )),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 0),
                            child: StandardCustomText(
                              label: 'Add from Gallery',
                              fontSize: SizeConfig.safeBlockVertical! * 1.4,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getImageFromCamera() async {
    try {
      PermissionStatus? permissionStatus = await _getCameraPermission();
      if (permissionStatus == PermissionStatus.granted) {
        FocusScope.of(context).requestFocus(FocusNode());
        final imageFile = await ImagePicker().pickImage(
            source: ImageSource.camera,
            maxWidth: configurationService!.maxPictureWidth,
            maxHeight: configurationService!.maxPictureHeight,
            preferredCameraDevice: CameraDevice.rear);
        if (imageFile != null) {
          _updateSelectedProfilePictureFile(File(imageFile.path));

          // _cropSelectedProfilePictureFile(File(imageFile.path));
        }
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        String? permissionContent =
            "You disabled camera permission. Please go to phone settings for enable camera for VCarez.";
        _handleInvalidPermissions(permissionStatus, context, permissionContent);
      }
    } catch (e) {
      print(e);
    }
  }

  _updateSelectedProfilePictureFile(File? imageFile) {
    if (mounted && imageFile != null) {
      setState(() {
        _profileImageFile = imageFile;
      });
    }
  }

  Future getImageFromGallery() async {
    if (Platform.isIOS) {
      final photosPermissionStatus = await Permission.photos.status;
      if (photosPermissionStatus == PermissionStatus.limited) {
        final imageFile = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            maxWidth: configurationService!.maxPictureWidth,
            maxHeight: configurationService!.maxPictureHeight);
        if (imageFile != null) {
          // _cropSelectedProfilePictureFile(File(imageFile.path));
          _updateSelectedProfilePictureFile(File(imageFile.path));
        }
      } else {
        PermissionStatus permissionStatus = await _getGalleryPermission();
        if (permissionStatus == PermissionStatus.granted) {
          final imageFile = await ImagePicker().pickImage(
              source: ImageSource.gallery,
              maxWidth: configurationService!.maxPictureWidth,
              maxHeight: configurationService!.maxPictureHeight);
          if (imageFile != null) {
            // _cropSelectedProfilePictureFile(File(imageFile.path));
            _updateSelectedProfilePictureFile(File(imageFile.path));
          }
        } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
          String? permissionContent =
              "You disabled gallery permission. Please go to phone settings and allow storage access for VCarez.";
          _handleInvalidPermissions(
              permissionStatus, context, permissionContent);
        }
      }
    } else {
      PermissionStatus permissionStatus = await _getGalleryPermission();
      if (permissionStatus == PermissionStatus.granted) {
        final imageFile = await ImagePicker().pickImage(
            source: ImageSource.gallery,
            maxWidth: configurationService!.maxPictureWidth,
            maxHeight: configurationService!.maxPictureHeight);
        if (imageFile != null) {
          // _cropSelectedProfilePictureFile(File(imageFile.path));
          _updateSelectedProfilePictureFile(File(imageFile.path));
        }
      } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
        String? permissionContent =
            "You disabled gallery permission. Please go to phone settings and allow storage access for VCarez.";
        _handleInvalidPermissions(permissionStatus, context, permissionContent);
      }
    }
  }

  Future<PermissionStatus?> _getCameraPermission() async {
    // PermissionStatus? permissionStatus;
    // Map<Permission, PermissionStatus> statuses = await [
    //   Permission.camera,
    // ].request();
    // if (!statuses.values.toList()[0].isGranted) {
    //   String? permissionContent =
    //       "You disabled camera permission. Please go to phone settings for enable camera for VCarez";
    //   _handleInvalidPermissions(
    //       statuses.values.toList()[0], context, permissionContent);
    // } else {
    //   permissionStatus = statuses.values.toList()[0];
    //   return permissionStatus;
    // }
    // return permissionStatus;

    PermissionStatus permission;
    if (Platform.isIOS) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.camera].request();
      permission = statuses.values.toList()[0];
      return permission;
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.camera].request();
      permission = statuses.values.toList()[0];
      return permission;
    }
  }

  Future<PermissionStatus> _getGalleryPermission() async {
    PermissionStatus permission;
    if (Platform.isIOS) {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.photos].request();
      permission = statuses.values.toList()[0];
      return permission;
    } else {
      Map<Permission, PermissionStatus> statuses =
          await [Permission.storage].request();
      permission = statuses.values.toList()[0];
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus? permissionStatus,
      BuildContext context, String? permissionContent) async {
    if (permissionStatus == PermissionStatus.denied) {
      if (Platform.isIOS) {
        displaySettingDialog(context, permissionContent);
      } else {
        displaySettingDialog(context, permissionContent);
        // ScaffoldMessenger.of(context).showSnackBar(createMessageSnackBar(
        //     AppLocalizations.of(context)!.translate("msg_permission_camera")!));
      }
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      /// *Only supported on Android.*
      displaySettingDialog(context, permissionContent);
    } else if (permissionStatus == PermissionStatus.restricted) {
      /// *Only supported on iOS.*
      displaySettingDialog(context, permissionContent);
    }
  }

  Future<bool?> displaySettingDialog(
      BuildContext screenContext, String? permissionContent) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) => PopupDialog(
              textAlign: TextAlign.center,
              text: permissionContent,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
              onPressedNo: () {
                Navigator.of(context).pop();
              },
              onPressedYes: () async {
                try {
                  Navigator.of(context).pop();
                  openAppSettings();
                } catch (e) {}
              },
              yesText: "Enable",
              noText: "Cancel",
            ));
  }

  Widget addressList() {
    // var demoList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    // if (addPrescriptionBloc.isClosed) {
    //
    //  if( addPrescriptionBloc.state is OnAddressLoaded)
    //   addPrescriptionBloc.add(GetAddressListEvent());
    // }
    return BlocProvider(
      create: (context) => CartListBloc()..add(GetAddressListEvent()),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .75,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: BlocConsumer<CartListBloc, CartListState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is OnAddressLoaded) {
                addressListModel = state.addressListModel;
              }
            },
            builder: (context, state) {
              return state is OnAddressLoading
                  ? Center(
                      child: SizedBox(
                          height: SizeConfig.blockSizeVertical! * 15,
                          width: SizeConfig.blockSizeHorizontal! * 70,
                          child: const Center(child: CustomLoader())),
                    )
                  : state is OnAddressLoaded
                      ? addressListModel.addresses != null &&
                              addressListModel.addresses!.isNotEmpty
                          ? ListView.builder(
                              itemCount: addressListModel.addresses != null
                                  ? addressListModel.addresses!.isNotEmpty
                                      ? addressListModel.addresses!.length
                                      : 0
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
                                        // debugPrint("vacrez the click is called ");
                                        textDeliveryAddress.text =
                                            addressListModel
                                                .addresses![index].address!;
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                          // height: 135,
                                          height:
                                              SizeConfig.blockSizeVertical! *
                                                  15,
                                          width:
                                              SizeConfig.blockSizeHorizontal! *
                                                  70,
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
                                            child: SizedBox(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Row(
                                                    children: [
                                                      Column(
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
                                                              child: Text(
                                                                  "Address ${index + 1} ",
                                                                  maxLines: 2,
                                                                  style: const TextStyle(
                                                                      color:
                                                                          darkSkyBluePrimaryColor,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w700,
                                                                      fontSize:
                                                                          12.0)),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 5,
                                                          ),
                                                          SizedBox(
                                                              width: SizeConfig
                                                                      .blockSizeHorizontal! *
                                                                  72,
                                                              child:
                                                                  StandardCustomText(
                                                                      align: TextAlign
                                                                          .start,
                                                                      label: addressListModel.addresses![index].address !=
                                                                              null
                                                                          ? addressListModel
                                                                              .addresses![
                                                                                  index]
                                                                              .address!
                                                                          : "",
                                                                      // "MG Road [$index] Near to railway station calcutta, bengal, bihar 456789",
                                                                      color:
                                                                          greyColor,
                                                                      maxlines:
                                                                          3,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w100,
                                                                      fontSize:
                                                                          10.0)),
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
                                                                        margin: const EdgeInsets.only(
                                                                            top:
                                                                                1.0),
                                                                        decoration: BoxDecoration(
                                                                            border: Border.all(
                                                                              color: currentOrderBG,
                                                                            ),
                                                                            color: currentOrderBG,
                                                                            borderRadius: const BorderRadius.all(Radius.circular(7))),
                                                                        child:
                                                                            Padding(
                                                                          padding:
                                                                              const EdgeInsets.all(8.0),
                                                                          child:
                                                                              StandardCustomText(
                                                                            label:
                                                                                'Select Address ${index + 1}',
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
                                            ),
                                          ))),
                                );
                              })
                          : SizedBox(
                              height: SizeConfig.blockSizeVertical! * 15,
                              width: SizeConfig.blockSizeHorizontal! * 85,
                              child: const Center(
                                  child: StandardCustomText(
                                      label: "No Address Found")))
                      : const SizedBox();
            },
          ),
        )),
      ),
    );
  }
}
