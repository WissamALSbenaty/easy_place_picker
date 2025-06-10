import 'package:flutter/material.dart';
import 'package:google_maps_place_picker/src/providers/place_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_maps_place_picker/src/widgets/default_pin.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';

class PinWidgetSelector extends StatelessWidget {
  final PinBuilder? pinBuilder;
  const PinWidgetSelector({super.key, required this.pinBuilder});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Selector<PlaceProvider, (PinState, double)>(
        selector: (final _, final provider) =>
            (provider.pinState, provider.zoomLevel),
        builder: (final context, final data, final __) {
          if (pinBuilder == null) {
            return DefaultPin(state: data.$1);
          } else {
            return Builder(
                builder: (final builderContext) =>
                    pinBuilder!(builderContext, data.$1, data.$2));
          }
        },
      ),
    );
  }
}
