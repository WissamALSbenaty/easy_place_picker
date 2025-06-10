import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/src/providers/place_provider.dart';
import 'package:provider/provider.dart';

class ZoomButtons extends StatelessWidget {
  const ZoomButtons({super.key});

  @override
  Widget build(BuildContext context) {
    PlaceProvider provider = PlaceProvider.of(context, listen: false);
    return Selector<PlaceProvider, LatLng?>(
      selector: (final _, final provider) => provider.cameraPosition,
      builder: (final context, final data, final __) => data != null
          ? Positioned(
              bottom: MediaQuery.of(context).size.height * 0.1 - 3.6,
              right: 2,
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.15 - 13,
                  height: 107,
                  child: Column(
                    children: <Widget>[
                      IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () async {
                            double? currentZoomLevel =
                                await provider.mapController?.getZoomLevel();
                            currentZoomLevel = (currentZoomLevel ?? 14) + 2;
                            await provider.animateCamera(data.latitude,
                                data.longitude, currentZoomLevel);
                          }),
                      const SizedBox(height: 2),
                      IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () async {
                            double? currentZoomLevel =
                                await provider.mapController?.getZoomLevel();
                            currentZoomLevel = (currentZoomLevel ?? 14) - 2;
                            if (currentZoomLevel < 0) {
                              currentZoomLevel = 0;
                            }
                            await provider.animateCamera(data.latitude,
                                data.longitude, currentZoomLevel);
                          }),
                    ],
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
