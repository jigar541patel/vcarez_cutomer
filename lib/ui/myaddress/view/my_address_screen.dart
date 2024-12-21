import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/model/address_list_model.dart';
import 'package:vcarez_new/ui/my_prescription/bloc/my_prescription_bloc.dart';
import 'package:vcarez_new/ui/myaddress/bloc/my_address_bloc.dart';
import 'package:vcarez_new/ui/myaddress/model/edit_address_request_model.dart';
import 'package:vcarez_new/ui/privilegeplan/view/privilage_plan_screen.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../commonmodel/cart_provider.dart';
import '../../../components/my_theme_button.dart';
import '../../../components/standard_regular_text.dart';
import '../../../utils/SizeConfig.dart';
import '../../../utils/strings.dart';

class MyAddressScreen extends StatefulWidget {
  const MyAddressScreen({Key? key}) : super(key: key);

  @override
  State<MyAddressScreen> createState() => _MyAddressScreenState();
}

class _MyAddressScreenState extends State<MyAddressScreen> {
  late TextEditingController _searchMedicineController;
  var demoList = [1, 2, 3, 4, 5];

  MyAddressBloc myAddressBloc = MyAddressBloc();

  EditAddressRequestModel editAddressRequestModel = EditAddressRequestModel();

  Widget imageAppLogo() => SvgPicture.asset(
        appLogo_,
        height: 18.0,
        width: 116.0,
      );

  AddressListModel myAddressModel = AddressListModel();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (ModalRoute.of(context)!.settings.arguments != null) {
      // String strMedicineID =
      //     ModalRoute.of(context)!.settings.arguments as String;
      // debugPrint("vcarez vendor strMedicineID $strMedicineID");
      myAddressBloc.add(GetAddressListEvent());

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
    SizeConfig().init(context);
    return Scaffold(
        backgroundColor: backgroundColor,
        body: BlocProvider(
          create: (context) => myAddressBloc,
          child: BlocConsumer<MyAddressBloc, MyAddressState>(
            listener: (context, state) {
              // TODO: implement listener
              if (state is OnAddressLoaded) {
                myAddressModel = state.addressListModel;
              }
              if (state is DeleteAddressValidCompletedState) {
                myAddressBloc.add(GetAddressListEvent());
              }
            },
            builder: (context, state) {
              return SafeArea(
                  child: Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        topHeader(),
                        Container(
                          height: MediaQuery.of(context).size.height * .73,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  state is OnAddressLoading
                      ? const Align(
                          alignment: AlignmentDirectional.center,
                          child: CustomLoader(),
                        )
                      : state is OnAddressLoaded
                          ? Container(
                              alignment: Alignment.topCenter,
                              padding: EdgeInsets.only(
                                  top: MediaQuery.of(context).size.height * .20,
                                  right: 20.0,
                                  left: 20.0),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width,
                                child: myAddressModel.addresses != null
                                    ? myAddressModel.addresses!.isNotEmpty
                                        ? myAddressList()
                                        : CommonUtils.NoDataFoundPlaceholder(
                                            context)
                                    : const SizedBox(),
                              ),
                            )
                          : const SizedBox(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.only(
                            right: 20.0, left: 20.0, top: 45),
                        child: MyThemeButton(
                          buttonText: 'Add Address',
                          onPressed: () {
                            Navigator.pushReplacementNamed(
                                context, routeSaveAddress);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //       builder: (context) => const OrderConfirmationScreen()),
                            // );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ));
            },
          ),
        ));
  }

  Widget topHeader() {
    return Container(
      height: MediaQuery.of(context).size.height * .27,
      padding: const EdgeInsets.only(top: 24.0, bottom: 0.0, left: 16.0),
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
            height: 30.0,
          ),
          const Align(
            alignment: Alignment.bottomLeft,
            child: StandardCustomText(
              label: "My Addresses",
              fontWeight: FontWeight.bold,
              color: whiteColor,
              fontSize: 22.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget myAddressList() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .75,
        child: SingleChildScrollView(
            child: ListView.builder(
                itemCount: myAddressModel.addresses!.length,
                // itemCount: 10,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  // index=0;
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(8, 5, 7, 5),
                    child: GestureDetector(
                        onTap: () {
                          debugPrint("vacrez the click is called ");
                        },
                        child: Container(
                            // height: 135,
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10))),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 15.0, 15.0, 5.0),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Expanded(
                                          child: SizedBox(
                                        child: Text('Address :',
                                            style: TextStyle(
                                                color: textColor,
                                                fontWeight: FontWeight.w900,
                                                fontSize: 14.0)),
                                        // )),
                                      )),
                                      InkWell(
                                          onTap: () {
                                            deleteAddressDialog(myAddressModel
                                                .addresses![index].id
                                                .toString());
                                          },
                                          child: const Icon(
                                            Icons.delete_forever_sharp,
                                            color: greyLightColor,
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                      myAddressModel.addresses![index].address!=null? myAddressModel.addresses![index].address!:"",
                                      style: const TextStyle(
                                          color: darkSkyBluePrimaryColor,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12.0)),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: 160,
                                    // margin: const EdgeInsets.only(top: 24.0),
                                    height: 45,
                                    child: MyThemeButton(
                                      fontSize: 12,
                                      buttonText: 'Edit Address',
                                      onPressed: () {
                                        FocusScope.of(context)
                                            .requestFocus(FocusNode());

                                        editAddressRequestModel.strAddressID =
                                            myAddressModel.addresses![index].id
                                                .toString();
                                        editAddressRequestModel.strAddress =
                                            myAddressModel
                                                .addresses![index].address
                                                .toString();
                                        editAddressRequestModel.strState =
                                            myAddressModel
                                                .addresses![index].stateId
                                                .toString();
                                        editAddressRequestModel.strCity =
                                            myAddressModel
                                                .addresses![index].cityId
                                                .toString();
                                        editAddressRequestModel.strLatitude =
                                            myAddressModel
                                                .addresses![index].lattitude
                                                .toString();
                                        editAddressRequestModel.strLongitude =
                                            myAddressModel
                                                .addresses![index].longitude
                                                .toString();
                                        editAddressRequestModel.strPincode =
                                            myAddressModel
                                                .addresses![index].pincode
                                                .toString();

                                        Navigator.pushNamed(
                                            context, routeSaveAddress,
                                            arguments: {
                                              'title': "MyAddress",
                                              'model': editAddressRequestModel,
                                            });
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ))),
                  );
                })),
      ),
    );
  }

  Future<void> deleteAddressDialog(String strAddressID) async {
    return await showDialog(
        context: context,
        builder: (context) {
          // bool isChecked = false;
          int alternativeType = 0;
          String? deliveryType = "deliver";
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              insetPadding: const EdgeInsets.all(10),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Do you want to remove this address ?',
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    // mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.only(
                            right: 5.0, left: 5.0, top: 10),
                        child: MyThemeButton(
                          buttonText: 'Cancel',
                          onPressed: () async {
                            Navigator.pop(context);
                          },
                        ),
                      )),
                      Expanded(
                          child: Container(
                        padding: const EdgeInsets.only(
                            right: 5.0, left: 5.0, top: 10),
                        child: MyThemeButton(
                          buttonText: 'Delete',
                          onPressed: () async {
                            Navigator.pop(context);
                            onDeleteButtonClicked(strAddressID);
                          },
                        ),
                      )),
                    ],
                  ),
                ],
              ),
              title: const Text('Remove Address'),
            );
          });
        });
  }

  void onDeleteButtonClicked(String strAddressID) {
    // this.strAddress, this.strCity, this.strState, this.strLocation,this.strLatitude,this.strLongitude);
    myAddressBloc.add(DeleteAddressEvent(strAddressID));
  }

  String dateTimeFormatter(String dateTime, {String? format}) {
    return DateFormat(format ?? 'yyyy/MM/dd, hh:mm a')
        .format(DateTime.parse(dateTime).toLocal())
        .toString();
  }
}
