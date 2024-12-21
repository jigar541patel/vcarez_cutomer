import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:vcarez_new/ui/myaddress/bloc/my_address_bloc.dart';
import 'package:vcarez_new/ui/myaddress/model/city_list_model.dart';
import 'package:vcarez_new/ui/myaddress/model/edit_address_request_model.dart';
import 'package:vcarez_new/ui/myaddress/model/state_list_model.dart';
import 'package:vcarez_new/ui/myaddress/view/my_address_screen.dart';
import 'package:vcarez_new/ui/signup/bloc/signup_bloc.dart';
import 'package:vcarez_new/utils/SizeConfig.dart';
import 'package:vcarez_new/utils/colors_utils.dart';
import 'package:vcarez_new/utils/route_names.dart';

import '../../../components/color_loader.dart';
import '../../../components/custom_snack_bar.dart';
import '../../../components/my_form_field.dart';
import '../../../components/standard_regular_text.dart';
import '../../../components/my_theme_button.dart';
import '../../../utils/decoration_utils.dart';
import '../../../utils/images_utils.dart';
import '../../../utils/strings.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({Key? key}) : super(key: key);

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController userAddressController,
      cityTextController,
      stateTextController,
      _locationController,
      pinCodeTextController;
  int selectedStateID = 0;
  int selectedCityID = 0;
  EditAddressRequestModel editAddressRequestModel = EditAddressRequestModel();
  StateListModel stateListModel = StateListModel();
  CityListModel cityListModel = CityListModel();

  // String dropdownStateValue = "Andaman and Nicobar Islands";
  // String dropdownStateValue = "Andaman and Nicobar Islands";
  String dropdownStateValue = "Select State";
  String dropdownCityValue = "Select City";

  // String? strLat,strLong;
  MyAddressBloc myAddressBloc = MyAddressBloc();
  bool isLoadingFirst = true;
  bool isStateChange = false;
  String strLatitude = "", strLongitude = "";

  String strAddressId = "";

  Widget imageAppLogo() => SvgPicture.asset(
        appLogo_,
        height: 18.0,
        width: 116.0,
      );

  void initController() {
    // signupBloc = BlocProvider.of<SignupBloc>(context);
    userAddressController = TextEditingController();
    pinCodeTextController = TextEditingController();
    cityTextController = TextEditingController();
    stateTextController = TextEditingController();
    stateTextController = TextEditingController();
    _locationController = TextEditingController();
    // Data data=Data();
    // data.id=0;
    // data.name=dropdownStateValue;
    // stateListModel.data!.add(data);
    // CityData cityData=CityData();
    // cityData.id=0;
    // cityData.name=dropdownCityValue;
    // cityListModel.data!.add(cityData);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // if (ModalRoute.of(context)!.settings.arguments != null) {
      // String strMedicineID =
      //     ModalRoute.of(context)!.settings.arguments as String;
      // debugPrint("vcarez vendor strMedicineID $strMedicineID");
      myAddressBloc.add(GetStateListEvent());
      // }
    });
    // userAddressController.text = "dmart city near sachin";
    // pinCodeTextController.text = "387905";
    // cityTextController.text = "1";
    // stateTextController.text = "1";
    // _locationController.text = "surat location sachin";
    // strLatitude = "78.25";
    // strLongitude = "21.25";
  }

  void disposeController() {
    userAddressController.dispose();
    pinCodeTextController.dispose();
    cityTextController.dispose();
    stateTextController.dispose();
    _locationController.dispose();
  }

  @override
  void initState() {
    super.initState();
    initController();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    if (isLoadingFirst) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        final arg = ModalRoute.of(context)!.settings.arguments as Map;
        // String strTitle = arg['title'];
        editAddressRequestModel = arg['model'] as EditAddressRequestModel;

        if (editAddressRequestModel.strAddressID != null) {
          strAddressId = editAddressRequestModel.strAddressID!;
        }
        if (editAddressRequestModel.strAddress != null) {
          userAddressController.text = editAddressRequestModel.strAddress!;
        }
        if (editAddressRequestModel.strState != null) {
          // stateTextController.text = editAddressRequestModel.strState!;
          selectedStateID = int.parse(editAddressRequestModel.strState!);
        }
        if (editAddressRequestModel.strPincode != null) {
          pinCodeTextController.text = editAddressRequestModel.strPincode!;
        }
        if (editAddressRequestModel.strCity != null) {
          // cityTextController.text = editAddressRequestModel.strCity!;
          selectedCityID = int.parse(editAddressRequestModel.strCity!);
        }
        if (editAddressRequestModel.strLatitude != null) {
          strLatitude = editAddressRequestModel.strLatitude!;
        }
        if (editAddressRequestModel.strLongitude != null) {
          strLongitude = editAddressRequestModel.strLongitude!;
        }
        if (editAddressRequestModel.strLocation != null) {
          _locationController.text = editAddressRequestModel.strLocation!;
        }
      }
      isLoadingFirst = false;
    }
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   disposeController();
  // }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    Widget imageAppLogo() => SvgPicture.asset(
          appLogo_,
          height: 40,
          width: 180,
        );

    return Scaffold(
      body: BlocProvider(
        create: (context) => myAddressBloc,
        child: SafeArea(
            child: Stack(
          children: [
            topHeader(),
            Container(
              width: double.infinity,
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * .16,
              ),
              height: MediaQuery.of(context).size.height * .80,
              decoration: const BoxDecoration(
                color: whiteColor,
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15.0),
                    bottomRight: Radius.circular(0.0),
                    topLeft: Radius.circular(15.0),
                    bottomLeft: Radius.circular(0.0)),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 20.0),
                          child: BlocBuilder<MyAddressBloc, MyAddressState>(
                            builder: (context, state) {
                              return TextFormField(
                                  maxLines: 5,
                                  maxLength: 100,
                                  //or null
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return addressError;
                                    }
                                    return null;
                                  },
                                  controller: userAddressController,
                                  textAlign: TextAlign.start,
                                  cursorColor: primaryTextColor,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.all(15),
                                    fillColor: primaryColor,
                                    filled: true,
                                    hintText: lblAddress,
                                    errorMaxLines: 3,
                                    labelStyle: TextStyle(color: hintTextColor),
                                    hintStyle: TextStyle(color: hintTextColor),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24.0)),
                                      borderSide: BorderSide(
                                          color: textFieldColor, width: 0.0),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24.0)),
                                      borderSide: BorderSide(
                                          color: textFieldColor, width: 0.0),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24.0)),
                                      borderSide: BorderSide(
                                          color: textFieldColor, width: 0.0),
                                    ),
                                    errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24.0)),
                                      borderSide: BorderSide(
                                          color: errorColor, width: 0.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24.0)),
                                      borderSide: BorderSide(
                                          color: errorColor, width: 0.0),
                                    ),
                                  ),

                                  // hin
                                  // decoration: DecorationUtils(context)
                                  //     .getUnderlineInputDecoration(
                                  //   labelText: lblAddress,
                                  //   isEnable: true,
                                  // ),
                                  style: const TextStyle(
                                      fontSize: 14.0, color: primaryTextColor)
                                  //: Theme.of(context).textTheme.bodyText1!.color),
                                  // validator: validator,
                                  // onChanged: onChanged,
                                  // onTap: onTap,
                                  // onFieldSubmitted: onSubmited,
                                  );
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Select State",
                            style: TextStyle(
                                color: primaryTextColor, fontSize: 14)),
                        const SizedBox(
                          height: 5,
                        ),
                        BlocConsumer<MyAddressBloc, MyAddressState>(
                          listener: (context, state) {
                            // TODO: implement listener
                            if (state is OnStateListLoaded) {
                              stateListModel = state.stateListModel;
                              if (strAddressId != "") {
                                isStateChange = false;
                                stateListModel.data!.map((element) {
                                  // get index
                                  var index =
                                      stateListModel.data!.indexOf(element);
                                  if (element.id == selectedStateID) {
                                    selectedStateID = element.id!;
                                    dropdownStateValue =
                                        stateListModel.data![index].name!;
                                    myAddressBloc.add(GetCityListEvent(
                                        selectedStateID.toString()));
                                  }
                                }).toList();
                              } else {
                                dropdownStateValue =
                                    stateListModel.data![0].name!;
                              }
                            }
                          },
                          builder: (context, state) {
                            return Container(
                                height: 43,
                                width: MediaQuery.of(context).size.width - 20,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: descriptionTextColor,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: stateListModel.data != null &&
                                        stateListModel.data!.isNotEmpty
                                    ? DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                        // Initial Value
                                        value: dropdownStateValue,
                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.arrow_drop_down_sharp),
                                        // Array list of items
                                        items: stateListModel.data!
                                            .map((Data items) {
                                          return DropdownMenuItem(
                                            value: items.name.toString(),
                                            child: SizedBox(
                                              // width: 130,
                                              child: StandardCustomText(
                                                maxlines: 1,
                                                label: items.name!,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownStateValue = newValue!;
                                            stateListModel.data!.map((element) {
                                              // get index
                                              if (element.name ==
                                                  dropdownStateValue) {
                                                selectedStateID = element.id!;

                                                isStateChange = true;
                                                if (cityListModel.data !=
                                                    null) {
                                                  selectedCityID = cityListModel
                                                      .data![0].id!;
                                                  dropdownCityValue =
                                                      cityListModel
                                                          .data![0].name!;
                                                }

                                                // if (strAddressId != "") {
                                                //   isStateChange = false;
                                                // }
                                                myAddressBloc.add(
                                                    GetCityListEvent(
                                                        selectedStateID
                                                            .toString()));
                                              }
                                            }).toList();
                                          });
                                        },
                                      ))
                                    : const SizedBox());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text("Select City",
                            style: TextStyle(
                                color: primaryTextColor, fontSize: 14)),
                        const SizedBox(
                          height: 5,
                        ),
                        BlocConsumer<MyAddressBloc, MyAddressState>(
                          listener: (context, state) {
                            // TODO: implement listener
                            if (state is OnCityListLoaded) {
                              debugPrint("vcarez the isStateChange is " +
                                  isStateChange.toString());
                              cityListModel = state.cityListModel;
                              if (strAddressId != "") {
                                if (isStateChange == true) {
                                  dropdownCityValue =
                                      cityListModel.data![0].name!;
                                  selectedCityID = cityListModel.data![0].id!;
                                } else {
                                  debugPrint("vcarez the inside 400 is " +
                                      isStateChange.toString());
                                  cityListModel.data!.map((element) {
                                    // get index
                                    var index =
                                        cityListModel.data!.indexOf(element);
                                    if (element.id == selectedCityID) {
                                      selectedCityID = element.id!;
                                      dropdownCityValue =
                                          cityListModel.data![index].name!;
                                    }
                                  }).toList();
                                }
                              } else {
                                debugPrint("vcarez the 142 is done");

                                dropdownCityValue =
                                    cityListModel.data![0].name!;
                              }
                            }
                          },
                          builder: (context, state) {
                            return Container(
                                height: 43,
                                width: MediaQuery.of(context).size.width - 20,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: descriptionTextColor,
                                      style: BorderStyle.solid,
                                      width: 0.80),
                                ),
                                child: cityListModel.data != null &&
                                        cityListModel.data!.isNotEmpty
                                    ? DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                        // Initial Value
                                        value: dropdownCityValue,
                                        // Down Arrow Icon
                                        icon: const Icon(
                                            Icons.arrow_drop_down_sharp),
                                        // Array list of items
                                        items: cityListModel.data!
                                            .map((CityData items) {
                                          return DropdownMenuItem(
                                            value: items.name,
                                            child: SizedBox(
                                              // width: 130,
                                              child: StandardCustomText(
                                                maxlines: 1,
                                                label: items.name!,
                                                fontSize: 12,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                        // After selecting the desired option,it will
                                        // change button value to selected value
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            dropdownCityValue = newValue!;

                                            cityListModel.data!.map((element) {
                                              // get index
                                              if (element.name ==
                                                  dropdownCityValue) {
                                                selectedCityID = element.id!;
                                              }
                                            }).toList();
                                          });
                                        },
                                      ))
                                    : const SizedBox());
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        placesAutoCompleteTextField(),

                        // TextField(
                        //   controller: _locationController,
                        //   readOnly: true,
                        //   onTap: () async {
                        //     // generate a new token here
                        //     final sessionToken = Uuid().v4();
                        //     final Suggestion result = await showSearch(
                        //       context: context,
                        //       delegate: AddressSearch(sessionToken),
                        //     );
                        //     // This will change the text displayed in the TextField
                        //     if (result != null) {
                        //       final placeDetails = await PlaceApiProvider(sessionToken)
                        //           .getPlaceDetailFromId(result.placeId);
                        //       setState(() {
                        //         _locationController.text = result.description;
                        //         // _streetNumber = placeDetails.streetNumber;
                        //         // _street = placeDetails.street;
                        //         // _city = placeDetails.city;
                        //         // _zipCode = placeDetails.zipCode;
                        //       });
                        //     }
                        //   },
                        //   decoration: InputDecoration(
                        //     icon: Container(
                        //       width: 10,
                        //       height: 10,
                        //       child: Icon(
                        //         Icons.home,
                        //         color: Colors.black,
                        //       ),
                        //     ),
                        //     hintText: "Enter your shipping address",
                        //     border: InputBorder.none,
                        //     contentPadding: EdgeInsets.only(left: 8.0, top: 16.0),
                        //   ),
                        // ),
                        // InkWell(
                        //     onTap: () async {
                        //       // final places = FlutterGooglePlacesSdk('AIzaSyC93iWEyFWSUjSDXe5iSMkIWOZPIHLmfFc');
                        //       final places =
                        //           FlutterGooglePlacesSdk(googleApiKey);
                        //       final predictions = await places
                        //           .findAutocompletePredictions('adajan');
                        //       print('Result: $predictions');
                        //     },
                        //     child: Container(
                        //       margin: const EdgeInsets.only(top: 24.0),
                        //       child: BlocBuilder<MyAddressBloc, MyAddressState>(
                        //         builder: (context, state) {
                        //           return CustomFormField(
                        //             controller: _locationController,
                        //             labelText: location,
                        //             // validator: (value) {
                        //             //   if (value == null || value.isEmpty) {
                        //             //     return locationError;
                        //             //   }
                        //             //   return null;
                        //             // },
                        //             isEnable: false,
                        //             // isEnable: state is AddingDataInProgressState
                        //             //     ? false
                        //             //     : true,
                        //             icon: locationIcon,
                        //             isRequire: true,
                        //             textInputAction: TextInputAction.next,
                        //             textInputType: TextInputType.text,
                        //           );
                        //         },
                        //       ),
                        //     )),
                        Container(
                          margin: const EdgeInsets.only(top: 24.0),
                          child: BlocBuilder<MyAddressBloc, MyAddressState>(
                            builder: (context, state) {
                              return CustomFormField(
                                controller: pinCodeTextController,
                                labelText: lblPincode,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return pincodeError;
                                  }
                                  return null;
                                },
                                maxLength: 6,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp("[0-9]"))
                                ],
                                isEnable: state is AddingDataInProgressState
                                    ? false
                                    : true,
                                icon: locationIcon,
                                isRequire: true,
                                textInputAction: TextInputAction.next,
                                textInputType: TextInputType.number,
                              );
                            },
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 24.0),
                          child: BlocBuilder<MyAddressBloc, MyAddressState>(
                            builder: (context, state) {
                              if (state is AddingAddressValidCompletedState) {
                                WidgetsBinding.instance
                                    .addPostFrameCallback((_) {
                                  clearAll();
                                  // Navigator.pushReplacementNamed(
                                  //     context, routeMyAddressList);
                                });
                              }
                              return MaterialButton(
                                  onPressed: () async {
                                    FocusScope.of(context)
                                        .requestFocus(FocusNode());

                                    if (_formKey.currentState!.validate()) {
                                      var connectivityResult =
                                          await (Connectivity()
                                              .checkConnectivity());
                                      if (connectivityResult ==
                                              ConnectivityResult.mobile ||
                                          connectivityResult ==
                                              ConnectivityResult.wifi) {
                                        if (strAddressId == "") {
                                          onAddressButtonClicked();
                                        } else {
                                          onUpdateAddressButtonClicked();
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(createMessageSnackBar(
                                                errorNoInternet));
                                      }
                                    }
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15)),
                                  padding: const EdgeInsets.fromLTRB(
                                      0.0, 15.0, 0.0, 15.0),
                                  color: darkSkyBluePrimaryColor,
                                  splashColor: Theme.of(context).primaryColor,
                                  disabledColor:
                                      Theme.of(context).disabledColor,
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: SizeConfig.blockSizeVertical! * 2.7,
                                    child: Center(
                                      child: (state
                                              is AddingAddressInProgressState)
                                          ? SizedBox(
                                              width: SizeConfig
                                                      .blockSizeHorizontal! *
                                                  5.5,
                                              child: const CircularProgressIndicator(
                                                  //color: darkSkyBluePrimaryColor,
                                                  ),
                                            )
                                          : const Text(
                                              "Save",
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
                        const SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        )),
      ),
    );
  }

  void clearAll() {
    userAddressController.text = "";
    strLongitude = "";
    strLatitude = "";
    cityTextController.text = "";
    stateTextController.text = "";
    pinCodeTextController.text = "";
    _locationController.text = "";
  }

  // _onChanged() {
  //   if (_sessionToken == null) {
  //     setState(() {
  //       _sessionToken = uuid.v4();
  //     });
  //   }
  //   getSuggestion(_controller.text);
  // }

  placesAutoCompleteTextField() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width - 20,
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(
            color: descriptionTextColor, style: BorderStyle.solid, width: 0.80),
      ),
      // padding: EdgeInsets.symmetric(horizontal: 20),
      child: GooglePlaceAutoCompleteTextField(
          textEditingController: _locationController,
          googleAPIKey: googleApiKey,
          inputDecoration: const InputDecoration(
              hintText: "Search your location", border: InputBorder.none),
          // inputDecoration: DecorationUtils(context).getUnderlineInputDecoration(
          //     labelText: location,
          //     // isRequire: isRequire,
          //     // isEnable: isEnable,
          //     // icon: icon,
          //     // suffixIcon: suffixIconWidget,
          //     // isSuffixIconDisplay: isSuffixIconDisplay,
          //     // isIconDisplay: isIconDisplay
          // ),
          debounceTime: 800,
          countries: const ["in"],
          isLatLngRequired: true,
          getPlaceDetailWithLatLng: (Prediction prediction) {
            print("jigar the placeDetails" + prediction.lng.toString());
            strLatitude = prediction.lat.toString();
            strLongitude = prediction.lng.toString();
          },
          itmClick: (Prediction prediction) {
            _locationController.text = prediction.description!;
            _locationController.selection = TextSelection.fromPosition(
                TextPosition(offset: prediction.description!.length));
          }
          // default 600 ms ,
          ),
    );
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
              label: "Save Address",
              fontWeight: FontWeight.bold,
              color: whiteColor,
              fontSize: 22.0,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> onAddressButtonClicked() async {
    // latitude=21.2308042&longitude=72.7795458

    // Position position = await _determinePosition();
    // debugPrint("vcarez customer location we have is ${position.latitude}");
    // debugPrint("vcarez customer location we have is ${position.latitude}");

    // this.strAddress, this.strCity, this.strState, this.strLocation,this.strLatitude,this.strLongitude);
    if (strLatitude != "" && strLongitude != "") {
      myAddressBloc.add(SaveAddressSubmittedEvent(
          userAddressController.text,
          selectedCityID.toString(),
          selectedStateID.toString(),
          _locationController.text,
          // position.latitude.toString(),
          strLatitude,
          // position.longitude.toString(),
          strLongitude,
          pinCodeTextController.text));
    } else {
      Fluttertoast.showToast(msg: "Please enter location");
    }
  }

  Future<void> onUpdateAddressButtonClicked() async {
    // latitude=21.2308042&longitude=72.7795458
    // this.strAddress, this.strCity, this.strState, this.strLocation,this.strLatitude,this.strLongitude);

    Position position = await _determinePosition();
    debugPrint("vcarez customer location we have is ${position.latitude}");
    debugPrint("vcarez customer location we have is ${position.latitude}");

    if (strLatitude != "" && strLongitude != "") {
      myAddressBloc.add(UpdateAddressSubmittedEvent(
          strAddressId,
          userAddressController.text,
          selectedCityID.toString(),
          selectedStateID.toString(),
          _locationController.text,
          // position.latitude.toString(),
          // position.longitude.toString(),
          // "22.11",

          strLatitude,
          strLongitude,
          pinCodeTextController.text));
    } else {
      Fluttertoast.showToast(msg: "Please enter location");
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
}
