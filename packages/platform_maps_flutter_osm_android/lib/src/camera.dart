// Copyright 2024
// Licensed under a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart'
    as flutter_osm_plugin;

/// Represents a generic map "camera" position, defining the viewpoint for a map.
/// Includes the camera's [target] location, [zoom] level, [tilt] angle, and [bearing].
class CameraPosition {
  const CameraPosition({
    required this.target,
    this.bearing = 0.0,
    this.tilt = 0.0,
    this.zoom = 0.0,
  });

  /// The camera's bearing in degrees, measured clockwise from true north.
  ///
  /// A value of 0.0 means the camera is facing north.
  /// A value of 90.0 means the camera is facing east.
  final double bearing;

  /// The geographical location the camera is pointing at.
  final flutter_osm_plugin.GeoPoint target;

  /// The camera's tilt angle, in degrees.
  ///
  /// A value of 0 means the camera is looking straight down.
  final double tilt;

  /// The zoom level of the camera.
  ///
  /// A zoom level of 0.0 represents the world at its widest view.
  /// Higher values zoom in, revealing more detail.
  final double zoom;

  Map<String, dynamic> toMap() => {
        'target': target.toMap(),
        'bearing': bearing,
        'tilt': tilt,
        'zoom': zoom,
      };

  static CameraPosition? fromMap(Map<String, dynamic>? json) {
    if (json == null) return null;

    return CameraPosition(
      bearing: json['bearing'],
      target: flutter_osm_plugin.GeoPoint.fromMap(json['target']),
      tilt: json['tilt'],
      zoom: json['zoom'],
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CameraPosition &&
          runtimeType == other.runtimeType &&
          bearing == other.bearing &&
          target == other.target &&
          tilt == other.tilt &&
          zoom == other.zoom;

  @override
  int get hashCode => Object.hash(bearing, target, tilt, zoom);

  @override
  String toString() =>
      'CameraPosition(bearing: $bearing, target: $target, tilt: $tilt, zoom: $zoom)';
}

/// Defines a camera move, supporting absolute moves as well as moves relative
/// to the current position.
abstract class CameraUpdate {
  const CameraUpdate(this.data);

  /// Contains all the data associated with this camera update.
  final Map<String, dynamic> data;

  /// Converts this object to something serializable in JSON.
  Map<String, dynamic> toJson() => data;

  /// Converts this object to a GeoPoint.
  flutter_osm_plugin.GeoPoint get geoPoint => flutter_osm_plugin.GeoPoint.fromMap(data['cameraPosition']['target']);

  /// Creates a `CameraUpdate` for moving to a specific camera position.
  static CameraUpdate toPosition(CameraPosition cameraPosition) {
    return CameraUpdateToPosition({'cameraPosition': cameraPosition.toMap()});
  }

  /// Creates a `CameraUpdate` for moving to a specific GeoPoint.
  static CameraUpdate toGeoPoint(flutter_osm_plugin.GeoPoint geoPoint) {
    return CameraUpdateToGeoPoint({'geoPoint': geoPoint.toMap()});
  }

  /// Creates a `CameraUpdate` for moving to a GeoPoint with a zoom level.
  static CameraUpdate toLatLngZoom(flutter_osm_plugin.GeoPoint geoPoint, double zoom) {
    return CameraUpdateToLatLngZoom({
      'geoPoint': geoPoint.toMap(),
      'zoom': zoom,
    });
  }

  /// Creates a `CameraUpdate` for moving to a GeoPoint
  static CameraUpdate toLatLng(flutter_osm_plugin.GeoPoint geoPoint) {
    return CameraUpdateToGeoPointZoom({
      'geoPoint': geoPoint.toMap(),
    });
  }

  /// Creates a `CameraUpdate` for moving to a viewport that includes the given
  static toLatLngBounds(flutter_osm_plugin.BoundingBox bounds, double padding) {
    return CameraUpdateToGeoPointZoom({
      'geoPoint': bounds.toMap(),
      'padding': padding,
    });
  }

  /// Creates a `CameraUpdate` for adjusting the zoom by a relative amount.
  static CameraUpdate zoomBy(double amount, [Offset? focus]) {
    return focus == null
        ? CameraUpdateZoomBy({'amount': amount})
        : CameraUpdateZoomBy({
            'amount': amount,
            'focus': [focus.dx, focus.dy],
          });
  }

  /// Creates a `CameraUpdate` for zooming in.
  static CameraUpdate zoomIn() {
    return CameraUpdateZoomIn();
  }

  /// Creates a `CameraUpdate` for zooming out.
  static CameraUpdate zoomOut() {
    return CameraUpdateZoomOut();
  }

  /// Creates a `CameraUpdate` for setting the camera's zoom level.
  static CameraUpdate zoomTo(double zoom) {
    return CameraUpdateZoomTo({'zoom': zoom});
  }
}

/// Subclass for moving to a specific position.
class CameraUpdateToPosition extends CameraUpdate {
  CameraUpdateToPosition(Map<String, dynamic> data)
      : assert(data.containsKey('cameraPosition')),
        super(data);

  CameraPosition get cameraPosition =>
      CameraPosition.fromMap(data['cameraPosition'])!;
}

/// Subclass for moving to a specific geographical point.
class CameraUpdateToGeoPoint extends CameraUpdate {
  CameraUpdateToGeoPoint(Map<String, dynamic> data)
      : assert(data.containsKey('geoPoint')),
        super(data);

  flutter_osm_plugin.GeoPoint get geoPoint =>
      flutter_osm_plugin.GeoPoint.fromMap(data['geoPoint']);
}

/// Subclass for moving to a geographical point with zoom level.
class CameraUpdateToGeoPointZoom extends CameraUpdate {
  CameraUpdateToGeoPointZoom(Map<String, dynamic> data)
      : assert(data.containsKey('geoPoint') && data.containsKey('zoom')),
        super(data);

  flutter_osm_plugin.GeoPoint get geoPoint =>
      flutter_osm_plugin.GeoPoint.fromMap(data['geoPoint']);
  double get zoom => data['zoom'];
}

/// Subclass for adjusting zoom level by a relative amount.
class CameraUpdateZoomBy extends CameraUpdate {
  CameraUpdateZoomBy(Map<String, dynamic> data)
      : assert(data.containsKey('amount')),
        super(data);

  double get amount => data['amount'];
  Offset? get focus =>
      data['focus'] != null ? Offset(data['focus'][0], data['focus'][1]) : null;
}

/// Subclass for zooming in by one level.
class CameraUpdateZoomIn extends CameraUpdate {
  CameraUpdateZoomIn() : super({'type': 'zoomIn'});
}

/// Subclass for zooming out by one level.
class CameraUpdateZoomOut extends CameraUpdate {
  CameraUpdateZoomOut() : super({'type': 'zoomOut'});
}

class CameraUpdateToLatLngZoom extends CameraUpdate {
  CameraUpdateToLatLngZoom(Map<String, dynamic> data)
      : assert(data.containsKey('geoPoint') && data.containsKey('zoom')),
        super(data);

  flutter_osm_plugin.GeoPoint get geoPoint => flutter_osm_plugin.GeoPoint.fromMap(data['geoPoint']);
  double get zoom => data['zoom'];
}

class CameraUpdateZoomTo extends CameraUpdate {
  CameraUpdateZoomTo(Map<String, dynamic> data)
      : assert(data.containsKey('zoom')),
        super(data);

  double get zoom => data['zoom'];
}
