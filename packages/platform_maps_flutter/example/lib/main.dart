import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:platform_maps_flutter/platform_maps_flutter.dart';
import 'package:platform_maps_flutter_platform_interface/platform_maps_flutter_platform_interface.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _markers = const <Marker>{};
  late PlatformMapController controller;
  Set<Marker> get markers => _markers;
  set markers(Set<Marker> val) {
    setState(() => _markers = val);
  }

  @override
  void initState() {
    super.initState();
    initializeMap();
  }

  void initializeMap() async {
    BitmapDescriptor bitmapImage = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 8, size: Size(12, 12)),
        'assets/test-pin.png');
  }

  void _onMapCreated(PlatformMapController controller) async {
    print('onMapCreated');
    setState(() {
      this.controller = controller;
    });
    Future.delayed(const Duration(seconds: 5)).then(
      (_) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PlatformMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(51.5160895, -0.1294527),
              zoom: 19,
            ),
            markers: _markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            mapType: MapType.normal,
            onTap: (location) => debugPrint('onTap: ${location.latitude}'),
            // onCameraMove: (cameraUpdate) =>
            //     debugPrint('onCameraMove: ${cameraUpdate.target}'),
            compassEnabled: true,
            onMapCreated: _onMapCreated,
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: FloatingActionButton(
              onPressed: () {
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    const CameraPosition(
                      bearing: 270.0,
                      target: LatLng(51.517043, -0.125720),
                      zoom: 18,
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
