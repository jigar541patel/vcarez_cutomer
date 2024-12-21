import 'package:badges/badges.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/ui/cart/bloc/cart_list_bloc.dart';
import 'package:vcarez_new/ui/cart/model/cart_list_model.dart';
import 'package:vcarez_new/ui/medicinedetails/bloc/medicine_detail_bloc.dart';
import 'package:vcarez_new/ui/medicinedetails/model/medicine_detail_model.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/custom_snack_bar.dart';
import '../../../components/standard_regular_text.dart';
import '../../../containers/multi_input_container.dart';
import '../../../utils/SizeConfig.dart';
import '../../../utils/colors_utils.dart';
import '../../../utils/images_utils.dart';
import '../../../utils/strings.dart';

class MedicineDetailPageWidget extends StatefulWidget {
  const MedicineDetailPageWidget({Key? key}) : super(key: key);

  @override
  _MedicineDetailPageWidgetState createState() =>
      _MedicineDetailPageWidgetState();
}

class _MedicineDetailPageWidgetState extends State<MedicineDetailPageWidget> {
  Varients dropdownvalue = Varients();
  int intQuantity = 1;

  // var items = [
  //   '1 Bottle',
  //   '2 Bottle',
  //   '3 Bottle',
  //   '4 Bottle',
  //   '5 Bottle',
  // ];

  var demoList = [0];
  int _current = 0;
  TextEditingController? textController1;
  TextEditingController? textController2;
  String strType = "";
  TextEditingController? textController;
  MedicineDetailBloc medicineDetailBloc = MedicineDetailBloc();
  CartListBloc cartListBloc = CartListBloc();
  PageController? pageViewController;
  MedicineDetailModel medicineDetailModel = MedicineDetailModel();

  @override
  void initState() {
    super.initState();
    textController1 = TextEditingController();
    textController2 = TextEditingController();
    textController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        // String strMedicineID =
        //     ModalRoute.of(context)!.settings.arguments as String;
        // debugPrint("vcarez vendor strMedicineID $strMedicineID");

        final arg = ModalRoute.of(context)!.settings.arguments as Map;
        strType = arg['type'];
        String strMedicineID = arg['id'];
        // debugPrint("vcarez medicine list strTitle $strTitle");
        // medicineListBloc.add(GetMedicineList(strTitle, medicineListModel));

        context.read<CartProvider>().getData();
        medicineDetailBloc.add(GetMedicineDetailEvent(strMedicineID, strType));
      }
    });
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
        backgroundColor: const Color(0xFFF2F9FC),
        body: // Generated code for this Container Widget...

            BlocProvider(
                create: (context) => medicineDetailBloc,
                child: BlocProvider(
                  create: (context) => cartListBloc,
                  child: BlocConsumer<CartListBloc, CartListState>(
                    listener: (context, cartState) {
                      // TODO: implement listener
                      if(cartState is OnCartListLoaded)
                        {
                          CartListModel cartListModel=cartState.cartListModel;
                          context.read<CartProvider>().setData(cartListModel.cartItems!.length);
                        }
                    },
                    builder: (context, state) {
                      return BlocConsumer<MedicineDetailBloc,
                          MedicineDetailState>(listener: (context, state) {
                        // TODO: implement listener
                        if (state is OnMedicineLoaded) {
                          medicineDetailModel = state.medicineDetailModel;

                          if (medicineDetailModel.medicine!.varients != null) {
                            medicineDetailModel.medicine!.varients!
                                .map((element) {
                              // get index
                              var index = medicineDetailModel
                                  .medicine!.varients!
                                  .indexOf(element);
                              if (element.packaging ==
                                  medicineDetailModel.medicine!.packaging) {
                                // selectedStateID = element.id!;
                                dropdownvalue = medicineDetailModel
                                    .medicine!.varients![index];
                                // myAddressBloc.add(GetCityListEvent(
                                //     selectedStateID.toString()));
                              }
                            }).toList();
                          }


                          // dropdownvalue = medicineDetailModel
                          //     .medicine!.packaging; //.packaging!;
                        }

                        if (state is AddToCartDetailSuccessState) {
                          cartListBloc.add(GetCartListEvent());
                        }
                      }, builder: (context, state) {
                        return state is MedicineDataLoading
                            ? const Align(
                                alignment: AlignmentDirectional.center,
                                child: CustomLoader(),
                              )
                            :
                            // state is OnMedicineLoaded || state is AddToCartSuccessState
                            //         ?
                            SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              .10,
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
                                          Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        Navigator.pop(
                                                            context, true);
                                                      },
                                                      child: const Icon(
                                                        Icons.arrow_back_ios,
                                                        color: whiteColor,
                                                      ),
                                                    ),
                                                    imageAppLogo(),
                                                  ],
                                                )),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20.0),
                                                  child: InkWell(
                                                      onTap: () {
                                                        Navigator.pushNamed(
                                                            context,
                                                            routeCartList);
                                                      },
                                                      // child: ChangeNotifierProvider(
                                                      //     create: (context) => CartListModel(),
                                                      child: Badge(
                                                        badgeContent: Consumer<
                                                            CartProvider>(
                                                          builder: (context,
                                                              value, child) {
                                                            return Text(
                                                              value
                                                                  .getCounter()
                                                                  .toString(),
                                                              // style: const TextStyle(
                                                              //     color: Colors.white, fontWeight: FontWeight.bold),
                                                            );
                                                          },
                                                        ),
                                                        position: BadgePosition
                                                            .bottomEnd(),
                                                        badgeColor:
                                                            Colors.white,

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
                                            height: 5.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Generated code for this Container Widget...
                                    Container(
                                      transform: Matrix4.translationValues(
                                          0.0, -15.0, 0.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: bgColor,
                                          ),
                                          color: bgColor,
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(20))),
                                      child: Column(
                                        children: [
                                          imageSliderContainer(),
                                          Container(
                                            color: currentOrderBG,
                                            child:
                                                // Container(
                                                //   transform: Matrix4.translationValues(
                                                //       0.0, -105.0, 0.0),
                                                //   child:

                                                Column(
                                              children: [
                                                bestPriceWidget(),
                                                productDetailWidget(),
                                                medicineDetailModel.medicine !=
                                                        null
                                                    ? strType == "rx"
                                                        ? medicineDetailModel
                                                                    .medicine!
                                                                    .safetyAdvise !=
                                                                null
                                                            ? medicineDetailModel
                                                                    .medicine!
                                                                    .safetyAdvise!
                                                                    .isNotEmpty
                                                                ? safetyAdvice()
                                                                : const SizedBox()
                                                            : const SizedBox()
                                                        : const SizedBox()
                                                    : const SizedBox(),
                                                medicineDetailModel.medicine !=
                                                        null
                                                    ? medicineDetailModel
                                                                .suggestions !=
                                                            null
                                                        ? medicineDetailModel
                                                                .suggestions!
                                                                .isNotEmpty
                                                            ? substituteProductWidget()
                                                            : const SizedBox()
                                                        : const SizedBox()
                                                    : const SizedBox(),
                                                medicineDetailModel.medicine !=
                                                        null
                                                    ? medicineDetailModel
                                                                .medicine!
                                                                .faqs !=
                                                            null
                                                        ? medicineDetailModel
                                                                .medicine!
                                                                .faqs!
                                                                .isNotEmpty
                                                            ? faqList()
                                                            : const SizedBox()
                                                        : const SizedBox()
                                                    : const SizedBox()

                                                // : const SizedBox(),
                                              ],
                                            ),
                                            // ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                        // : const SizedBox();
                      });
                    },
                  ),
                )));
  }

  Widget imageSliderContainer() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 10),
      child: Material(
        child: SizedBox(
          width: double.infinity,
          height: 450,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 0, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 1.0, left: 15),
                  child: Text(
                    medicineDetailModel.medicine != null
                        ? medicineDetailModel.medicine!.name != null
                            ? medicineDetailModel.medicine!.name!
                            : ""
                        : "",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15),
                  child: Text(
                    medicineDetailModel.medicine != null
                        ? medicineDetailModel.medicine!.manufacturer != null
                            ? medicineDetailModel.medicine!.manufacturer!
                            : ""
                        : "",
                    style: const TextStyle(color: Colors.black26),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 15),
                  child: Text(
                    medicineDetailModel.medicine != null
                        ? medicineDetailModel.medicine!.packInfo != null
                            ? medicineDetailModel.medicine!.packInfo!
                            : ""
                        : "",
                  ),
                ),
                medicineDetailModel.medicine != null
                    ? medicineDetailModel.medicine!.saltComposition != null
                        ? Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10.0, left: 15),
                                child: Text(
                                  "SALT COMPOSITION : ",
                                  style: TextStyle(
                                      color: greyColor,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12),
                                ),
                              ),
                              Expanded(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.only(top: 10.0, left: 15),
                                child: Text(
                                  medicineDetailModel
                                      .medicine!.saltComposition!,
                                  style: const TextStyle(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black26,
                                      fontWeight: FontWeight.normal,
                                      fontSize: 12),
                                ),
                              )),
                            ],
                          )
                        : SizedBox()
                    : SizedBox(),
                Expanded(
                  child: SizedBox(
                    width: double.infinity,
                    child: medicineDetailModel.medicine != null
                        ? Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: CarouselSlider(
                                  // options: CarouselOptions(height: 200.0),
                                  options: CarouselOptions(
                                    height: 180.0,
                                    autoPlay: false,
                                    enlargeCenterPage: true,
                                    viewportFraction: 0.97,
                                    aspectRatio: 2.0,
                                    initialPage: 2,
                                    onPageChanged: (index, reason) {
                                      setState(() {
                                        _current = index;
                                      });
                                    },
                                  ),
                                  items: medicineDetailModel
                                                  .medicine!.imageUrl !=
                                              null &&
                                          medicineDetailModel
                                              .medicine!.imageUrl!.isNotEmpty
                                      ? medicineDetailModel.medicine!.imageUrl!
                                          .map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return GestureDetector(
                                                  onTap: () {
                                                    debugPrint(
                                                        "vcarez i am clicked carosil");
                                                    zoomImageViewer();
                                                  },
                                                  child: Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    margin: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 5.0),
                                                    decoration: BoxDecoration(
                                                        color: bgColor,
                                                        borderRadius:
                                                            const BorderRadius
                                                                    .all(
                                                                Radius.circular(
                                                                    5)),
                                                        image: medicineDetailModel
                                                                        .medicine!
                                                                        .imageUrl !=
                                                                    null &&
                                                                i != ""
                                                            ? DecorationImage(
                                                                // image: AssetImage(demoProductImage_),

                                                                image:
                                                                    NetworkImage(
                                                                        i),
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                              )
                                                            : const DecorationImage(
                                                                image:
                                                                    AssetImage(
                                                                        noImage),
                                                                fit: BoxFit
                                                                    .scaleDown,
                                                              )),
                                                  ));
                                            },
                                          );
                                        }).toList()
                                      : demoList.map((i) {
                                          return Builder(
                                            builder: (BuildContext context) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 5.0),
                                                decoration: BoxDecoration(
                                                    color: bgColor,
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                            Radius.circular(5)),
                                                    image: medicineDetailModel
                                                                .medicine!
                                                                .imageUrl !=
                                                            null
                                                        ? const DecorationImage(
                                                            image: AssetImage(
                                                                noImage),
                                                            // image: NetworkImage(i),
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          )
                                                        : const DecorationImage(
                                                            image: AssetImage(
                                                                noImage),
                                                            fit: BoxFit
                                                                .scaleDown,
                                                          )),
                                              );
                                            },
                                          );
                                        }).toList(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: medicineDetailModel
                                                  .medicine!.imageUrl !=
                                              null &&
                                          medicineDetailModel
                                              .medicine!.imageUrl!.isNotEmpty
                                      ? medicineDetailModel.medicine!.imageUrl!
                                          .asMap()
                                          .entries
                                          .map((entry) {
                                          return GestureDetector(
                                            //onTap: () => _controller.animateToPage(entry.key),
                                            child: Container(
                                              width: 7.0,
                                              height: 7.0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black)
                                                      .withOpacity(
                                                          _current == entry.key
                                                              ? 0.9
                                                              : 0.4)),
                                            ),
                                          );
                                        }).toList()
                                      : demoList.asMap().entries.map((entry) {
                                          return GestureDetector(
                                            //onTap: () => _controller.animateToPage(entry.key),
                                            child: Container(
                                              width: 7.0,
                                              height: 7.0,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0,
                                                      horizontal: 4.0),
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: (Theme.of(context)
                                                                  .brightness ==
                                                              Brightness.dark
                                                          ? Colors.white
                                                          : Colors.black)
                                                      .withOpacity(
                                                          _current == entry.key
                                                              ? 0.9
                                                              : 0.4)),
                                            ),
                                          );
                                        }).toList(),
                                ),
                              ),
                            ],
                          )
                        : SizedBox(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> zoomImageViewer() async {
    return await showDialog(
        context: context,
        builder: (context) {
          // bool isChecked = false;
          int alternativeType = 0;
          String? deliveryType = "deliver";
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              // actionsAlignment: MainAxisAlignment.start,

              title: Align(
                  alignment: AlignmentDirectional.topStart,
                  child: InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: const Icon(
                        Icons.close,
                        color: blackColor,
                      ))),
              // actions: [Text("Close",style: TextStyle(color: whiteColor),)],
              backgroundColor: whiteColor,

              insetPadding: const EdgeInsets.all(20),
              content: Container(
                  color: whiteColor,
                  width: MediaQuery.of(context).size.width - 10,
                  child: PhotoViewGallery.builder(
                    backgroundDecoration:
                        const BoxDecoration(color: whiteColor),
                    scrollPhysics: const BouncingScrollPhysics(),
                    builder: (BuildContext context, int index) {
                      return PhotoViewGalleryPageOptions(
                        imageProvider: NetworkImage(
                            medicineDetailModel.medicine!.imageUrl![index]),
                        initialScale: PhotoViewComputedScale.contained * 0.8,
                        heroAttributes: PhotoViewHeroAttributes(tag: index),
                      );
                    },
                    itemCount: medicineDetailModel.medicine!.imageUrl!.length,

                    loadingBuilder: (context, event) => Center(
                      child: Container(
                        width: 20.0,
                        height: 20.0,
                        child: CircularProgressIndicator(
                          value: event == null
                              ? 0
                              // : event.cumulativeBytesLoaded / event.expectedTotalBytes,
                              : event.cumulativeBytesLoaded / 500,
                        ),
                      ),
                    ),
                    // backgroundDecoration: ,
                    // pageController: widget.pageController,
                    // onPageChanged: onPageChanged,
                  )),
              // title: Text('Delivery Information'),
            );
          });
        });
  }

  Widget bestPriceWidget() {
    return BlocProvider(
      create: (context) => medicineDetailBloc,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0, left: 15, right: 15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 4),
              )
            ],
            borderRadius: BorderRadius.circular(10),
            shape: BoxShape.rectangle,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0, top: 10),
                  child: Row(
                    children: [
                      const StandardCustomText(
                        label: 'Best price*',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: textColor,
                        // style: TextStyle(
                        //     color: Colors.black,
                        //     fontWeight: FontWeight.bold,
                        //     fontSize: 20),
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      StandardCustomText(
                        label: medicineDetailModel.medicine != null
                            ? medicineDetailModel.medicine!.mrp != null
                                ? "$rupeesString ${medicineDetailModel.medicine!.mrp!}"
                                : ""
                            : "",
                        color: redColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        /*FlutterFlowTheme.of(context)
                                                      .bodyText1
                                                      .override(
                                                    fontFamily: 'Poppins',
                                                    color: Color(0xFFFF0303),
                                                  ),*/
                      ),
                    ],
                  ),
                ),
              ),
              const Align(
                alignment: AlignmentDirectional.centerStart,
                child: Padding(
                  padding: EdgeInsets.only(left: 20, top: 10),
                  child: StandardCustomText(
                    label: 'Inclusive of all taxes',
                    color: descriptionTextColor,
                  ),
                ),
              ),
              BlocConsumer<MedicineDetailBloc, MedicineDetailState>(
                listener: (context, state) {
                  // TODO: implement listener
                  debugPrint("vcares qunaity moetted " + state.toString());
                  if (state is OnUpdateQuantitySuccessState) {
                    intQuantity = state.intQuantity;
                  }
                },
                builder: (context, state) {
                  debugPrint("vcares qunaity moetted " + state.toString());
                  return Row(
                    children: [
                      const SizedBox(
                        width: 15,
                      ),
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: InkWell(
                            onTap: () {
                              if (intQuantity > 1) {
                                intQuantity = intQuantity - 1;
                                medicineDetailBloc.add(
                                    UpdateMedicineQuantityEvent(intQuantity));
                              }
                            },
                            child: SvgPicture.asset(
                              minusGreyIcon,
                            ),
                          )),
                      const SizedBox(
                        width: 5,
                      ),
                      StandardCustomText(
                          label: intQuantity.toString(),
                          color: greyColor,
                          fontWeight: FontWeight.w900,
                          fontSize: 12.0),
                      const SizedBox(
                        width: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () {
                              // if (intQuantity > 1) {

                              debugPrint("vcares plus quantity clicked");
                              intQuantity = intQuantity + 1;
                              debugPrint("vcares plus quantity is " +
                                  intQuantity.toString());
                              medicineDetailBloc.add(
                                  UpdateMedicineQuantityEvent(intQuantity));
                            },
                            child: SvgPicture.asset(
                              plusBlueIcon,
                            )),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 20, bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                          height: 43,
                          width: 150,
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: descriptionTextColor,
                                style: BorderStyle.solid,
                                width: 0.80),
                          ),
                          child: medicineDetailModel.medicine != null
                              ? medicineDetailModel.medicine!.varients !=
                                          null &&
                                      medicineDetailModel
                                          .medicine!.varients!.isNotEmpty
                                  ? DropdownButtonHideUnderline(
                                      child: DropdownButton<Varients>(
                                      // Initial Value
                                      value: dropdownvalue,
                                      // Down Arrow Icon
                                      icon: const Icon(
                                          Icons.arrow_drop_down_sharp),
                                      // Array list of items
                                      items: medicineDetailModel
                                          .medicine!.varients!
                                          .map((Varients items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: SizedBox(
                                            width: 130,
                                            child: StandardCustomText(
                                              maxlines: 1,
                                              label: items.packaging!,
                                              fontSize: 12,
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      // After selecting the desired option,it will
                                      // change button value to selected value
                                      onChanged: (Varients? newValue) {
                                        setState(() {
                                          dropdownvalue = newValue!;
                                          String strMedicineID =
                                              dropdownvalue.id.toString();
                                          String strType = dropdownvalue.type!;
                                          // debugPrint("vcarez medicine list strTitle $strTitle");
                                          // medicineListBloc.add(GetMedicineList(strTitle, medicineListModel));

                                          medicineDetailBloc.add(
                                              GetMedicineDetailEvent(
                                                  strMedicineID, strType));
                                        });
                                      },
                                    ))
                                  : const SizedBox()
                              : SizedBox()),
                    ),
                    Expanded(
                        flex: 2,
                        child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                10, 0, 20, 0),
                            child: BlocBuilder<MedicineDetailBloc,
                                MedicineDetailState>(
                              builder: (context, state) {
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                        currentOrderBG, // Background Color
                                  ),
                                  onPressed: () async {
                                    var connectivityResult =
                                        await (Connectivity()
                                            .checkConnectivity());
                                    if (connectivityResult ==
                                            ConnectivityResult.mobile ||
                                        connectivityResult ==
                                            ConnectivityResult.wifi) {
                                      onAddToCart();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(createMessageSnackBar(
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
                                    padding: const EdgeInsets.only(
                                        left: 5.0,
                                        right: 5.0,
                                        top: 5,
                                        bottom: 5),
                                    child: Center(
                                      child: (state is AddToCartSubmittingState)
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: darkSkyBluePrimaryColor,
                                              ),
                                            )
                                          : const StandardCustomText(
                                              fontSize: 12,
                                              color: darkSkyBluePrimaryColor,
                                              label: "ADD TO CART"),
                                    ),
                                  ),
                                );
                              },
                            ))),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Generated code for this Container Widget...
      ),
    );
  }

  Widget productDetailWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 30, 15, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              )
            ],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(15, 15, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: medicineDetailModel.medicine != null
                      ? medicineDetailModel.medicine!.description != null
                          ? const StandardCustomText(
                              label: 'PRODUCT DETAILS',
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: negativeButtonColor,
                            )
                          : const SizedBox()
                      : const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                  child: Text(
                      medicineDetailModel.medicine != null
                          ? medicineDetailModel.medicine!.description != null
                              ? medicineDetailModel.medicine!.description!
                              : ""
                          : "",
                      // 'Shilajit is a sticky substance found primarily in the rocks of the Himalayas. It develops over centuries from the slow decomposition of plants. Shilajit is commonly used in ayurvedic medicine. It\'s an effective and safe supplement that can have a positive effect on your overall health and well-being.',
                      style: const TextStyle(
                        color: Color(0xFF787575),
                      )),
                ),
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: medicineDetailModel.medicine != null
                      ? medicineDetailModel.medicine!.ingredients != null
                          ? const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: StandardCustomText(
                                label: 'Key ingredients:',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: negativeButtonColor,
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.8, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          medicineDetailModel.medicine != null
                              ? medicineDetailModel.medicine!.ingredients !=
                                      null
                                  ? medicineDetailModel.medicine!.ingredients!
                                  : ""
                              : "",
                          textAlign: TextAlign.start,
                        )),
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: medicineDetailModel.medicine != null
                      ? medicineDetailModel.medicine!.benefits != null
                          ? const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: StandardCustomText(
                                label: 'Benefits :',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: negativeButtonColor,
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                ),
                Align(
                  alignment: const AlignmentDirectional(-0.8, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          medicineDetailModel.medicine != null
                              ? medicineDetailModel.medicine!.benefits != null
                                  ? medicineDetailModel.medicine!.benefits!
                                  : ""
                              : "",
                          textAlign: TextAlign.start,
                        )),
                  ),
                ),
                strType == "non_rx"
                    ? Align(
                        alignment: const AlignmentDirectional(-1, 0),
                        child: medicineDetailModel.medicine!.safetyAdvise !=
                                null
                            ? const Padding(
                                padding:
                                    EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                                child: StandardCustomText(
                                  label: 'Safety Advice:',
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: negativeButtonColor,
                                ),
                              )
                            : const SizedBox(),
                      )
                    : const SizedBox(),
                strType == "non_rx"
                    ? const Align(
                        alignment: AlignmentDirectional(-0.8, 0),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                          child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                "Store the formulation in a cool and dry place | Read the label carefully before use | Keep out of reach and sight of children",
                                textAlign: TextAlign.start,
                              )),
                        ),
                      )
                    : const SizedBox(),
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: medicineDetailModel.medicine != null
                      ? medicineDetailModel.medicine!.howToUse != null
                          ? const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: StandardCustomText(
                                label: 'Direction for use:',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: negativeButtonColor,
                                // style: FlutterFlowTheme.of(context).bodyText1,
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                          medicineDetailModel.medicine != null
                              ? medicineDetailModel.medicine!.howToUse != null
                                  ? medicineDetailModel.medicine!.howToUse!
                                  : ""
                              : "",
                          // 'Shilajit as a dietary supplement may also improve heart health. Researchers tested the cardiac performance of shilajit on lab rats. After receiving a pretreatment of shilajit, some rats were injected with isoproterenol to induce heart injury. The study found that rats given shilajit prior to cardiac injury had fewer cardiac lesions.',
                          style: const TextStyle(
                            color: Color(0xFF787575),
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                          medicineDetailModel.medicine != null
                              ? medicineDetailModel.medicine!.countryOfOrigin !=
                                      null
                                  ? "Country Of Origin: ${medicineDetailModel.medicine!.countryOfOrigin!}"
                                  : ""
                              : "",
                          // 'Shilajit as a dietary supplement may also improve heart health. Researchers tested the cardiac performance of shilajit on lab rats. After receiving a pretreatment of shilajit, some rats were injected with isoproterenol to induce heart injury. The study found that rats given shilajit prior to cardiac injury had fewer cardiac lesions.',
                          style: const TextStyle(
                            color: Color(0xFF787575),
                          ))),
                ),
                Align(
                  alignment: const AlignmentDirectional(-1, 0),
                  child: medicineDetailModel.medicine != null
                      ? medicineDetailModel.medicine!.manufacturerAddress !=
                              null
                          ? const Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                              child: StandardCustomText(
                                label: 'Manufacturer Address:',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: negativeButtonColor,
                                // style: FlutterFlowTheme.of(context).bodyText1,
                              ),
                            )
                          : const SizedBox()
                      : const SizedBox(),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 10),
                  child: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: Text(
                          medicineDetailModel.medicine != null
                              ? medicineDetailModel.medicine!.manufacturer !=
                                      null
                                  ? medicineDetailModel
                                      .medicine!.manufacturerAddress!
                                  : ""
                              : "",
                          // 'Shilajit as a dietary supplement may also improve heart health. Researchers tested the cardiac performance of shilajit on lab rats. After receiving a pretreatment of shilajit, some rats were injected with isoproterenol to induce heart injury. The study found that rats given shilajit prior to cardiac injury had fewer cardiac lesions.',
                          style: const TextStyle(
                            color: Color(0xFF787575),
                          ))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget faqList() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 30, 15, 0),
        child: Material(
            color: Colors.transparent,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
                    child: StandardCustomText(
                      label: 'FAQ\'s :',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: negativeButtonColor,
                    ),
                  ),
                  ListView.builder(
                      itemCount: medicineDetailModel.medicine!.faqs!.length,
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemBuilder: (context, index) {
                        Faqs faq = medicineDetailModel.medicine!.faqs![index];
                        return faqDetailGroupContainer(
                            false, faq.ques!, faq.ans!);
                      })
                ],
              ),
            )));
  }

  MultiInputContainer faqDetailGroupContainer(
      bool _nameGroupExpanded, String strTitle, String strContent) {
    return MultiInputContainer(
      expanded: _nameGroupExpanded,
      title: strTitle,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: StandardCustomText(
              maxlines: 10,
              label: strContent,
              align: TextAlign.start,
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: negativeButtonColor,
            ))
      ],
    );
  }

  Widget safetyAdvice() {
    return Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(15, 30, 15, 0),
        child: Material(
            color: Colors.transparent,
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 4,
                    color: Color(0x33000000),
                    offset: Offset(0, 2),
                  )
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(10, 10, 0, 10),
                    child: StandardCustomText(
                      label: 'Safety Advice:',
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: negativeButtonColor,
                    ),
                  ),
                  medicineDetailModel.medicine!.safetyAdvise!.isNotEmpty
                      ? safetyRowWidget(
                          0, medicineDetailModel.medicine!.safetyAdvise![0])
                      : const SizedBox(),
                  medicineDetailModel.medicine!.safetyAdvise!.length > 1
                      ? safetyRowWidget(
                          1, medicineDetailModel.medicine!.safetyAdvise![1])
                      : const SizedBox(),
                  medicineDetailModel.medicine!.safetyAdvise!.length > 2
                      ? safetyRowWidget(
                          2, medicineDetailModel.medicine!.safetyAdvise![2])
                      : const SizedBox(),
                  medicineDetailModel.medicine!.safetyAdvise!.length > 3
                      ? safetyRowWidget(
                          3, medicineDetailModel.medicine!.safetyAdvise![3])
                      : const SizedBox(),
                  medicineDetailModel.medicine!.safetyAdvise!.length > 4
                      ? safetyRowWidget(
                          4, medicineDetailModel.medicine!.safetyAdvise![4])
                      : const SizedBox(),
                  medicineDetailModel.medicine!.safetyAdvise!.length > 5
                      ? safetyRowWidget(
                          5, medicineDetailModel.medicine!.safetyAdvise![5])
                      : const SizedBox(),
                  medicineDetailModel.medicine!.safetyAdvise!.length > 6
                      ? safetyRowWidget(
                          6, medicineDetailModel.medicine!.safetyAdvise![6])
                      : const SizedBox(),
                  medicineDetailModel.medicine!.safetyAdvise!.length > 7
                      ? safetyRowWidget(
                          7, medicineDetailModel.medicine!.safetyAdvise![7])
                      : const SizedBox(),
                ],
              ),
            )));
  }

  Widget rowFAQWidget(int index, SafetyAdvise safetyAdvise) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      // child: ,
    );
  }

  Widget safetyRowWidget(int index, SafetyAdvise safetyAdvise) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image(
                    height: 30,
                    width: 30,
                    image: index == 0
                        ? const AssetImage(alcoholImage)
                        : index == 1
                            ? const AssetImage(pregnancyImage)
                            : index == 2
                                ? const AssetImage(breastFeedingImage)
                                : index == 3
                                    ? const AssetImage(drivingImage)
                                    : index == 4
                                        ? const AssetImage(kidneyImage)
                                        : index == 5
                                            ? const AssetImage(liverImage)
                                            : const AssetImage(noImage)
                    // fit: BoxFit.scaleDown,
                    ),
              ),
              Text(safetyAdvise.title != null ? safetyAdvise.title! : "",
                  // 'Shilajit as a dietary supplement may also improve heart health. Researchers tested the cardiac performance of shilajit on lab rats. After receiving a pretreatment of shilajit, some rats were injected with isoproterenol to induce heart injury. The study found that rats given shilajit prior to cardiac injury had fewer cardiac lesions.',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF787575),
                  )),
              const SizedBox(
                width: 5,
              ),
              Container(
                decoration: BoxDecoration(
                  color: getSafetyAdviceBackgroundColor(
                      safetyAdvise.instruction != null
                          ? safetyAdvise.instruction!
                          : ""),
                  // boxShadow: const [
                  //   BoxShadow(
                  //     blurRadius: 4,
                  //     color: Color(0x33000000),
                  //     offset: Offset(0, 2),
                  //   )
                  // ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      safetyAdvise.instruction != null
                          ? safetyAdvise.instruction!
                          : "",
                      // 'Shilajit as a dietary supplement may also improve heart health. Researchers tested the cardiac performance of shilajit on lab rats. After receiving a pretreatment of shilajit, some rats were injected with isoproterenol to induce heart injury. The study found that rats given shilajit prior to cardiac injury had fewer cardiac lesions.',
                      style: const TextStyle(
                        fontSize: 10,
                        color: Color(0xFF787575),
                      )),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
                safetyAdvise.message != null ? safetyAdvise.message! : "",

                // 'Shilajit as a dietary supplement may also improve heart health. Researchers tested the cardiac performance of shilajit on lab rats. After receiving a pretreatment of shilajit, some rats were injected with isoproterenol to induce heart injury. The study found that rats given shilajit prior to cardiac injury had fewer cardiac lesions.',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: textColor,
                )),
          ),
        ],
      ),
    );
  }

  Widget substituteProductWidget() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(15, 20, 15, 20),
      child: Material(
        color: Colors.transparent,
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 4,
                        child: StandardCustomText(
                            align: TextAlign.start,
                            maxlines: 2,
                            label:
                                'All Substitute for\n${medicineDetailModel.medicine!.name}',
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),

                    // Expanded(
                    //     flex: 1,
                    //     child: InkWell(
                    //       onTap: () {
                    //         const UploadPrescriptionWidget();
                    //       },
                    //       child: const Text('VIEW ALL',
                    //           style: TextStyle(
                    //               fontSize: 10,
                    //               color: Color(0xFF2088CB),
                    //               fontWeight: FontWeight.bold)),
                    //     )),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0),
                  child: StandardCustomText(
                      align: TextAlign.start,
                      maxlines: 2,
                      label:
                          'For informational purposes only. Consult a doctor before taking any medicines.',
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Container(
                    height: 300,
                    child: ListView.builder(
                        itemCount: medicineDetailModel.suggestions!.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          Suggestions suggestion =
                              medicineDetailModel.suggestions![index];
                          return Padding(
                            padding:
                                const EdgeInsets.only(top: 8.0, bottom: 10),
                            child: Column(
                              children: [
                                InkWell(
                                    onTap: () {
                                      // Navigator.pushNamed(
                                      //     context, routeMedicineDetails,
                                      //     arguments: suggestion.id.toString());

                                      Navigator.pushNamed(
                                          context, routeMedicineDetails,
                                          arguments: {
                                            'type': suggestion.type,
                                            'id': suggestion.id.toString(),
                                          } // arguments: i.id.toString()
                                          );
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                            flex: 6,
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  StandardCustomText(
                                                    align: TextAlign.start,
                                                    label: suggestion.name!,
                                                    fontSize: 12,
                                                    color: negativeButtonColor,
                                                  ),
                                                  const Text('',
                                                      style: TextStyle(
                                                        fontSize: 10,
                                                        color:
                                                            Color(0xFF787575),
                                                      )),
                                                ],
                                              ),
                                            )),
                                        const Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.keyboard_arrow_right,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                        ),
                                        Expanded(
                                            flex: 3,
                                            child: StandardCustomText(
                                              label:
                                                  '$rupeesString ${suggestion.mrp.toString()}',
                                              fontSize: 12,
                                            )),
                                      ],
                                    )),
                                const Divider()
                              ],
                            ),
                          );
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onAddToCart() {
    Medicine? medicine = medicineDetailModel.medicine;

    medicineDetailBloc.add(AddToCartMedicineEvent(
        medicine!.id.toString(),
        medicine.name != null ? medicine.name! : "",
        medicine.imageUrl![0],
        medicine.type != null ? medicine.type! : "",
        medicine.mrp != null ? medicine.mrp.toString() : "",
        medicine.packaging != null ? medicine.packaging! : "",
        medicine.packInfo != null ? medicine.packInfo! : "",
        intQuantity.toString()));
  }

  Color? getSafetyAdviceBackgroundColor(String strType) {
    if (strType == strUnsafe) {
      return colorUnsafe;
    } else if (strType == strCaution) {
      return colorCaution;
    } else if (strType == strConsultDoctor) {
      return colorConsultDoctor;
    } else if (strType == strSafeToPrescrip) {
      return colorSafeToPrescrip;
    }
    return colorCaution;
  }
}
