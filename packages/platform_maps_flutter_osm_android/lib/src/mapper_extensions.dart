import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_osm_interface/flutter_osm_interface.dart'
    as flutter_osm_interface;
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart'
    as flutter_osm_plugin;
import 'package:platform_maps_flutter_osm_android/src/osm_platform_controller.dart';
import 'package:platform_maps_flutter_platform_interface/platform_maps_flutter_platform_interface.dart';

extension OSMLatLngMapper on flutter_osm_plugin.GeoPoint {
  LatLng get platformLatLng {
    return LatLng(latitude, longitude);
  }
}

extension LatLngMapper on LatLng {
  flutter_osm_plugin.GeoPoint get osmMapsLatLng {
    debugPrint('LatLngMapper: $latitude, $longitude');
    return flutter_osm_plugin.GeoPoint.fromMap({
      'lat': latitude,
      'lon': longitude,
    });
  }
}

extension on List<LatLng> {
  List<flutter_osm_plugin.GeoPoint> get googleLatLngList {
    return map((latLng) => latLng.osmMapsLatLng).toList();
  }
}

extension LatLngBoundsMapper on LatLngBounds {
  flutter_osm_plugin.BoundingBox get osmLatLngBounds {
    return flutter_osm_plugin.BoundingBox(
      east: osmLatLngBounds.east,
      north: osmLatLngBounds.north,
      south: osmLatLngBounds.south,
      west: osmLatLngBounds.west,
    );
  }
}

extension GoogleMapsLatLngBoundsMapper on flutter_osm_plugin.GeoPoint {
  LatLngBounds get platformLatLngBounds {
    return LatLngBounds(
      southwest: LatLng(
        platformLatLngBounds.southwest.latitude,
        platformLatLngBounds.southwest.longitude,
      ),
      northeast: LatLng(
        platformLatLngBounds.northeast.latitude,
        platformLatLngBounds.northeast.longitude,
      ),
    );
  }
}

extension MarkersMapper on Set<Marker> {
  Set<flutter_osm_plugin.GeoPoint> get osmMarkerSet {
    return map((marker) => marker.osmGeoPoint).toSet();
  }
}

extension MarkersListGeoPoint on Set<Marker> {
  List<flutter_osm_plugin.GeoPoint> get osmMarkerList {
    return map((marker) => marker.osmGeoPoint).toList();
  }
}

extension GeoPointMarker on Set<flutter_osm_plugin.GeoPoint> {
  Set<Marker> get osmMarkerSet {
    return map((marker) => marker.osmMarker).toSet();
  }
}

extension on flutter_osm_plugin.GeoPoint {
  Marker get osmMarker {
    return Marker(
      markerId: MarkerId(osmMarker.osmGeoPoint.hashCode.toString()),
      position: LatLng(latitude, longitude),
    );
  }
}

// flutter_osm_plugin.GeoPoint
extension OsmGeoPoint on Marker {
  flutter_osm_plugin.GeoPoint get osmGeoPoint {
    return flutter_osm_plugin.GeoPoint(
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }
}

// extension on BitmapDescriptor {
//   flutter_osm_plugin.AssetMarker get osmAssetImage {

//     return flutter_osm_plugin.AssetMarker(
//       image: AssetImage('data:image/png;base64,${descriptor.descriptor.image}'),
//     );
//   }
// }

extension MarkerIdMapper on MarkerId {
  // google_maps.MarkerId get googleMapsMarkerId {
  //   return google_maps.MarkerId(value);
  // }
}

extension on InfoWindow {
  // google_maps.InfoWindow get googleMapsInfoWindow => google_maps.InfoWindow(
  //       anchor: anchor ?? const Offset(0, 0),
  //       onTap: onTap,
  //       snippet: snippet,
  //       title: title,
  //     );
}

extension CameraMapper on CameraPosition {
  flutter_osm_interface.GeoPoint get osmCameraPosition {
    return flutter_osm_interface.GeoPoint(
      latitude: target.latitude,
      longitude: target.longitude,
    );
  }
}

extension PolylinesMapper on Set<Polyline> {
  Set<flutter_osm_interface.RoadOption> get googleMapsPolylineSet {
    return map((polyline) => polyline.googleMapsPolyline).toSet();
  }
}

extension on Polyline {
  flutter_osm_interface.RoadOption get googleMapsPolyline {
    return flutter_osm_interface.RoadOption(
      roadColor: color,
      roadWidth: width.toDouble(),
      zoomInto: false,
      roadBorderColor: null,
      roadBorderWidth: null,
      isDotted: false,
    );
  }
}

extension PolylinesOSMMapper on List<flutter_osm_interface.GeoPoint> {
  List<flutter_osm_interface.GeoPoint> get osmPolyline {
    return map((polyline) => polyline).toList();
  }
}

extension PolylineOSMGeoPoints on Polyline {
  List<flutter_osm_interface.GeoPoint> get osmPolyline {
    return points
        .map((point) => flutter_osm_interface.GeoPoint(
            latitude: point.latitude, longitude: point.longitude))
        .toList();
  }
}

extension on PolylineId {
  flutter_osm_interface.RoadInfo get osmPolylineId {
    return flutter_osm_interface.RoadInfo();
  }
}

extension on Cap {
  // static const Map<Cap, flutter_osm_interface.Cap> googleMapsCaps = {
  //   Cap.buttCap: google_maps.Cap.buttCap,
  //   Cap.roundCap: google_maps.Cap.roundCap,
  //   Cap.squareCap: google_maps.Cap.squareCap,
  // };

  // google_maps.Cap get googlePolylineCap {
  //   return googleMapsCaps[this]!;
  // }
}

extension on JointType {
  // static const List<google_maps.JointType> googleMapsJointTypes = [
  //   google_maps.JointType.mitered,
  //   google_maps.JointType.bevel,
  //   google_maps.JointType.round,
  // ];

  // google_maps.JointType get googleMapsJointType {
  //   return googleMapsJointTypes[value];
  // }
}

extension on List<PatternItem> {
  // List<google_maps.PatternItem> get googleMapsPatternItemList {
  //   return map((patternItem) => patternItem.googleMapsPatternItem).toList();
  // }
}

extension on PatternItem {
  // google_maps.PatternItem get googleMapsPatternItem {
  //   return switch (this) {
  //     DotPatternItem() => google_maps.PatternItem.dot,
  //     DashPatternItem dash => google_maps.PatternItem.dash(dash.length),
  //     GapPatternItem gap => google_maps.PatternItem.gap(gap.length),
  //   };
  // }
}

extension PolygonMapper on Set<Polygon> {
  Set<flutter_osm_plugin.RectOSM> get osmPolygonSet {
    return map((polygon) => polygon.osmPolygon).toSet();
  }
}

extension on Polygon {
  flutter_osm_plugin.RectOSM get osmPolygon {
    return flutter_osm_interface.RectOSM(
      key: polygonId.value,
      color: fillColor,
      strokeWidth: strokeWidth.toDouble(),
      borderColor: strokeColor,
      centerPoint: points.first.osmMapsLatLng,
      distance: 1.0,
    );
  }
}

extension CircleMapper on Set<Circle> {
  Set<flutter_osm_plugin.CircleOSM> get osmCircleSet {
    return map((circle) => circle.osmCircle).toSet();
  }
}

extension on Circle {
  flutter_osm_interface.CircleOSM get osmCircle {
    return flutter_osm_interface.CircleOSM(
      key: circleId.value,
      centerPoint: center.osmMapsLatLng,
      radius: radius,
      color: fillColor,
      strokeWidth: strokeWidth.toDouble(),
      borderColor: strokeColor,
    );
  }
}

extension ZoomMapper on MinMaxZoomPreference {
  flutter_osm_plugin.ZoomOption get osmZoomPreference {
    return flutter_osm_plugin.ZoomOption(
      maxZoomLevel: maxZoom ?? 19,
      minZoomLevel: minZoom ?? 11,
      initZoom: 16,
      stepZoom: 1,
    );
  }
}

extension OSMControllerMappers on flutter_osm_plugin.MapController {
  PlatformMapController get platformMapController {
    return PlatformMapController(OSMPlatformController(this));
  }
}
