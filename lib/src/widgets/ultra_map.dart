import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:easy_place_picker/src/enums.dart';
import 'package:easy_place_picker/src/models/pick_result_model.dart';
import 'package:easy_place_picker/src/providers/place_provider.dart';

class MapWidget extends StatelessWidget {
  final PlaceProvider provider;
  final LatLng initialTarget;
  final gm.MapType mapType;
  final void Function(PlaceProvider) searchByCameraLocation;
  final VoidCallback? onMoveStart;
  final void Function(GoogleMapController?)? onMapCreated;
  final ValueChanged<PickResultModel>? onPlacePicked;

  final int? debounceMilliseconds;

  final bool? usePinPointingSearch;

  final bool? selectInitialPosition;

  final String? language;
  final Circle? pickArea;

  final bool? hidePlaceDetailsWhenDraggingPin;

  /// GoogleMap pass-through events:
  final Function(PlaceProvider)? onCameraMoveStarted;
  final void Function(LatLng)? onCameraMove;
  final Function(PlaceProvider)? onCameraIdle;

  // strings
  final String? selectText;

  /// Zoom feature toggle
  final bool zoomGesturesEnabled;
  final bool zoomControlsEnabled;
  final bool enableScrolling;
  final double initialZoomValue;

  /// Use never scrollable scroll-view with maximum dimensions to prevent unnecessary re-rendering.

  final Set<Polygon> polygons;
  final Set<Polyline> polylines;
  final Set<Marker> markers;

  const MapWidget({
    super.key,
    required this.provider,
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
      child: gm.GoogleMap(
        polygons: polygons,
        polylines: polylines,
        zoomGesturesEnabled: zoomGesturesEnabled,
        zoomControlsEnabled: false,
        // we use our own implementation that supports iOS as well, see _buildZoomButtons()
        myLocationButtonEnabled: false,
        compassEnabled: false,
        mapToolbarEnabled: false,
        initialCameraPosition:
            gm.CameraPosition(target: initialTarget, zoom: initialZoomValue),
        mapType: mapType,
        myLocationEnabled: true,
        circles: (pickArea?.radius ?? 0) > 0 ? {pickArea!} : {},
        onMapCreated: (final gm.GoogleMapController controller) {
          Completer().complete(controller);
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
              provider.debounceTimer =
                  Timer(Duration(milliseconds: debounceMilliseconds!), () {
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
          provider.setCameraPosition(position.target);
          provider.zoomLevel = position.zoom;
          onCameraMove?.call(position.target);
        },
        // gestureRecognizers make it possible to navigate the map when it's a
        // child in a scroll view e.g ListView, SingleChildScrollView...
        gestureRecognizers: {}..add(
            Factory<EagerGestureRecognizer>(() => EagerGestureRecognizer())),

        markers: markers,
      ),
    );
  }
}
