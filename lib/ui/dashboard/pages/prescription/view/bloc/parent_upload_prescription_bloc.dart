import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:meta/meta.dart';
import 'package:vcarez_new/ui/storage/shared_pref_const.dart';
import 'package:vcarez_new/utils/CommonUtils.dart';

part 'parent_upload_prescription_event.dart';

part 'parent_upload_prescription_state.dart';

class ParentUploadPrescriptionBloc
    extends Bloc<ParentUploadPrescriptionEvent, ParentUploadPrescriptionState> {
  ParentUploadPrescriptionBloc() : super(ParentUploadPrescriptionInitial()) {
    // on<ParentUploadPrescriptionEvent>((event, emit) {
    //   // TODO: implement event handler
    // });
    on<GetPrescriptionLocationName>((event, emit) async {
      // emit(DataLoading());
      Position position = await _determinePosition();
      debugPrint("vcarez customer location we have is ${position.latitude}");
      debugPrint("vcarez customer location we have is ${position.latitude}");

      var storage = const FlutterSecureStorage();

      await storage.write(key: keyUserLat, value: position.latitude.toString());
      await storage.write(
          key: keyUserLong, value: position.longitude.toString());

      List<Placemark> placemarks =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      debugPrint(
          "vcarez customer location we have is ${placemarks[0].locality!}");
      emit(OnLocationLoadedState(placemarks[0].locality!));
    });

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
