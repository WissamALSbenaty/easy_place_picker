import 'dart:io';

import 'package:geolocator/geolocator.dart';
import 'package:easy_place_picker/src/third_parities_modules/abstract/i_permissions_handler_module.dart';

import 'package:easy_place_picker/src/third_parities_modules/abstract/i_live_location_module.dart';
import 'package:easy_place_picker/src/third_parities_modules/concrete/permissions_handler_module.dart';

class LiveLocationModule extends ILiveLocationModule {
  final IPermissionsHandlerModule permissionsHandlerModule =
      PermissionsHandlerModule();

  LiveLocationModule();
  @override
  Future<Position?> getCurrentLocation(
      {required final bool gracefully,
      required LocationAccuracy? desiredAccuracy}) async {
    try {
      if (!await permissionsHandlerModule.hasGrantLocationPermission(
          gracefully: gracefully)) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: Platform.isIOS
            ? AppleSettings(accuracy: desiredAccuracy ?? LocationAccuracy.best)
            : AndroidSettings(
                accuracy: desiredAccuracy ?? LocationAccuracy.best),
      );
    } catch (e) {
      return null;
    }
  }
}
