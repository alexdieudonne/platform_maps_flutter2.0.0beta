import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:platform_maps_flutter_platform_interface/platform_maps_flutter_platform_interface.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart'
    as flutter_osm_plugin;

class OSMPlatformBitmapDescriptor extends PlatformBitmapDescriptor {
  OSMPlatformBitmapDescriptor() : super.implementation();
  @override
  Future<OSMBitmapDescriptor> fromAssetImage(
    ImageConfiguration configuration,
    String assetName, {
    AssetBundle? bundle,
    String? package,
  }) async {
  
    final descriptor = flutter_osm_plugin.AssetMarker(
      image: AssetImage(assetName, bundle: bundle, package: package),
      scaleAssetImage: configuration.devicePixelRatio,
    );
    return OSMBitmapDescriptor(descriptor);
  }

  @override
  OSMBitmapDescriptor fromBytes(Uint8List byteData) {
    return OSMBitmapDescriptor(
      flutter_osm_plugin.AssetMarker(
        image: AssetImage(
          'data:image/png;base64,${byteData.buffer.asUint8List()}',
        ),
      ),
    );
  }
}

class OSMBitmapDescriptor extends BitmapDescriptor {
  OSMBitmapDescriptor(this.descriptor);
  flutter_osm_plugin.AssetMarker descriptor;
}
