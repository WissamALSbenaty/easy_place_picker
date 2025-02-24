<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/guides/libraries/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-library-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/developing-packages).
-->

#### A Flutter package that simplifies location selection on maps, regardless of device type.<br>This package offers seamless location selection for users on both Google Maps-enabled devices and those that are not, such as Huawei devices.

## What's new 
* Add double zoomLevel parameter to PinBuilder and IntroModalWidgetBuilder , this allows you to build these widgets differently when the zoom value changes , for example you want to force user to choose location within zoom value 
## Motivation
Repeating the features because of the different device type is time-wasting right?
<br>this package makes selecting from the map so much easier regardless the map type!
<br>it supports selecting by search or by moving the map camera



|Google map       | Petal map|
|:-------------------------:|:-------------------------:|
|![](assets/videos/google.gif)   |![](assets/videos/petal.gif)|



## Getting started
To ensure proper installation, please refer to the documentation for the following libraries: 
[google_maps_flutter](https://pub.dev/packages/google_maps_flutter)  and [huawei_map](https://pub.dev/packages/huawei_map)



## Usage
you only need to add this simple snippet to show the default sample

```dart
import 'package:ultra_map_place_picker/ultra_map_place_picker.dart';

@override
Widget build(BuildContext context) {
  return UltraPlacePicker(
    googleApiKey: 'MY KEY',
    initialPosition: LocationModel(25.1974767426511, 55.279669543133615),
    mapTypes:(isHuaweiDevice)=>isHuaweiDevice?  [UltraMapType.normal]:UltraMapType.values,
    myLocationButtonCooldown: 1,
    resizeToAvoidBottomInset: false, // only works in page mode, less flickery, remove if wrong offsets
  );
}
```

## Available Parameters

| Variable dartName                      | Variable Type | Required | Default Value                                | Description                                                                                                                             |
|------------------------------------|---|---|----------------------------------------------|-----------------------------------------------------------------------------------------------------------------------------------------|
| ``` googleApiKey ```           | ``` String ``` | Yes | -                                            | Your Google Maps API key for various map functionalities.                                                                               |
| ``` initialPosition```                    |```  LocationModel ``` | Yes | ``` null                  ```           | Initial position of the map.                                                                                                            |
| ``` mapTypes```|``` List<UltraMapType> Function(bool isHuaweiDevice)```|Yes| -                                            | Function that returns the available maps types depends on map type|                                                                                                                           
| ``` useCurrentLocation```                 |```  bool ```| No | ``` false                 ```           | If true, the picker will try to use the user's current location as the initial position. Requires location permission.                  |
| ``` desiredLocationAccuracy```            |```  LocationAccuracy``` | No | ``` LocationAccuracy.high ```            | Sets the desired accuracy for geolocation requests. Higher accuracy consumes more battery.                                              |
| ``` hintText```                           |```  String``` | No | ``` null                  ```           | Placeholder text displayed in the search bar.                                                                                           |
| ``` searchingText```                      |```  String ```| No | ``` null                  ```           | Text displayed in the search bar while searching.                                                                                       |
| ``` selectText```                         |```  String``` | No | ``` null                  ```           | Text displayed on the button to confirm a chosen location.                                                                              |
| ``` outsideOfPickAreaText```              |```  String``` | No | ``` null                  ```           | Text displayed if a location is chosen outside the designated pick area (if applicable).                                                |
| ``` onAutoCompleteFailed```               |```  ValueChanged<String>``` | No | ``` null                  ```           | Optional callback function triggered when autocomplete fails.                                                                           |
| ``` onGeocodingSearchFailed```            |```  ValueChanged<String> ```| No | ``` null                  ```           | Optional callback function triggered when geocoding search fails.                                                                       |
| ``` autoCompleteDebounceInMilliseconds``` |```  int ```| No | ``` 500                   ```           | Debounce time in milliseconds for autocomplete requests to avoid excessive API calls.                                                   |
| ``` cameraMoveDebounceInMilliseconds```   |```  int ```| No | ``` 100                   ```           | Debounce time in milliseconds for camera movement events to avoid excessive updates.                                                    |
| ``` initialMapType```                     |```  UltraMapType ```| No | ``` UltraMapType.normal  ``` | Initial map type to be displayed (normal, satellite, etc.).                                                                             |
| ``` enableMapTypeButton```                |```  bool ```| No | ``` true                  ```           | Whether to show a button to allow users to switch map types.                                                                            |
| ``` enableMyLocationButton```             |```  bool ```| No | ``` true                  ```           | Whether to show a button to center the map on the user's location.                                                                      |
| ``` myLocationButtonCooldown```           |```  int``` | No | ``` 10                    ```           | Cooldown time in seconds to prevent frequent location updates on tapping the My Location button.                                        |
| ``` usePinPointingSearch```               |```  bool ```| No | ``` true                  ```           | Whether to enable searching by tapping a location on the map.                                                                           |
| ``` usePlaceDetailSearch```               |```  bool ```| No | ``` false                 ```           | Whether to enable searching by entering an address or POI.                                                                              |
| ``` autocompleteOffset```                 |```  num ```| No | ``` null                  ```           | Optional offset for autocomplete suggestions relative to the search bar.                                                                |
| ``` autocompleteRadius```                 |```  num ```| No | ``` null                  ```           | Optional radius for autocomplete suggestions around the search location.                                                                |
| ``` autocompleteLanguage```               |```  String ```| No | ``` null                  ```           | Optional language preference for autocomplete suggestions.                                                                              |
| ``` autocompleteTypes```                  |```  List<String> ```| No | ``` null                  ```           | Optional list of place types to filter autocomplete suggestions.                                                                        |
| ``` autocompleteComponents```             |```  List<Component> ```| No | ``` null                  ```           | Optional list of components to filter autocomplete suggestions.                                                                         |
| ``` strictbounds```                       |```  bool ```| No | ``` null                  ```           | Whether to restrict autocomplete suggestions to the current map viewport.                                                               |
| ``` region```                             |```  String ```| No | ``` null                  ```           | Optional region code to restrict autocomplete suggestions.                                                                              |
| ``` pickArea```                           |```  UltraCircleModel ```| No | ``` null                  ```           | Optional circular area to restrict location selection.                                                                                  |
| ``` selectInitialPosition```              |```  bool ```| No | ``` false                 ```           | Whether to automatically select the initial position (if provided) and trigger the onPlacePicked callback.                              |
| ``` resizeToAvoidBottomInset```           |```  bool ```| No | ``` true                  ```           | Whether to adjust the layout to avoid the on-screen keyboard.                                                                           |
| ``` initialSearchString```                |```  String ```| No | ``` null                  ```           | Optional initial search string to pre-populate the search bar.                                                                          |
| ``` searchForInitialValue```              |```  bool ```| No | ``` false                 ```           | Whether to automatically search for the initialSearchString when the widget is built.                                                   |
| ``` forceSearchOnZoomChanged```           |```  bool ```| No | ``` false                 ```           | Whether to trigger a search when the map zoom level changes.                                                                            |
| ``` autocompleteOnTrailingWhitespace```   |```  bool ```| No | ``` false                 ```           | Whether to trigger autocomplete when the user enters a trailing whitespace character.                                                   |
| ``` hidePlaceDetailsWhenDraggingPin```    |```  bool ```| No | ``` true                  ```           | Whether to hide place details while the user is dragging the pin on the map.                                                            |
| ``` ignoreLocationPermissionErrors```     |```  bool ```| No | ``` false                 ```           | Whether to ignore location permission errors. If true, the UI might be blocked.                                                         |
| ``` onTapBack```                          |```  VoidCallback ```| No | ``` null                  ```           | Optional callback function triggered when the back button is tapped.                                                                    |
| ``` onMapCreated```                       |```  void Function(UltraMapController) ```| No | ``` null                  ```           | Optional callback function triggered when the map is ready to be used. Provides access to the map controller for further customization. |
| ``` onCameraMoveStarted```                |```  Function(PlaceProvider) ```| No | ``` null                  ```           | Optional callback function triggered when the camera starts moving.                                                                     |
| ``` onCameraMove```                       |```  void Function(LocationModel) ```| No | ``` null                  ```           | Optional callback function triggered repeatedly as the camera continues to move.                                                        |
| ``` onCameraIdle```                       |```  Function(PlaceProvider) ```| No | ``` null                  ```           | Optional callback function triggered when the camera movement stops.                                                                    |
| ``` onMapTypeChanged```                   |```  Function(UltraMapType) ```| No | ``` null                  ```           | Optional callback function triggered when the map type is changed.                                                                      |
| ``` zoomGesturesEnabled```                |```  bool ```| No | ``` true                  ```           | Whether to enable gestures for zooming in and out on the map.                                                                           |
| ``` zoomControlsEnabled```                |```  bool ```| No | ``` false                 ```           | Whether to show zoom controls (+) and (-) buttons on the map.                                                                           |
| ``` initialZoomValue```                   |```  double ```| No | ``` 15                    ```           | Initial zoom level of the map.                                                                                                          |
| ``` polygons```                           |```  Set<UltraPolygonModel> ```| No | ``` const {}              ```           | Optional set of polygon overlays to display on the map.                                                                                 |
| ``` polylines```                          |```  Set<UltraPolylineModel> ```| No | ``` const {}              ```           | Optional set of polyline overlays to display on the map.                                                                                |

