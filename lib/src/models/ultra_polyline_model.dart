import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:huawei_map/huawei_map.dart' as hm;
import 'package:ultra_map_place_picker/src/enums.dart';
import 'package:ultra_map_place_picker/src/models/ultra_location_model.dart';

/// A model representing a polyline that is compatible with both Google Maps
/// and Huawei Maps.
///
/// This class provides a unified interface to define and convert polyline
/// configurations for use in Google Maps and Huawei Maps.
class UltraPolylineModel {
  /// The unique identifier for the polyline.
  final String polylineId;

  /// The color of the polyline. Defaults to [Colors.black] for Google Maps
  /// and [Colors.red] for Huawei Maps if not provided.
  final Color? color;

  /// Whether the polyline is geodesic (follows the curvature of the Earth).
  final bool? geodesic;

  /// The type of joint used to connect segments of the polyline.
  /// Uses [UltraJointType] to represent joint types.
  final UltraJointType? jointType;

  /// The list of points (vertices) defining the polyline.
  /// Each point is represented as an [UltraLocationModel].
  final List<UltraLocationModel> points;

  /// Whether the polyline is visible. Defaults to `true` if not provided.
  final bool? visible;

  /// The width of the polyline in pixels. Defaults to `1`.
  final int? width;

  /// The z-index of the polyline, which determines its drawing order.
  final int? zIndex;

  /// A callback that is triggered when the polyline is clicked.
  final VoidCallback? onClick;

  /// Creates an instance of [UltraPolylineModel] with the specified properties.
  ///
  /// - [polylineId]: The unique identifier for the polyline (required).
  /// - [points]: The list of points defining the polyline (required).
  UltraPolylineModel({
    required this.polylineId,
    this.color,
    this.geodesic,
    this.jointType,
    required this.points,
    this.visible,
    this.width,
    this.zIndex,
    this.onClick,
  });

  /// Converts this polyline model into a [gm.Polyline] for use with Google Maps.
  gm.Polyline get toGooglePolyline => gm.Polyline(
        polylineId: gm.PolylineId(polylineId),
        consumeTapEvents: onClick != null,
        color: color ?? Colors.black,
        geodesic: geodesic ?? false,
        jointType: jointType?.googleJointType ?? gm.JointType.mitered,
        points: points.map((point) => point.googleLatLng).toList(),
        visible: visible ?? true,
        width: width ?? 1,
        zIndex: zIndex ?? 0,
        onTap: onClick,
      );

  /// Converts this polyline model into a [hm.Polyline] for use with Huawei Maps.
  hm.Polyline get toHuaweiPolyline => hm.Polyline(
        polylineId: hm.PolylineId(polylineId),
        points: points.map((point) => point.huaweiLatLng).toList(),
        geodesic: geodesic ?? false,
        width: width ?? 1,
        color: color ?? Colors.red,
        jointType: jointType?.huaweiJointType ?? hm.JointType.mitered,
        visible: visible ?? true,
        zIndex: zIndex ?? 0,
        clickable: onClick != null,
        onClick: onClick,
      );
}
