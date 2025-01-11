import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class OsmMarker {
  const OsmMarker({
    this.markerIcon,
    this.angle,
    this.iconAnchor,
  });

  final MarkerIcon? markerIcon;
  final double? angle;
  final IconAnchor? iconAnchor;
}
