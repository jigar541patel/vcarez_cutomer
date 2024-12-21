import 'dart:async';

import 'package:flutter/cupertino.dart';

const _defaultEnabledCountries = <String>["AU", "CA", "PH", "GB", "US","IN"];

class ConfigurationService {

  static String _configPrefix = "app/config/";

  bool initialized = false;

  double searchNearbyRadiusInMeters = 100;
  bool searchNearbyShowOwned = false;
  int searchNearbyAutoUpdateIntervalInSeconds = 55;
  int searchAutoConnectAutoApproveInSeconds = 3;
  int searchAutoConnectShakeRangeInSeconds = 12;
  int blockLoginResumeAfterLoginCount = 3; // This is something that is difficult to configure so we'll hardcode this to 2
  int resendAuthEmailConfirmationIntervalInMinutes = 5;
  bool enableProfileCreate = true;
  List<String> enabledCountries = _defaultEnabledCountries;
  double maxPictureWidth = 2048;
  double maxPictureHeight = 2048;
  int maxProfiles = 1;
  int chatMessagePerPage = 30;
  int appInfoLimit = 2;

  ensureInitialized() async {
    if (initialized) {
      return;
    }


    initialized = true;
    debugPrint(this.toString());
  }

  @override
  String toString() {
    return 'ConfigurationService{initialized: $initialized, searchNearbyRadiusInMeters: $searchNearbyRadiusInMeters, searchNearbyShowOwned: $searchNearbyShowOwned, searchNearbyAutoUpdateIntervalInSeconds: $searchNearbyAutoUpdateIntervalInSeconds, searchAutoConnectAutoApproveInSeconds: $searchAutoConnectAutoApproveInSeconds, searchAutoConnectShakeRangeInSeconds: $searchAutoConnectShakeRangeInSeconds, blockLoginResumeAfterLoginCount: $blockLoginResumeAfterLoginCount, resendAuthEmailConfirmationIntervalInMinutes: $resendAuthEmailConfirmationIntervalInMinutes, enableProfileCreate: $enableProfileCreate, enabledCountries: $enabledCountries, maxPictureWidth: $maxPictureWidth, maxPictureHeight: $maxPictureHeight, maxProfiles: $maxProfiles, chatMessagePerPage: $chatMessagePerPage, appInfoLimit: $appInfoLimit}';
  }

  // static Future<DatabaseEvent> _configValue(String key) {
  //   if (_referenceCache == null) {
  //     _referenceCache = databaseService!.referenceRealTime(_configPrefix);
  //   }
  //   return _referenceCache!.child(key).once();
  // }



}
