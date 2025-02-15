import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ultra_map_place_picker/ultra_map_place_picker.dart';

class UltraMapThumbnail extends StatelessWidget {
  const UltraMapThumbnail(
      {required this.initialPosition,
      required this.googleApiKey,
      required this.mapTypes,
      required this.height,
      required this.width,
      this.borderRadius = BorderRadius.zero,
      super.key,
      this.onLocationPermissionDenied,
      this.desiredLocationAccuracy = LocationAccuracy.high,
      this.onMapCreated,
      this.proxyBaseUrl,
      this.httpClient,
      this.pinBuilder,
      this.initialMapType = UltraMapType.normal,
      this.enableMapTypeButton = true,
      this.enableMyLocationButton = true,
      this.usePinPointingSearch = true,
      this.usePlaceDetailSearch = false,
      this.enableScrolling = true,
      this.strictBounds,
      this.region,
      this.pickArea,
      this.ignoreLocationPermissionErrors = false,
      this.onMapTypeChanged,
      this.zoomGesturesEnabled = true,
      this.zoomControlsEnabled = false,
      this.initialZoomValue = 15,
      this.polygons = const {},
      this.polylines = const {},
      this.onPressed});

  /// The Google Maps API key for Places API and Geocoding API usage.
  final String googleApiKey;

  /// The initial location to center the map on.
  final UltraLocationModel initialPosition;

  /// The desired accuracy for the user's location.
  final LocationAccuracy desiredLocationAccuracy;
  final void Function()? onLocationPermissionDenied;

  final UltraMapType initialMapType;
  final bool enableMapTypeButton;
  final bool enableMyLocationButton;
  final bool enableScrolling;
  final bool zoomControlsEnabled;
  final bool zoomGesturesEnabled;
  final bool usePinPointingSearch;
  final bool usePlaceDetailSearch;

  final bool? strictBounds;
  final String? region;

  final double initialZoomValue;
  final List<UltraMapType> Function(bool isHuaweiDevice) mapTypes;

  /// If set the picker can only pick addresses in the given circle area.
  /// The section will be highlighted.
  final UltraCircleModel? pickArea;

  /// optional - builds customized pin widget which indicates current pointing position.
  ///
  /// It is provided by default if you leave it as a null.
  final PinBuilder? pinBuilder;

  /// optional - sets 'proxy' value in google_maps_webservice
  ///
  /// In case of using a proxy the baseUrl can be set.
  /// The googleApiKey is not required in case the proxy sets it.
  /// (Not storing the googleApiKey in the app is good practice)
  final String? proxyBaseUrl;

  /// optional - set 'client' value in google_maps_webservice
  ///
  /// In case of using a proxy url that requires authentication
  /// or custom configuration
  final BaseClient? httpClient;

  /// Whether to ignore location permission errors. Defaults to false.
  /// If this is set to `true` the UI will be blocked.
  final bool ignoreLocationPermissionErrors;

  /// GoogleMap pass-through events:

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [GoogleMapController] for this [GoogleMap].
  final void Function(UltraMapController)? onMapCreated;

  /// Called when the map type has been changed.
  final Function(UltraMapType)? onMapTypeChanged;

  final Set<UltraPolygonModel> polygons;
  final Set<UltraPolylineModel> polylines;

  final double height;
  final double width;
  final BorderRadius borderRadius;

  final void Function()? onPressed;

  @override
  Widget build(final BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: SizedBox(
        height: height,
        width: width,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: UltraMapPlacePicker(
            showPickedPlace: false,
            enableSearching: false,
            enableScrolling: false,
            enableMapTypeButton: enableMapTypeButton,
            enableMyLocationButton: enableMyLocationButton,
            zoomGesturesEnabled: zoomGesturesEnabled,
            initialZoomValue: initialZoomValue,
            googleApiKey: googleApiKey,
            initialPosition: initialPosition,
            mapTypes: mapTypes,
            myLocationButtonCooldown: 1,
            zoomControlsEnabled: zoomControlsEnabled,
            httpClient: httpClient,
            proxyBaseUrl: proxyBaseUrl,
            onLocationPermissionDenied: onLocationPermissionDenied,
            pickArea: pickArea,
            pinBuilder: pinBuilder,
            polygons: polygons,
            polylines: polylines,
          ),
        ),
        //  resizeToAvoidBottomInset: true, // only works in page mode, less flickery, remove if wrong offsets
      ),
    );
  }
}
