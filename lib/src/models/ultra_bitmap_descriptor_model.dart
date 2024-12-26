import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gm;
import 'package:huawei_map/huawei_map.dart' as hm;

/// A model that encapsulates bitmap descriptors for Google Maps and Huawei Maps.
///
/// This class provides a unified interface for creating and managing
/// bitmap descriptors for markers on Google Maps and Huawei Maps.
class UltraBitmapDescriptorModel {
  /// The [gm.BitmapDescriptor] for Google Maps.
  final gm.BitmapDescriptor googleBitmap;

  /// The [hm.BitmapDescriptor] for Huawei Maps.
  final hm.BitmapDescriptor huaweiBitmap;

  /// Creates an instance of [UltraBitmapDescriptorModel] with the provided
  /// Google Maps and Huawei Maps bitmap descriptors.
  const UltraBitmapDescriptorModel({
    required this.googleBitmap,
    required this.huaweiBitmap,
  });

  /// Asynchronously creates an [UltraBitmapDescriptorModel] from an asset image.
  ///
  /// This method loads the asset image and generates the bitmap descriptors
  /// for both Google Maps and Huawei Maps.
  ///
  /// - [size]: The desired size of the bitmap.
  /// - [asset]: The path to the asset image.
  ///
  /// Returns an [UltraBitmapDescriptorModel] instance.
  static Future<UltraBitmapDescriptorModel> fromAsset({
    required Size size,
    required String asset,
  }) async {
    return UltraBitmapDescriptorModel(
      googleBitmap: await gm.BitmapDescriptor.asset(
          ImageConfiguration(size: size), asset),
      huaweiBitmap: await hm.BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: size), asset),
    );
  }

  /// Creates an [UltraBitmapDescriptorModel] from raw byte data.
  ///
  /// This factory constructor generates bitmap descriptors for both Google Maps
  /// and Huawei Maps using the provided byte data.
  ///
  /// - [bytes]: The raw byte data representing the image.
  /// - [size]: The size of the bitmap.
  ///
  /// Returns an [UltraBitmapDescriptorModel] instance.
  factory UltraBitmapDescriptorModel.fromBytes({
    required Uint8List bytes,
    required Size size,
  }) =>
      UltraBitmapDescriptorModel(
        googleBitmap: gm.BitmapDescriptor.bytes(
          bytes,
          height: size.height,
          width: size.width,
        ),
        huaweiBitmap: hm.BitmapDescriptor.fromBytes(bytes),
      );

  /// A default marker descriptor with the default marker icons for
  /// both Google Maps and Huawei Maps.
  static const defaultMarker = UltraBitmapDescriptorModel(
    googleBitmap: gm.BitmapDescriptor.defaultMarker,
    huaweiBitmap: hm.BitmapDescriptor.defaultMarker,
  );
}
