import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:vcarez_new/ui/dashboard/pages/prescription/view/bloc/parent_upload_prescription_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/view/widget/upload_prescription_widget.dart';
import 'package:vcarez_new/utils/SizeConfig.dart';

import '../../../../../commonmodel/cart_provider.dart';
import '../../../../../components/standard_regular_text.dart';
import '../../../../../utils/colors_utils.dart';
import '../../../../../utils/images_utils.dart';
import '../../../../../utils/route_names.dart';

class AddPrescriptionPage extends StatefulWidget {
  const AddPrescriptionPage({super.key});

  @override
  AddPrescriptionState createState() => AddPrescriptionState();
}

class AddPrescriptionState extends State<AddPrescriptionPage> {
  TextEditingController? textController1 = TextEditingController();
  TextEditingController? textController2 = TextEditingController();
  ParentUploadPrescriptionBloc parentUploadPrescriptionBloc =
      ParentUploadPrescriptionBloc();

  TextEditingController? textController = TextEditingController();
  var currentLocation = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    parentUploadPrescriptionBloc.add(GetPrescriptionLocationName());
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<CartProvider>().getData();
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

    Widget profilePicImage() => SvgPicture.asset(
          userPicPlaceHolder,
          height: 45.0,
          width: 45.0,
        );
    return BlocProvider(
      create: (context) => parentUploadPrescriptionBloc,
      child: Scaffold(
          backgroundColor: bgColor,
          body: SafeArea(
            child: SingleChildScrollView(
                child: Column(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .27,
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
                                profilePicImage(),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0),
                                  child: imageAppLogo(),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 5.0),
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
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30.0,
                      ),
                      const Align(
                        alignment: Alignment.bottomLeft,
                        child: StandardCustomText(
                          label: 'Hi,',
                          fontWeight: FontWeight.bold,
                          color: whiteColor,
                          fontSize: 20.0,
                        ),
                      ),
                      const SizedBox(
                        height: 7,
                      ),
                      const Align(
                          alignment: Alignment.bottomLeft,
                          child: StandardCustomText(
                            label: 'Please Upload the Prescription',
                            fontWeight: FontWeight.bold,
                            color: whiteColor,
                            fontSize: 18.0,
                          )),
                      const SizedBox(
                        height: 10,
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
                            child: BlocConsumer<ParentUploadPrescriptionBloc,
                                ParentUploadPrescriptionState>(
                              listener: (context, state) async {
                                // TODO: implement listener
                                if (state is OnLocationLoadedState) {
                                  currentLocation = state.strLocation!;
                                  // homeBloc.add(await GetBannerList());
                                  // homeBloc.add(await GetCategoryList());
                                }
                              },
                              builder: (context, state) {
                                return StandardCustomText(
                                  label: currentLocation,
                                  fontWeight: FontWeight.bold,
                                  color: whiteColor,
                                  fontSize: SizeConfig.safeBlockVertical! * 1.8,
                                );
                              },
                            ),
                          ),
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
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),

                //- change is here
                Container(
                  width: double.infinity,
                  transform: Matrix4.translationValues(0.0, -5.0, 0.0),
                  decoration: const BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(0.0),
                        topLeft: Radius.circular(10.0),
                        bottomLeft: Radius.circular(0.0)),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        child: const UploadPrescriptionWidget(),
                      ),
                    ),
                  ),
                )
              ],
            )),
          )),
    );
  }
}
