import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_place_picker/src/providers/place_provider.dart';
import 'package:provider/provider.dart';
import 'package:easy_place_picker/src/widgets/default_place_widget.dart';
import 'package:easy_place_picker/easy_place_picker.dart';

class PlaceBuilderSelector extends StatelessWidget {
  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final bool? hidePlaceDetailsWhenDraggingPin;

  final Circle? pickArea;
  final String? outsideOfPickAreaText;
  final String? selectedText;
  final ValueChanged<PickResultModel>? onPlacePicked;

  const PlaceBuilderSelector(
      {super.key,
      required this.selectedPlaceWidgetBuilder,
      required this.hidePlaceDetailsWhenDraggingPin,
      required this.pickArea,
      required this.outsideOfPickAreaText,
      required this.selectedText,
      required this.onPlacePicked});

  @override
  Widget build(BuildContext context) {
    return Selector<PlaceProvider,
        (PickResultModel?, SearchingState, bool, PinState, double)>(
      selector: (final _, final provider) => (
        provider.selectedPlace,
        provider.placeSearchingState,
        provider.isSearchBarFocused,
        provider.pinState,
        provider.zoomLevel,
      ),
      builder: (final context, final data, final __) {
        if (data.$1 == null ||
            data.$2 == SearchingState.searching ||
            data.$3 == true ||
            data.$4 == PinState.dragging && hidePlaceDetailsWhenDraggingPin!) {
          return Container();
        } else {
          if (selectedPlaceWidgetBuilder == null) {
            return DefaultPlaceWidget(
              data: data.$1,
              state: data.$2,
              pickArea: pickArea,
              outsideOfPickAreaText: outsideOfPickAreaText,
              selectedText: selectedText,
              onPlacePicked: onPlacePicked,
            );
          } else {
            return Builder(
                builder: (final builderContext) => selectedPlaceWidgetBuilder!(
                    builderContext, data.$1, data.$2, data.$3, data.$5));
          }
        }
      },
    );
  }
}
