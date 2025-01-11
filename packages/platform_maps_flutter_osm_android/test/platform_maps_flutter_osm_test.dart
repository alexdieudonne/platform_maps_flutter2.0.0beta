import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:platform_maps_flutter_osm_android/platform_maps_flutter_osm_android.dart';
import 'package:platform_maps_flutter_osm_android/src/osm_camera_update.dart';
import 'package:platform_maps_flutter_osm_android/src/osm_widget.dart';

import 'package:platform_maps_flutter_platform_interface/platform_maps_flutter_platform_interface.dart';

void main() {
  test('Verify widget generation', () {
    PlatformMapsOsmAndroid.registerWith();

    final widget = PlatformMapsPlatformWidget(
      const PlatformMapsPlatformWidgetCreationParams(
        initialCameraPosition: CameraPosition(target: LatLng(0, 0)),
      ),
    );
    expect(widget, isA<OSMWidget>());
  });

  test('Verify bitmap descriptor generation', () {
    PlatformMapsOsmAndroid.registerWith();

    // final platformBitmapDescriptor = PlatformBitmapDescriptor();
    // expect(platformBitmapDescriptor, isA<GoogleMapsPlatformBitmapDescriptor>());

    // final bitmapDescriptor =
    //     platformBitmapDescriptor.fromBytes(Uint8List.fromList([1, 2]));
    // expect(bitmapDescriptor, isA<GoogleMapsBitmapDescriptor>());
  });

  test('Verify camera update generation', () {
    PlatformMapsOsmAndroid.registerWith();

    final platformCameraUpdate = PlatformCameraUpdate();
    expect(platformCameraUpdate, isA<OSMPlatformCameraUpdate>());

    final cameraUpdate = platformCameraUpdate.zoomIn();
    expect(cameraUpdate, isA<OSMCameraUpdate>());
  });
}
