import 'package:flutter/material.dart';
import 'package:easy_place_picker/easy_place_picker.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
    BuildContext context,
    PickResultModel? selectedPlace,
    SearchingState state,
    bool isSearchBarFocused,
    double zoomLevel);

typedef PinBuilder = Widget Function(
    BuildContext context, PinState state, double zoomLevel);

typedef IntroModalWidgetBuilder = Widget Function(
    BuildContext context, void Function() onClose);
