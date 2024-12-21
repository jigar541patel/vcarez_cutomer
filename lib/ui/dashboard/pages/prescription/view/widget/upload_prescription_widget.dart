import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vcarez_new/components/common_loader.dart';
import 'package:vcarez_new/components/custom_snack_bar.dart';
import 'package:vcarez_new/components/standard_regular_text.dart';
import 'package:vcarez_new/dialog/popup_dialog.dart';
import 'package:vcarez_new/services/configuration_service.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/bloc/add_prescription_bloc.dart';
import 'package:vcarez_new/ui/dashboard/pages/prescription/model/address_list_model.dart';
import 'package:vcarez_new/utils/SizeConfig.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/images_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';
import 'package:vcarez_new/utils/strings.dart';

import '../../../../../../components/my_theme_button.dart';
import '../../../../../../services/repo/common_repo.dart';
import '../../../../../storage/shared_pref_const.dart';
import '../../../home/model/search_medicine_model.dart';

class UploadPrescriptionWidget extends StatefulWidget {
  const UploadPrescriptionWidget({Key? key}) : super(key: key);

  @override
  _UploadPrescriptionWidgetState createState() =>
      _UploadPrescriptionWidgetState();
}

class _UploadPrescriptionWidgetState extends State<UploadPrescriptionWidget> {
  // TextEditingController? medicineNameTextController;
  final _formKey = GlobalKey<FormState>();

  TextEditingController? medicineQtyTextController;
  TextEditingController? textSpecifyMedicine;
  TextEditingController? textDeliveryAddress;
  File? _profileImageFile;
  List<Map<String, String>> listOfMedicineColumns = [
    // {"MedicineName": "AAAAAA", "Qty": "4"},
    // {"MedicineName": "BBBBBB", "Qty": "3"},
    // {"MedicineName": "CCCCCC", "Qty": "5"}
  ];
  AddPrescriptionBloc addPrescriptionBloc = AddPrescriptionBloc();
  AddressListModel addressListModel = AddressListModel();
  TextEditingController? textController;
  TextEditingController? medicineNameSearchController = TextEditingController();
  TextEditingController? textMRPController = TextEditingController();
  TextEditingController? textQuantityController = TextEditingController();

  // TextEditingController? textRateController = TextEditingController();
  SearchResultModel searchResultModel = SearchResultModel();
  final ConfigurationService? configurationService = ConfigurationService();
  String? itemPrescriptionType = "all";
  String? deliveryType = "deliver";
  String token = "";
  int alternativeType = 0;
  bool openMedicineTab = false;
  int medicineID = 0;
  String? medicineType;
  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    // medicineNameTextController = TextEditingController();
    medicineQtyTextController = TextEditingController();
    // medicineNameTextController!.text = "Ultracet";
    // medicineQtyTextController!.text = "15";
    textSpecifyMedicine = TextEditingController();
    textDeliveryAddress = TextEditingController();
    // textSpecifyMedicine!.text != "I need Levosiz tablet 10 mg";
    // textDeliveryAddress!.text = "Bombay Pune Highway";
    initController();
  }

  Future<void> initController() async {
    var storage = const FlutterSecureStorage();

    token = (await storage.read(key: keyUserToken))!;
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            uploadPrescriptionTypeList(),
            openMedicineTab ? medicineNameList() : const SizedBox(),
            // medicineNameList(),
            addedPrescriptionView(),
            alternativeMedicineContainer(),

            orderTypeRadio(),
            validPrescriptionList(),
            prescriptionGuide(context),
            submitButtonQuotation()
          ],
        ));
  }

  submitButtonQuotation() {
    return Container(
      margin: const EdgeInsets.only(top: 24.0),
      child: BlocProvider(
        create: (context) => addPrescriptionBloc,
        child: BlocBuilder<AddPrescriptionBloc, AddPrescriptionState>(
          builder: (context, state) {
            if (state is AddingDataValidCompletedState) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                addPrescriptionBloc.emit(RouteMyPrescriptionCompletedState());
                setState(() {
                  clearALL();
                });
                Navigator.pushNamed(context, routeMyPrescription);
                // Navigator.of(context).maybePop();
              });
            }
            return MaterialButton(
                onPressed: () async {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (_profileImageFile != null) {
                    if (_formKey.currentState!.validate()) {
                      var connectivityResult =
                          await (Connectivity().checkConnectivity());
                      if (connectivityResult == ConnectivityResult.mobile ||
                          connectivityResult == ConnectivityResult.wifi) {
                        debugPrint(
                            "vcarez cust we itemPrescriptionType have is " +
                                itemPrescriptionType.toString());
                        debugPrint(
                            "vcarez cust we textSpecifyMedicine!.text have is " +
                                textSpecifyMedicine!.text.toString());

                        onUploadButtonClicked();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            createMessageSnackBar(errorNoInternet));
                      }
                    } else {
                      if (itemPrescriptionType == "only" &&
                          textSpecifyMedicine!.text.trim() == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            createMessageSnackBar(
                                medicineNamePrescriptionRequiredError));
                        // onUploadButtonClicked();
                      } else if (deliveryType == "deliver" &&
                          textDeliveryAddress!.text.trim() == "") {
                        ScaffoldMessenger.of(context).showSnackBar(
                            createMessageSnackBar(deliveryAddressError));
                        // onUploadButtonClicked();
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                        createMessageSnackBar(prescriptionImageError));
                  }
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
                padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                color: darkSkyBluePrimaryColor,
                splashColor: Theme.of(context).primaryColor,
                disabledColor: Theme.of(context).disabledColor,
                child: SizedBox(
                  width: double.infinity,
                  height: SizeConfig.blockSizeVertical! * 2.7,
                  child: Center(
                    child: (state is AddingDataInProgressState)
                        ? SizedBox(
                            width: SizeConfig.blockSizeHorizontal! * 5.5,
                            child: const CircularProgressIndicator(
                                //color: darkSkyBluePrimaryColor,
                                ),
                          )
                        : const Text(
                            'Send for a Quotation',
                            style: TextStyle(
                              fontSize: 16,
                              color: whiteColor,
                            ),
                          ),
                  ),
                ));
          },
        ),
      ),
    );

    // return Padding(
    //   padding:
    //       const EdgeInsets.only(bottom: 20.0, left: 25, right: 25, top: 10),
    //   child: MyThemeButton(
    //     // padding: const EdgeInsets.all(20),
    //     textColor: Colors.white,
    //     color: darkSkyBluePrimaryColor,
    //     onPressed: () {
    //       addPrescriptionBloc.add(UploadPrescriptionEvent(
    //           listOfMedicineColumns,
    //           deliveryType!,
    //           itemPrescriptionType!,
    //           " _emailController.text",
    //           " _locationController.text",_profileImageFile));
    //
    //       // Navigator.push(
    //       //   context,
    //       //   MaterialPageRoute(builder: (context) => QuotationsScreen()),
    //       // );
    //     },
    //     // child: const Padding(
    //     //   padding: EdgeInsets.only(left: 88.0, right: 88.0),
    //     //   child: Text('Send for a Quotation'),
    //     //
    //     // ),
    //     buttonText: 'Send for a Quotation',
    //   ),
    // );
  }

  void clearALL() {
    _profileImageFile = null;
    itemPrescriptionType = "all";
    deliveryType = "deliver";
    textDeliveryAddress!.clear();
    textSpecifyMedicine!.clear();
    medicineQtyTextController!.clear();
    // medicineNameTextController!.clear();
  }

  Future<void> onUploadButtonClicked() async {
    FlutterSecureStorage storage = FlutterSecureStorage();

    if (deliveryType != "delivery") {
      String? lat = await storage.read(key: keyUserLat);
      String? long = await storage.read(key: keyUserLong);
      if (lat != null && lat != "") {
        latitude = double.parse(lat);
      }
      if (long != null && long != "") {
        longitude = double.parse(long);
      }
    }
//     else
//         {
// //          pickup
//
//         }
    addPrescriptionBloc.add(UploadPrescriptionEvent(
        listOfMedicineColumns.isNotEmpty
            ? medicineType != "rx"
                ? false
                : true
            : true,
        listOfMedicineColumns,
        deliveryType!,
        alternativeType,
        textDeliveryAddress!.text,
        itemPrescriptionType!,
        textSpecifyMedicine!.text,
        _profileImageFile,
        latitude,
        longitude));
  }

  _cropSelectedProfilePictureFile(File imageFile) async {
    if (imageFile != null) {
      final croppedFile = (await ImageCropper()
          .cropImage(sourcePath: imageFile.path, aspectRatioPresets: [
        CropAspectRatioPreset.square
      ], uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: darkSkyBluePrimaryColor,
            toolbarWidgetColor: whiteColor,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: true),
        IOSUiSettings(
          minimumAspectRatio: 1.0,
          aspectRatioLockEnabled: true,
        )
      ]));

      _updateSelectedProfilePictureFile(File(croppedFile!.path));
    }
  }

  validPrescriptionList() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          // height: 580,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Align(
                  alignment: AlignmentDirectional(-0.9, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: StandardCustomText(
                        label: 'Valid prescription Guide',
                        fontSize: 16,
                        color: blackColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(-0.9, 0),
                  child: Padding(
                    padding: EdgeInsets.only(top: 8.0, left: 8),
                    child: StandardCustomText(
                      label:
                          'Image should be sharp and contain below mentioned four points',
                      color: primaryTextColor,
                      align: TextAlign.start,
                      maxlines: 3,
                      fontSize: 12,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
                  child: Image.asset(
                    prescription2DemoPicImage,
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(-1, 0),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: Padding(
                      padding: EdgeInsets.only(top: 8.0, left: 8),
                      child: Text(
                        'General Guidelines:',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10),
                  child: Text(
                    '1. The photo chosen by the usert should follow the guidelines provided by the admin.',
                    style: TextStyle(fontSize: 12, color: primaryTextColor),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10),
                  child: Text(
                    '2. The user needs to search the medicine from the provided space ',
                    style: TextStyle(fontSize: 12, color: primaryTextColor),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 10, bottom: 20),
                  child: Text(
                    '3. the image needs to be compressed to the minimal size. However, the image should be able to readable format.',
                    style: TextStyle(fontSize: 12, color: primaryTextColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  alternativeMedicineContainer() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
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
            padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Text(
                        'Are you ok with alternative medicine ?',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 0, 20),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // width: 100,
                        child: Row(
                          children: [
                            Radio(
                              value: 1,
                              visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity),
                              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              // contentPadding: EdgeInsets.all(0),
                              groupValue: alternativeType,
                              onChanged: (value) {
                                setState(() {
                                  alternativeType = value as int;
                                });
                              },
                            ),
                            StandardCustomText(
                                label: 'Yes',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical! * 1.7),
                            const SizedBox(
                              width: 20,
                            ),
                            Radio(
                              value: 0,
                              visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity),
                              groupValue: alternativeType,
                              onChanged: (value) {
                                setState(() {
                                  alternativeType = value as int;
                                });
                              },
                            ),
                            StandardCustomText(
                                label: 'No',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical! * 1.7),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  prescriptionGuide(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
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
            padding: const EdgeInsetsDirectional.fromSTEB(7, 0, 0, 0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Align(
                    alignment: AlignmentDirectional.topStart,
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                      child: Text(
                        'Delivery OR Pickup',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 0, 20),
                  child: Column(
                    // mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        // width: 100,
                        child: Row(
                          children: [
                            Radio(
                              value: "deliver",
                              visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity),
                              // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              // contentPadding: EdgeInsets.all(0),
                              groupValue: deliveryType,
                              onChanged: (value) {
                                setState(() {
                                  deliveryType = value.toString();
                                });
                              },
                            ),
                            StandardCustomText(
                                label: 'Delivery',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical! * 1.7),
                            const SizedBox(
                              width: 20,
                            ),
                            Radio(
                              value: "pickup",
                              visualDensity: const VisualDensity(
                                  horizontal: VisualDensity.minimumDensity,
                                  vertical: VisualDensity.minimumDensity),
                              groupValue: deliveryType,
                              onChanged: (value) {
                                setState(() {
                                  deliveryType = value.toString();
                                });
                              },
                            ),
                            StandardCustomText(
                                label: 'Pickup',
                                fontWeight: FontWeight.bold,
                                fontSize: SizeConfig.safeBlockVertical! * 1.7),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Visibility(
                          child: deliveryType == "deliver"
                              ? Align(
                                  alignment: Alignment.center,
                                  child: SizedBox(
                                    width:
                                        SizeConfig.safeBlockHorizontal! * 55.0,
                                    // child:
                                    child: TextButton(
                                      style: TextButton.styleFrom(
                                        primary: darkSkyBluePrimaryColor,
                                        backgroundColor:
                                            currentOrderBG, // Background Color
                                      ),
                                      onPressed: () {
                                        showAddressDialog(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 28.0, right: 28.0),
                                        child: Row(
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
                          child: deliveryType == "deliver"
                              ? Padding(
                                  padding: const EdgeInsetsDirectional.fromSTEB(
                                      10, 20, 17, 20),
                                  child: TextFormField(
                                    controller: textDeliveryAddress,
                                    readOnly: true,
                                    maxLines: 5,
                                    validator: (value) {
                                      if (deliveryType == "deliver") {
                                        if (value == null || value.isEmpty) {
                                          return deliveryAddressError;
                                        }
                                        return null;
                                      }
                                      return null;
                                    },
                                    autofocus: false,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: currentOrderBG,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      hintText: "Address",
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: currentOrderBG,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      filled: true,
                                      fillColor: currentOrderBG,
                                    ),
                                  ),
                                )
                              : const SizedBox()),
                      const Align(
                        alignment: AlignmentDirectional(-0.9, -0.2),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                          child: Text(
                            'Not sure how to proceed?',
                            style: TextStyle(
                              color: Color(0xFF00D0FF),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(8, 10, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: const [
                            Icon(
                              Icons.radio_button_off,
                              color: Color(0xFF8A8F9C),
                              size: 24,
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                              child: StandardCustomText(
                                label: 'Call us',
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  orderTypeRadio() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(5, 10, 0, 20),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RadioListTile(
                  title: StandardCustomText(
                      label: 'Order all the items from Prescription',
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.safeBlockVertical! * 1.7),
                  value: "all",
                  contentPadding: const EdgeInsets.all(0),
                  groupValue: itemPrescriptionType,
                  onChanged: (value) {
                    setState(() {
                      itemPrescriptionType = value.toString();
                    });
                  },
                ),
                RadioListTile(
                  title: StandardCustomText(
                      label: 'Order specific items from Prescription',
                      fontWeight: FontWeight.bold,
                      fontSize: SizeConfig.safeBlockVertical! * 1.7),
                  contentPadding: const EdgeInsets.all(0),
                  value: "only",
                  groupValue: itemPrescriptionType,
                  onChanged: (value) {
                    setState(() {
                      itemPrescriptionType = value.toString();
                    });
                  },
                ),
                Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                    child: _profileImageFile == null
                        ? Image.asset(
                            prescription1DemoPicImage,
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          )
                        : Image.file(
                            _profileImageFile!,
                            width: 200,
                            height: 200,
                            fit: BoxFit.fill,
                          ),
                    // Image.asset(
                    //   prescription1DemoPicImage,
                    //   width: 200,
                    //   height: 220,
                    //   fit: BoxFit.cover,
                    // ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 20, 0),
                  child: TextFormField(
                    controller: textSpecifyMedicine,
                    maxLines: 5,
                    autofocus: false,
                    validator: (value) {
                      if (itemPrescriptionType == "only") {
                        if (value == null || value.isEmpty) {
                          return "Please enter medicine which need to order";
                        }
                        return null;
                      }
                      return null;
                    },
                    obscureText: false,
                    decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: currentOrderBG,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      hintText:
                          "Which specific item required from prescription?",
                      focusedBorder: UnderlineInputBorder(
                        borderSide: const BorderSide(
                          color: currentOrderBG,
                          width: 1,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: currentOrderBG,
                    ),
                  ),
                ),
                const Align(
                  alignment: AlignmentDirectional(-0.9, -0.2),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                    child: Text(
                      'Not sure how to proceed?',
                      style: TextStyle(
                        color: Color(0xFF00D0FF),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(8, 10, 0, 0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: const [
                      Icon(
                        Icons.radio_button_off,
                        color: Color(0xFF8A8F9C),
                        size: 24,
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(3, 0, 0, 0),
                        child: StandardCustomText(
                          label: 'Call us',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
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
                  InkWell(
                      onTap: () {
                        setState(() {
                          openMedicineTab = true;
                        });
                      },
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 20),
                            child: Container(
                              width: 50,
                              height: 50,
                              clipBehavior: Clip.antiAlias,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: SvgPicture.asset(
                                searchMedicineIcon,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 20, 0),
                            child: StandardCustomText(
                              label: 'Search for \n medicine',
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

  addedPrescriptionView() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 0, 10, 0),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          height: 300,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(7, 15, 7, 10),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Align(
                  alignment: AlignmentDirectional(-0.9, -0.05),
                  child: StandardCustomText(
                    label: 'Added Prescription',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Align(
                  alignment: const AlignmentDirectional(0.7, 0),
                  child: InkWell(
                      onTap: () {
                        setState(() {
                          _profileImageFile = null;
                        });
                      },
                      child: const Icon(
                        Icons.cancel,
                        color: Colors.black,
                        size: 24,
                      )),
                ),
                _profileImageFile == null
                    ? Image.asset(
                        prescription1DemoPicImage,
                        width: 170,
                        height: 220,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _profileImageFile!,
                        width: 170,
                        height: 220,
                        fit: BoxFit.cover,
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  medicineNameList() {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 20),
      child: Material(
        color: Colors.transparent,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          width: double.infinity,
          // height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: BlocProvider(
              create: (context) => addPrescriptionBloc,
              child: BlocConsumer<AddPrescriptionBloc, AddPrescriptionState>(
                listener: (context, state) {
                  // TODO: implement listener

                  // if (state is MedicineDataAdded) {
                  //   debugPrint(
                  //       "vcarez we have is MedicineDataAdded ${state.listOfMedicineColumns}");
                  //   listOfMedicineColumns = state.listOfMedicineColumns;
                  // } else if (state is AddingDataValidCompletedState) {
                  //   // WidgetsBinding.instance.addPostFrameCallback((_) {
                  //   //   Navigator.of(context).maybePop();
                  //   // });
                  //   Navigator.pushNamed(context, routeQuotationHistory);
                  // }
                },
                builder: (context, state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(10, 20, 10, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 0, 0, 0),
                              child: StandardCustomText(
                                label: 'Medicine Name',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                              child: StandardCustomText(
                                label: 'Qty.',
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsetsDirectional.fromSTEB(15, 20, 0, 0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(
                              flex: 4,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 10, 0),
                                child: TypeAheadField(
                                  textFieldConfiguration:
                                      TextFieldConfiguration(
                                    controller: medicineNameSearchController,
                                    autofocus: false,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14),
                                    decoration: InputDecoration(
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: currentOrderBG,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: currentOrderBG,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      filled: true,
                                      fillColor: currentOrderBG,
                                    ),
                                  ),
                                  suggestionsCallback: (pattern) {
                                    if (pattern.length > 2) {
                                      // pattern="dollo";
                                      return fetchPlaceSuggestions(pattern);
                                    } else {
                                      return fetchPlaceSuggestions("a");
                                    }
                                  },
                                  transitionBuilder:
                                      (context, suggestionsBox, controller) {
                                    return suggestionsBox;
                                  },
                                  itemBuilder:
                                      (context, SearchMedicines suggestion) {
                                    return ListTile(
                                        trailing: Text(suggestion.mrp != null
                                            ? suggestion.mrp.toString()
                                            : ""),
                                        title: Text(suggestion.name != null
                                            ? suggestion.name.toString()
                                            : ""));
                                  },
                                  onSuggestionSelected:
                                      (SearchMedicines suggestion) {
                                    // your implementation here
                                    setState(() {
                                      medicineNameSearchController!.text =
                                          suggestion.name!;
                                      textMRPController!.text =
                                          suggestion.mrp!.toString();
                                      // textRateController!.text =
                                      //     suggestion.mrp!.toString();
                                      medicineID = suggestion.id!;
                                      medicineType = suggestion.type;
                                      textQuantityController!.text = "1";
                                    });
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsetsDirectional.fromSTEB(
                                    0, 0, 10, 0),
                                child: TextFormField(
                                  controller: medicineQtyTextController,
                                  autofocus: false,
                                  keyboardType: TextInputType.number,
                                  obscureText: false,
                                  // validator: (value) {
                                  //   if (value == null || value.isEmpty) {
                                  //     return mrpError;
                                  //   }
                                  //   return null;
                                  // },
                                  decoration: InputDecoration(
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: currentOrderBG,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: const BorderSide(
                                        color: currentOrderBG,
                                        width: 1,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    filled: true,
                                    fillColor: currentOrderBG,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.only(top: 25.0),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              primary: darkSkyBluePrimaryColor,
                              backgroundColor:
                                  currentOrderBG, // Background Color
                            ),
                            onPressed: () {
                              // if (_formKey.currentState!.validate())
                              if (medicineNameSearchController!.text == "") {
                                Fluttertoast.showToast(
                                    msg: "Please add medicine name");
                              } else if (medicineQtyTextController!.text ==
                                  "") {
                                Fluttertoast.showToast(
                                    msg: "Please add medicine quantity");
                              } else {
                                final Map<String, String> data =
                                    Map<String, String>();
                                data['medicine_id'] = medicineID.toString();
                                data['medicine_name'] =
                                    medicineNameSearchController!.text.trim();
                                data['qty'] =
                                    medicineQtyTextController!.text.trim();

                                bool int1 = listOfMedicineColumns.any((item) =>
                                    item["medicine_name"] ==
                                    medicineNameSearchController!.text.trim());
                                debugPrint(
                                    "vcarez the element is " + int1.toString());

                                {
                                  if (listOfMedicineColumns.any((item) =>
                                      item["medicine_name"] ==
                                      medicineNameSearchController!.text
                                          .trim())) {
                                    Fluttertoast.showToast(
                                        msg: "Medicine already added");
                                  } else {
                                    listOfMedicineColumns.add(data);
                                    addPrescriptionBloc.add(
                                        MedicineDataAddDeleteEvent(
                                            listOfMedicineColumns));
                                  }
                                }
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(left: 28.0, right: 28.0),
                              child: Text(
                                "ADD+",
                                style: TextStyle(
                                  color: darkSkyBluePrimaryColor,
                                ),
                              ),
                            ),
                          )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: state is MedicineDataAdded
                                ? DataTable(
                                    columns: const [
                                      DataColumn(label: Text('Medicine Name')),
                                      DataColumn(label: Text('Qty')),
                                      DataColumn(label: Text('')),
                                    ],
                                    border: TableBorder.all(
                                        color: greyLightColor,
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10))),
                                    showCheckboxColumn: false,
                                    rows:
                                        listOfMedicineColumns // Loops through dataColumnText, each iteration assigning the value to element
                                            .map(
                                              ((element) => DataRow(
                                                    cells: <DataCell>[
                                                      DataCell(Text(element[
                                                          "medicine_name"]!)),
                                                      DataCell(Text(
                                                          element["qty"]!)),
                                                      DataCell(onTap: () {
                                                        debugPrint(
                                                            'vcarez row-selected: ${element}');
                                                        final Map<String,
                                                                String> data =
                                                            Map<String,
                                                                String>();
                                                        data['medicine_name'] =
                                                            medicineNameSearchController!
                                                                .text;
                                                        data['qty'] =
                                                            medicineQtyTextController!
                                                                .text;
                                                        listOfMedicineColumns
                                                            .remove(element);

                                                        addPrescriptionBloc.add(
                                                            MedicineDataAddDeleteEvent(
                                                                listOfMedicineColumns));
                                                      },
                                                          const Icon(
                                                            Icons
                                                                .delete_forever_outlined,
                                                            color: redColor,
                                                          )),
                                                    ],
                                                  )),
                                            )
                                            .toList(),
                                  )
                                : const SizedBox(),
                          ),
                        ],
                      )
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _updateSelectedProfilePictureFile(File? imageFile) {
    if (mounted && imageFile != null) {
      setState(() {
        _profileImageFile = imageFile;
      });
    }
  }

  // void _cameraPermission() async {
  //   final photosPermissionStatus = await Permission.camera.status;
  //   if (photosPermissionStatus == PermissionStatus.permanentlyDenied ||
  //       photosPermissionStatus == PermissionStatus.denied) {
  //     String? permissionContent = "Please allow camera permission";
  //     _handleInvalidPermissions(
  //         photosPermissionStatus, context, permissionContent);
  //   }
  // }

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

  void showPreviewBidCustomDialog(BuildContext context) {
    debugPrint("vcarez the dialog inside clicked " + context.toString());
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
                height: SizeConfig.blockSizeVertical! * 75,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      // productList(),
                      // subTotalWidget(),
                      // sendQuotationWidget()
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
                                // Navigator.pop(context);
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

  Widget addressList() {
    // var demoList = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
    // if (addPrescriptionBloc.isClosed) {
    //
    //  if( addPrescriptionBloc.state is OnAddressLoaded)
    //   addPrescriptionBloc.add(GetAddressListEvent());
    // }
    return BlocProvider(
      create: (context) => AddPrescriptionBloc()..add(GetAddressListEvent()),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * .55,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(bottom: 40.0),
          child: BlocConsumer<AddPrescriptionBloc, AddPrescriptionState>(
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
                                        textDeliveryAddress!.text =
                                            addressListModel
                                                .addresses![index].address!;

                                        latitude = addressListModel
                                            .addresses![index].lattitude;

                                        longitude = addressListModel
                                            .addresses![index].longitude;

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

  Future<List<SearchMedicines>> fetchPlaceSuggestions(String pattern) async {
    debugPrint("vcarez the query is " + pattern);
    searchResultModel =
        await ApiController().getSearchMedicineList(token, pattern);
    return Future.value(searchResultModel.medicines ?? []);
  }
}
