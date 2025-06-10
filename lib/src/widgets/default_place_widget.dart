import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/src/enums.dart';
import 'package:google_maps_place_picker/src/models/pick_result_model.dart';
import 'package:google_maps_place_picker/src/widgets/floating_card.dart';
import 'package:google_maps_place_picker/src/widgets/map_loading_indicator.dart';
import 'package:google_maps_place_picker/src/widgets/selection_details_widget.dart';

class DefaultPlaceWidget extends StatelessWidget {
  final PickResultModel? data;
  final SearchingState state;
  final Circle? pickArea;
  final String? outsideOfPickAreaText;
  final String? selectedText;
  final ValueChanged<PickResultModel>? onPlacePicked;

  const DefaultPlaceWidget(
      {super.key,
      required this.data,
      required this.state,
      required this.pickArea,
      required this.outsideOfPickAreaText,
      required this.selectedText,
      required this.onPlacePicked});

  @override
  Widget build(BuildContext context) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.1,
      leftPosition: MediaQuery.of(context).size.width * 0.15,
      rightPosition: MediaQuery.of(context).size.width * 0.15,
      width: MediaQuery.of(context).size.width * 0.7,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.searching
          ? const MapLoadingIndicator()
          : SelectionDetailsWidget(
              result: data!,
              pickArea: pickArea,
              outsideOfPickAreaText: outsideOfPickAreaText,
              onPlacePicked: onPlacePicked,
              selectText: selectedText,
            ),
    );
  }
}
