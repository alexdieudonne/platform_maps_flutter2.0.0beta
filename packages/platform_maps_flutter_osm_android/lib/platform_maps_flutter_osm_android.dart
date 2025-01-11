library platform_maps_flutter_osm_android;

import 'package:platform_maps_flutter_osm_android/src/osm_bitmap_descriptor.dart';
import 'package:platform_maps_flutter_osm_android/src/osm_camera_update.dart';
import 'package:platform_maps_flutter_osm_android/src/osm_widget.dart';
import 'package:platform_maps_flutter_platform_interface/platform_maps_flutter_platform_interface.dart';

class PlatformMapsOsmAndroid extends PlatformMapsPlatform {
  static void registerWith() {
    PlatformMapsPlatform.instance = PlatformMapsOsmAndroid();
  }

  /// Create a new [PlatformPlatformMapsWidget].
  ///
  /// This function should only be called by the app-facing package.
  /// Look at using [PlatformMap] in `platform_maps_flutter` instead.
  @override
  PlatformMapsPlatformWidget createPlatformMapsPlatformWidget(
    PlatformMapsPlatformWidgetCreationParams params,
  ) {
    return OSMWidget(params);
  }

  /// Create a new [PlatformBitmapDescriptor].
  /// This function should only be called by the app-facing package.
  @override
  OSMPlatformBitmapDescriptor createBitmapDescriptor() {
    return OSMPlatformBitmapDescriptor();
  }

  @override
  PlatformCameraUpdate createPlatformCameraUpdate() {
    return OSMPlatformCameraUpdate();
  }
}
