import 'package:platform_maps_flutter_platform_interface/platform_maps_flutter_platform_interface.dart';
import 'package:platform_maps_flutter_osm_android/src/camera.dart'
    as flutter_osm_plugin_interface;
import 'package:platform_maps_flutter_osm_android/src/mapper_extensions.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart'
    as flutter_osm_plugin;

class OSMPlatformCameraUpdate extends PlatformCameraUpdate {
  OSMPlatformCameraUpdate() : super.implementation();

  @override
  CameraUpdate newCameraPosition(CameraPosition cameraPosition) {
    return OSMCameraUpdate._(
      flutter_osm_plugin_interface.CameraUpdate.toPosition(
        flutter_osm_plugin_interface.CameraPosition(
          target: flutter_osm_plugin.GeoPoint(
            latitude: cameraPosition.target.latitude,
            longitude: cameraPosition.target.longitude,
          ),
          zoom: cameraPosition.zoom,
          tilt: cameraPosition.tilt,
          bearing: cameraPosition.bearing,
        ),
      ),
    );
  }

  @override
  CameraUpdate newLatLng(LatLng latLng) {
    return OSMCameraUpdate._(
      flutter_osm_plugin_interface.CameraUpdate.toLatLng(
        flutter_osm_plugin.GeoPoint(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
        ),
      ),
    );
  }

  @override
  CameraUpdate newLatLngBounds(LatLngBounds bounds, double padding) {
    return OSMCameraUpdate._(
    flutter_osm_plugin_interface.CameraUpdate.toLatLngBounds(
        flutter_osm_plugin.BoundingBox(
          east: bounds.northeast.osmMapsLatLng.longitude,
          north: bounds.northeast.osmMapsLatLng.latitude,
          south: bounds.southwest.osmMapsLatLng.latitude,
          west: bounds.southwest.osmMapsLatLng.longitude,
        ),
        padding,
      ),
    );
  }

  @override
  CameraUpdate newLatLngZoom(LatLng latLng, double zoom) {
    return OSMCameraUpdate._(
      flutter_osm_plugin_interface.CameraUpdate.toLatLngZoom(
        flutter_osm_plugin.GeoPoint(
          latitude: latLng.latitude,
          longitude: latLng.longitude,
        ),
        zoom,
      ),
    );
  }

  @override
  CameraUpdate zoomBy(double amount) {
    return OSMCameraUpdate._(
      flutter_osm_plugin_interface.CameraUpdate.zoomBy(amount),
    );
  }

  @override
  CameraUpdate zoomIn() {
    return OSMCameraUpdate._(
      flutter_osm_plugin_interface.CameraUpdate.zoomIn(),
    );
  }

  @override
  CameraUpdate zoomOut() {
    return OSMCameraUpdate._(
      flutter_osm_plugin_interface.CameraUpdate.zoomOut(),
    );
  }

  @override
  CameraUpdate zoomTo(double zoom) {
    return OSMCameraUpdate._(
      flutter_osm_plugin_interface.CameraUpdate.zoomTo(
        zoom,
      ),
    );
  }
}



class OSMCameraUpdate extends CameraUpdate {
  const OSMCameraUpdate._(this.osmCameraUpdate);
  final flutter_osm_plugin_interface.CameraUpdate osmCameraUpdate;
}
