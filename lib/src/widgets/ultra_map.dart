import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:huawei_map/huawei_map.dart' as hm;
import 'package:ultra_map_place_picker/src/models/ultra_location_model.dart';
import 'package:ultra_map_place_picker/src/controllers/ultra_map_controller.dart';
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/models/ultra_circle_model.dart';
import 'package:ultra_map_place_picker/src/models/pick_result_model.dart';
import 'package:ultra_map_place_picker/src/models/ultra_marker_model.dart';
import 'package:ultra_map_place_picker/src/models/ultra_polygon_model.dart';
import 'package:ultra_map_place_picker/src/models/ultra_polyline_model.dart';
import 'package:ultra_map_place_picker/src/providers/place_provider.dart';

class UltraMap extends StatelessWidget {
  final PlaceProvider provider;
  final UltraLocationModel initialTarget;
  final UltraMapType mapType;
  final void Function(PlaceProvider) searchByCameraLocation;
  final VoidCallback? onMoveStart;
  final void Function(UltraMapController)? onMapCreated;
  final ValueChanged<PickResultModel>? onPlacePicked;

  final int? debounceMilliseconds;

  final bool? usePinPointingSearch;

  final bool? selectInitialPosition;

  final String? language;
  final UltraCircleModel? pickArea;

  final bool? hidePlaceDetailsWhenDraggingPin;

  /// GoogleMap pass-through events:
  final Function(PlaceProvider)? onCameraMoveStarted;
  final void Function(UltraLocationModel)? onCameraMove;
  final Function(PlaceProvider)? onCameraIdle;

  // strings
  final String? selectText;

  /// Zoom feature toggle
  final bool zoomGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool isHuaweiDevice;
  final bool enableScrolling;
  final double initialZoomValue;

  /// Use never scrollable scroll-view with maximum dimensions to prevent unnecessary re-rendering.

  final Set<UltraPolygonModel> polygons;
  final Set<UltraPolylineModel> polylines;
  final Set<UltraMarkerModel> markers;

  const UltraMap({
    super.key,
    required this.provider,
    required this.isHuaweiDevice,
    required this.initialTarget,
    required this.mapType,
    required this.searchByCameraLocation,
    required this.onMoveStart,
    required this.onMapCreated,
    required this.onPlacePicked,
    required this.debounceMilliseconds,
    required this.usePinPointingSearch,
    required this.selectInitialPosition,
    required this.language,
    required this.pickArea,
    required this.hidePlaceDetailsWhenDraggingPin,
    required this.onCameraMoveStarted,
    required this.onCameraMove,
    required this.onCameraIdle,
    required this.selectText,
    required this.zoomGesturesEnabled,
    required this.zoomControlsEnabled,
    required this.initialZoomValue,
    required this.polygons,
    required this.polylines,
    required this.markers,
    this.enableScrolling = true,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enableScrolling,
      child: isHuaweiDevice
          ? hm.HuaweiMap(
              polygons: polygons.map((p) => p.toHuaweiPolygon).toSet(),
              polylines: polylines.map((p) => p.toHuaweiPolyline).toSet(),
              zoomGesturesEnabled: zoomGesturesEnabled,
              zoomControlsEnabled: false,
              // we use our own implementation that supports iOS as well, see _buildZoomButtons()
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: hm.CameraPosition(
                  target: initialTarget.huaweiLatLng, zoom: initialZoomValue),
              mapType: mapType.huaweiMapType,
              myLocationEnabled: true,
              circles: pickArea != null && pickArea!.toHuaweiCircle.radius > 0
                  ? {pickArea!.toHuaweiCircle}
                  : {},
              onMapCreated: (final hm.HuaweiMapController controller) {
                provider.mapController.completeHuaweiController(controller);
                provider.setCameraPosition(null);
                provider.pinState = PinState.idle;

                // When select initialPosition set to true.
                if (selectInitialPosition!) {
                  provider.setCameraPosition(initialTarget);
                  searchByCameraLocation(provider);
                }
                onMapCreated?.call(provider.mapController);
              },
              onCameraIdle: () {
                if (provider.isAutoCompleteSearching) {
                  provider.isAutoCompleteSearching = false;
                  provider.pinState = PinState.idle;
                  provider.placeSearchingState = SearchingState.idle;
                  return;
                }
                // Perform search only if the setting is to true.
                if (usePinPointingSearch!) {
                  // Search current camera location only if camera has moved (dragged) before.
                  if (provider.pinState == PinState.dragging) {
                    // Cancel previous timer.
                    if (provider.debounceTimer?.isActive ?? false) {
                      provider.debounceTimer!.cancel();
                    }
                    provider.debounceTimer = Timer(
                        Duration(milliseconds: debounceMilliseconds!), () {
                      searchByCameraLocation(provider);
                    });
                  }
                }
                provider.pinState = PinState.idle;
                onCameraIdle?.call(provider);
              },
              onCameraMoveStarted: (_) {
                onCameraMoveStarted?.call(provider);
                provider.setPrevCameraPosition(provider.cameraPosition);
                // Cancel any other timer.
                provider.debounceTimer?.cancel();
                // Update state, dismiss keyboard and clear text.
                provider.pinState = PinState.dragging;
                // Begins the search state if the hide details is enabled
                if (hidePlaceDetailsWhenDraggingPin!) {
                  provider.placeSearchingState = SearchingState.searching;
                }
                onMoveStart!();
              },
              onCameraMove: (final hm.CameraPosition position) {
                provider.setCameraPosition(
                    UltraLocationModel.fromHuaweiLatLng(position.target));
                onCameraMove?.call(
                    UltraLocationModel.fromHuaweiLatLng(position.target));
              },
              // gestureRecognizers make it possible to navigate the map when it's a
              // child in a scroll view e.g ListView, SingleChildScrollView...
              gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),

              markers: markers.map((marker) => marker.huaweiMarker).toSet(),
            )
          : gm.GoogleMap(
              polygons: polygons.map((p) => p.toGooglePolygon).toSet(),
              polylines: polylines.map((p) => p.toGooglePolyline).toSet(),
              zoomGesturesEnabled: zoomGesturesEnabled,
              zoomControlsEnabled: false,
              // we use our own implementation that supports iOS as well, see _buildZoomButtons()
              myLocationButtonEnabled: false,
              compassEnabled: false,
              mapToolbarEnabled: false,
              initialCameraPosition: gm.CameraPosition(
                  target: initialTarget.googleLatLng, zoom: initialZoomValue),
              mapType: mapType.googleMapType,
              myLocationEnabled: true,
              circles: pickArea != null && pickArea!.toGoogleCircle.radius > 0
                  ? {pickArea!.toGoogleCircle}
                  : {},
              onMapCreated: (final gm.GoogleMapController controller) {
                provider.mapController.completeGoogleController(controller);
                provider.setCameraPosition(null);
                provider.pinState = PinState.idle;

                // When select initialPosition set to true.
                if (selectInitialPosition!) {
                  provider.setCameraPosition(initialTarget);
                  searchByCameraLocation(provider);
                }
                onMapCreated?.call(provider.mapController);
              },
              onCameraIdle: () {
                if (provider.isAutoCompleteSearching) {
                  provider.isAutoCompleteSearching = false;
                  provider.pinState = PinState.idle;
                  provider.placeSearchingState = SearchingState.idle;
                  return;
                }
                // Perform search only if the setting is to true.
                if (usePinPointingSearch!) {
                  // Search current camera location only if camera has moved (dragged) before.
                  if (provider.pinState == PinState.dragging) {
                    // Cancel previous timer.
                    if (provider.debounceTimer?.isActive ?? false) {
                      provider.debounceTimer!.cancel();
                    }
                    provider.debounceTimer = Timer(
                        Duration(milliseconds: debounceMilliseconds!), () {
                      searchByCameraLocation(provider);
                    });
                  }
                }
                provider.pinState = PinState.idle;
                onCameraIdle?.call(provider);
              },
              onCameraMoveStarted: () {
                onCameraMoveStarted?.call(provider);
                provider.setPrevCameraPosition(provider.cameraPosition);
                // Cancel any other timer.
                provider.debounceTimer?.cancel();
                // Update state, dismiss keyboard and clear text.
                provider.pinState = PinState.dragging;
                // Begins the search state if the hide details is enabled
                if (hidePlaceDetailsWhenDraggingPin!) {
                  provider.placeSearchingState = SearchingState.searching;
                }
                onMoveStart!();
              },
              onCameraMove: (final gm.CameraPosition position) {
                provider.setCameraPosition(
                    UltraLocationModel.fromGoogleLatLng(position.target));
                provider.zoomLevel = position.zoom;
                onCameraMove?.call(
                    UltraLocationModel.fromGoogleLatLng(position.target));
              },
              // gestureRecognizers make it possible to navigate the map when it's a
              // child in a scroll view e.g ListView, SingleChildScrollView...
              gestureRecognizers: {}..add(Factory<EagerGestureRecognizer>(
                  () => EagerGestureRecognizer())),

              markers: markers.map((marker) => marker.googleMarker).toSet(),
            ),
    );
  }
}
