import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:huawei_map/huawei_map.dart' as hm;
import 'package:ultra_map_place_picker/src/models/ultra_location_model.dart';

/// A model representing a polygon that is compatible with both Google Maps
/// and Huawei Maps.
///
/// This class provides a unified interface to define and convert polygon
/// configurations for use in Google Maps and Huawei Maps.
class UltraPolygonModel {
  /// The unique identifier for the polygon.
  final String polygonId;

  /// The fill color of the polygon. Defaults to [Colors.black] if not provided.
  final Color? fillColor;

  /// Whether the polygon is geodesic (follows the curvature of the Earth).
  final bool? geodesic;

  /// The list of points (vertices) defining the polygon.
  /// Each point is represented as an [UltraLocationModel].
  final List<UltraLocationModel>? points;

  /// Whether the polygon is visible. Defaults to `true` if not provided.
  final bool? visible;

  /// The color of the polygon's stroke (outline). Defaults to [Colors.black].
  final Color? strokeColor;

  /// The width of the polygon's stroke in pixels. Defaults to `10`.
  final int? strokeWidth;

  /// The z-index of the polygon, which determines its drawing order.
  final int? zIndex;

  /// A callback that is triggered when the polygon is clicked.
  final VoidCallback? onClick;

  /// A list of holes (inner polygons) within the polygon.
  /// Each hole is represented as a list of [UltraLocationModel] points.
  final List<List<UltraLocationModel>>? holes;

  /// Creates an instance of [UltraPolygonModel] with the specified properties.
  UltraPolygonModel({
    required this.polygonId,
    this.fillColor,
    this.geodesic,
    this.points,
    this.visible,
    this.strokeColor,
    this.strokeWidth,
    this.zIndex,
    this.onClick,
    this.holes,
  });

  /// Converts this polygon model into a [gm.Polygon] for use with Google Maps.
  gm.Polygon get toGooglePolygon => gm.Polygon(
        polygonId: gm.PolygonId(polygonId),
        fillColor: fillColor ?? Colors.black,
        geodesic: geodesic ?? false,
        points: points?.map((point) => point.googleLatLng).toList() ?? [],
        visible: visible ?? true,
        strokeColor: strokeColor ?? Colors.black,
        strokeWidth: strokeWidth ?? 10,
        zIndex: zIndex ?? 0,
        onTap: onClick,
        consumeTapEvents: onClick != null,
        holes: holes
                ?.map((holeList) =>
                    holeList.map((hole) => hole.googleLatLng).toList())
                .toList() ??
            [],
      );

  /// Converts this polygon model into a [hm.Polygon] for use with Huawei Maps.
  hm.Polygon get toHuaweiPolygon => hm.Polygon(
        polygonId: hm.PolygonId(polygonId),
        clickable: onClick != null,
        fillColor: fillColor ?? Colors.black,
        geodesic: geodesic ?? false,
        points: points?.map((point) => point.huaweiLatLng).toList() ?? [],
        holes: holes
                ?.map((holeList) =>
                    holeList.map((hole) => hole.huaweiLatLng).toList())
                .toList() ??
            [],
        visible: visible ?? true,
        strokeColor: strokeColor ?? Colors.black,
        strokeWidth: strokeWidth ?? 10,
        zIndex: zIndex ?? 0,
        onClick: onClick,
      );
}
