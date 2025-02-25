import 'package:flutter/material.dart';
import 'package:ultra_map_place_picker/ultra_map_place_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return UltraMapPlacePicker(
      initialPosition: UltraLocationModel(25.32134, 21.241421),
      googleApiKey: 'your key',
      mapTypes: (_) => UltraMapType.values,
      pinBuilder: (_, __, zoom) {
        return Text('$zoom');
      },
      selectedPlaceWidgetBuilder: (_, __, ___, ____, zoom) {
        return Container();
      },
    );
  }
}
