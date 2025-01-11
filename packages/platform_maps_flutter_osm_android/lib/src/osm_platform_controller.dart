import 'dart:typed_data';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart'
    as flutter_osm_plugin;
import 'package:platform_maps_flutter_osm_android/src/osm_camera_update.dart';
import 'package:platform_maps_flutter_platform_interface/platform_maps_flutter_platform_interface.dart';

class OSMPlatformController extends PlatformMapsPlatformController {
  OSMPlatformController(this._osmMapController);
  final flutter_osm_plugin.MapController _osmMapController;

  @override
  Future<void> animateCamera(CameraUpdate cameraUpdate) async {
    if (cameraUpdate is OSMCameraUpdate) {
      await _osmMapController.moveTo(
        cameraUpdate.osmCameraUpdate.geoPoint,
        animate: true,
      );
      await _osmMapController.setZoom(
          zoomLevel: cameraUpdate.osmCameraUpdate.data['cameraPosition']
              ['zoom']);
      return Future.value();
    }
    throw UnsupportedError(
      'GoogleMapsPlatformController: animateCamera - cameraUpdate is not a OSMCameraUpdate\n${cameraUpdate.toString()}',
    );
  }

  @override
  Future<LatLngBounds> getVisibleRegion() async {
    final visibleRegion = await _osmMapController.geopoints;
    return LatLngBounds(
      southwest: LatLng(
        visibleRegion[0].latitude,
        visibleRegion[0].longitude,
      ),
      northeast: LatLng(
        visibleRegion[1].latitude,
        visibleRegion[1].longitude,
      ),
    );
  }

  @override
  Future<void> hideMarkerInfoWindow(MarkerId markerId) {
    return Future.value();
  }

  @override
  Future<bool> isMarkerInfoWindowShown(MarkerId markerId) {
    return false as Future<bool>;
  }

  @override
  Future<void> moveCamera(CameraUpdate cameraUpdate) {
    if (cameraUpdate is OSMCameraUpdate) {
      return _osmMapController.moveTo(cameraUpdate.osmCameraUpdate.geoPoint,
          animate: true);
    }
    throw UnsupportedError(
      'GoogleMapsPlatformController: moveCamera - cameraUpdate is not a OSMCameraUpdate\n${cameraUpdate.toString()}',
    );
  }

  @override
  Future<void> showMarkerInfoWindow(MarkerId markerId) async {
    return;
  }

  @override
  Future<Uint8List?> takeSnapshot() async {
    return null;
  }
}
