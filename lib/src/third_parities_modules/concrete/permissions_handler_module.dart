import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as lc;
import 'package:permission_handler/permission_handler.dart' as ph;
import 'package:google_maps_place_picker/src/third_parities_modules/abstract/i_permissions_handler_module.dart';

class PermissionsHandlerModule extends IPermissionsHandlerModule {
  @override
  Future<bool> hasGrantLocationPermission(
      {required final bool gracefully}) async {
    final lc.Location location = lc.Location();

    bool isLocationServiceEnabled = await location.serviceEnabled();
    if (!isLocationServiceEnabled && !gracefully) {
      isLocationServiceEnabled = await location.requestService();
      if (!isLocationServiceEnabled) {
        return false;
      }
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && !gracefully) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  @override
  Future<void> openAppSettings() => ph.openAppSettings();
}
