import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/ui/my_prescription/bloc/my_prescription_bloc.dart';
import 'package:vcarez_new/ui/my_prescription/model/MyPrescriptionModel.dart';
import 'package:vcarez_new/ui/privilegeplan/view/privilage_plan_screen.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/my_theme_button.dart';
import '../../../components/standard_regular_text.dart';
import '../../../utils/CommonUtils.dart';
import '../../../utils/route_names.dart';
import '../../../utils/strings.dart';

class MyPrescriptionScreen extends StatefulWidget {
  const MyPrescriptionScreen({Key? key}) : super(key: key);

  @override
  State<MyPrescriptionScreen> createState() => _MyPrescriptionScreenState();
}

class _MyPrescriptionScreenState extends State<MyPrescriptionScreen> {
  late TextEditingController _searchMedicineController;
  var demoList = [1, 2, 3, 4, 5];

  MyPrescriptionBloc myPrescriptionBloc = MyPrescriptionBloc();

  MyPrescriptionModel myPrescriptionModel = MyPrescriptionModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (ModalRoute.of(context)!.settings.arguments != null) {
      // String strMedicineID =
      //     ModalRoute.of(context)!.settings.arguments as String;
      // debugPrint("vcarez vendor strMedicineID $strMedicineID");
      myPrescriptionBloc.add(GetPrescriptionListEvent());

      context.read<CartProvider>().getData();
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
        body: BlocProvider(
          create: (context) => myPrescriptionBloc,
          child: BlocConsumer<MyPrescriptionBloc, MyPrescriptionState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is DataLoaded) {
                myPrescriptionModel = state.myPrescriptionModel;
              }
            },
            builder: (context, state) {
              return state is DataLoading
                  ? const Align(
                      alignment: AlignmentDirectional.center,
                      child: CustomLoader(),
                    )
                  : state is DataLoaded
                      ? SafeArea(
                          child: Stack(
                          children: <Widget>[
                            SingleChildScrollView(
                              child: Column(
                                children: [
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .27,
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
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Align(
                                            alignment: Alignment.topLeft,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
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
                                                          const EdgeInsets.only(
                                                              left: 8.0),
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
                                            label: myPrescription,
                                            fontWeight: FontWeight.bold,
                                            color: whiteColor,
                                            fontSize: 22.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: MediaQuery.of(context).size.height *
                                        .73,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * .17,
                                  right: 20.0,
                                  left: 20.0),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: myPrescriptionModel.prescriptionList !=
                                          null
                                      ? myPrescriptionModel
                                              .prescriptionList!.isNotEmpty
                                          ? myPrescriptionList()
                                          : CommonUtils.NoDataFoundPlaceholder(
                                              context,
                                              message: "No Prescription Found")
                                      : const SizedBox()),
                            )
                          ],
                        ))
                      : const SizedBox();
            },
          ),
        ));
  }

  Widget myPrescriptionList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * .75,
      child: SingleChildScrollView(
          child: ListView.builder(
              itemCount: myPrescriptionModel.prescriptionList!.length,
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
                                      0, 5), // changes position of shadow
                                ),
                              ],
                              border: Border.all(
                                color: whiteColor,
                              ),
                              color: whiteColor,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(
                                15.0, 15.0, 15.0, 5.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Align(
                                      alignment: AlignmentDirectional.center,
                                      child: myPrescriptionModel
                                                  .prescriptionList![index]
                                                  .prescription !=
                                              null
                                          ? Image(
                                              width: 75,
                                              height: 81,
                                              image: NetworkImage(
                                                  myPrescriptionModel
                                                      .prescriptionList![index]
                                                      .prescription!),
                                              errorBuilder:
                                                  (BuildContext context,
                                                      Object exception,
                                                      StackTrace? stackTrace) {
                                                return const Image(
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
                                          padding: const EdgeInsets.all(2.0),
                                          child: SizedBox(
                                            child: Row(
                                              children: [
                                                const Text('Date :',
                                                    style: TextStyle(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12.0)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    dateTimeFormatter(
                                                        myPrescriptionModel
                                                            .prescriptionList![
                                                                index]
                                                            .createdAt!,
                                                        format: "yyyy/MM/dd"),
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
                                          padding: const EdgeInsets.all(2.0),
                                          child: SizedBox(
                                            child: Row(
                                              children: [
                                                const Text('Time :',
                                                    style: TextStyle(
                                                        color: textColor,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                        fontSize: 12.0)),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Text(
                                                    dateTimeFormatter(
                                                        myPrescriptionModel
                                                            .prescriptionList![
                                                                index]
                                                            .createdAt!,
                                                        format: "hh:mm a"),
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
                                          height: 5,
                                        ),
                                        SizedBox(
                                          width: 160,
                                          // margin: const EdgeInsets.only(top: 24.0),
                                          height: 45,
                                          child: MyThemeButton(
                                            fontSize: 12,
                                            buttonText: 'Place an Order',
                                            onPressed: () {
                                              FocusScope.of(context)
                                                  .requestFocus(FocusNode());

                                              Navigator.pushNamed(context, routeQuotationDetailList,
                                                  arguments: {
                                                  'id': myPrescriptionModel
                                                      .prescriptionList![
                                                  index].customerQuotationId!.toString(),
                                                  }
                                              );
                                              // Navigator.push(
                                              //   context,
                                              //   MaterialPageRoute(
                                              //       builder: (context) =>
                                              //           const PrivilegePlanScreen()),
                                              // );

                                              // if (_formKey.currentState!
                                              //     .validate()) {
                                              //   onLoginButtonClicked();
                                              // }
                                            },
                                            // StandardCustomText(
                                            //   label: 'Place an Order',
                                            //   fontSize: 12,
                                            //   fontWeight: FontWeight.w900,
                                            //   color:
                                            //       darkSkyBluePrimaryColor,
                                            // ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ))),
                );
              })),
    );
  }

  String dateTimeFormatter(String dateTime, {String? format}) {
    return DateFormat(format ?? 'yyyy/MM/dd, hh:mm a')
        .format(DateTime.parse(dateTime).toLocal())
        .toString();
  }
}
