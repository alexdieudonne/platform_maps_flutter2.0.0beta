import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_osm_interface/flutter_osm_interface.dart';
import 'package:platform_maps_flutter_osm_android/src/mapper_extensions.dart';
import 'package:platform_maps_flutter_osm_android/src/osm_bitmap_descriptor.dart';
import 'package:platform_maps_flutter_platform_interface/platform_maps_flutter_platform_interface.dart';

import 'package:flutter_osm_plugin/flutter_osm_plugin.dart'
    as flutter_osm_plugin;

class OSMWidget extends PlatformMapsPlatformWidget {
  OSMWidget(PlatformMapsPlatformWidgetCreationParams params)
      : super.implementation(params);

  @override
  Widget build(BuildContext context) {
    return _PlatformMap(params: params);
  }
}

class _PlatformMap extends StatefulWidget {
  const _PlatformMap({
    required this.params,
  });

  final PlatformMapsPlatformWidgetCreationParams params;

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [OsmMapController] for this [OSMFlutter].
  MapCreatedCallback? get onMapCreated => params.onMapCreated;

  /// The initial position of the map's camera.
  CameraPosition get initialCameraPosition => params.initialCameraPosition;

  /// True if the map should show a compass when rotated.
  bool get compassEnabled => params.compassEnabled;

  /// Type of map tiles to be rendered.
  MapType get mapType => params.mapType;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  MinMaxZoomPreference get minMaxZoomPreference => params.minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  bool get rotateGesturesEnabled => params.rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  bool get scrollGesturesEnabled => params.scrollGesturesEnabled;

  /// True if the map view should show zoom controls. This includes two buttons
  /// to zoom in and zoom out. The default value is to show zoom controls.
  ///
  /// This is only supported on Android. And this field is silently ignored on iOS.
  bool get zoomControlsEnabled => params.zoomControlsEnabled;

  /// True if the map view should respond to zoom gestures.
  bool get zoomGesturesEnabled => params.zoomGesturesEnabled;

  /// True if the map view should respond to tilt gestures.
  bool get tiltGesturesEnabled => params.tiltGesturesEnabled;

  EdgeInsets get padding => params.padding;

  /// Markers to be placed on the map.
  Set<Marker> get markers => params.markers;

  /// Polygons to be placed on the map.
  Set<Polygon> get polygons => params.polygons;

  /// Polylines to be placed on the map.
  Set<Polyline> get polylines => params.polylines;

  /// Circles to be placed on the map.
  Set<Circle> get circles => params.circles;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  VoidCallback? get onCameraMoveStarted => params.onCameraMoveStarted;

  /// Called repeatedly as the camera continues to move after an
  /// onCameraMoveStarted call.
  ///
  /// This may be called as often as once every frame and should
  /// not perform expensive operations.
  CameraPositionCallback? get onCameraMove => params.onCameraMove;

  /// Called when camera movement has ended, there are no pending
  /// animations and the user has stopped interacting with the map.
  VoidCallback? get onCameraIdle => params.onCameraIdle;

  ArgumentCallback<LatLng>? get onTap => params.onTap;

  ArgumentCallback<LatLng>? get onLongPress => params.onLongPress;

  /// True if a "My Location" layer should be shown on the map.
  ///
  /// This layer includes a location indicator at the current device location,
  /// as well as a My Location button.
  /// * The indicator is a small blue dot if the device is stationary, or a
  /// chevron if the device is moving.
  /// * The My Location button animates to focus on the user's current location
  /// if the user's location is currently known.
  ///
  /// Enabling this feature requires adding location permissions to both native
  /// platforms of your app.
  /// * On Android add either
  /// `<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />`
  /// or `<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />`
  /// to your `AndroidManifest.xml` file. `ACCESS_COARSE_LOCATION` returns a
  /// location with an accuracy approximately equivalent to a city block, while
  /// `ACCESS_FINE_LOCATION` returns as precise a location as possible, although
  /// it consumes more battery power. You will also need to request these
  /// permissions during run-time. If they are not granted, the My Location
  /// feature will fail silently.
  /// * On iOS add a `NSLocationWhenInUseUsageDescription` key to your
  /// `Info.plist` file. This will automatically prompt the user for permissions
  /// when the map tries to turn on the My Location layer.
  bool get myLocationEnabled => params.myLocationEnabled;

  /// Enables or disables the my-location button.
  ///
  /// The my-location button causes the camera to move such that the user's
  /// location is in the center of the map. If the button is enabled, it is
  /// only shown when the my-location layer is enabled.
  ///
  /// By default, the my-location button is enabled (and hence shown when the
  /// my-location layer is enabled).
  ///
  /// See also:
  ///   * [myLocationEnabled] parameter.
  bool get myLocationButtonEnabled => params.myLocationButtonEnabled;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  @override
  _PlatformMapState createState() => _PlatformMapState();
}

class _PlatformMapState extends State<_PlatformMap> {
  flutter_osm_plugin.MapController mapController =
      flutter_osm_plugin.MapController.withPosition(
    initPosition: flutter_osm_plugin.GeoPoint(
      latitude: 51.5160895,
      longitude: -0.1294527,
    ),
  );

  bool _isMapReady = false;
  bool _isUserTracked = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    mapController.listenerMapSingleTapping.removeListener(() {});
    mapController.listenerMapLongTapping.removeListener(() {});
    mapController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _PlatformMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (_isMapReady) {
      if (widget.myLocationEnabled) {
        mapController.enableTracking(useDirectionMarker: true);
      } else {
        mapController.disabledTracking();
      }

      // Handle changes in circles
      if (widget.circles != oldWidget.circles) {
        _updateCircles();
      }

      // Handle changes in markers
      if (widget.markers != oldWidget.markers) {
        _updateMarkers();
      }

      // Handle changes in polylines
      if (widget.polylines != oldWidget.polylines) {
        _updatePolylines();
      }
    } else {
      debugPrint('Map is not ready for updates.');
    }
  }

  void _updateCircles() {
    mapController.removeAllShapes(); // Clear existing circles
    _addCirclesToMap(widget.circles.osmCircleSet);
  }

  void _updateMarkers() {
    mapController
        .removeMarkers(widget.markers.osmMarkerList); // Clear existing markers
    _addMarkersToMap(widget.markers);
  }

  void _updatePolylines() {
    mapController.clearAllRoads(); // Clear existing polylines
    _drawPolylines(widget.polylines);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        flutter_osm_plugin.OSMFlutter(
            controller: mapController,
            onMapMoved: _onCameraMove,
            onMapIsReady: mapIsReady,
            onGeoPointClicked: _onTap,
            osmOption: flutter_osm_plugin.OSMOption(
              enableRotationByGesture: widget.rotateGesturesEnabled,
              zoomOption: widget.minMaxZoomPreference.osmZoomPreference,
              showZoomController: widget.zoomControlsEnabled,
            )),
        // button location
        if (widget.myLocationButtonEnabled)
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: _redirectCameraToPosition,
              child: Icon(Icons.my_location,
                  color: _isUserTracked ? Colors.blue : Colors.black),
            ),
          ),
      ],
    );
  }

  void _redirectCameraToPosition() async {
    if (!_isUserTracked) {
      await mapController.currentLocation();
      await mapController.enableTracking(
        enableStopFollow: false,
        useDirectionMarker: true,
      );
    } else {
      await mapController.disabledTracking();
    }
    setState(() {
      _isUserTracked = !_isUserTracked;
    });
  }

  void _drawPolylines(Set<Polyline> polylines) async {
    for (final Polyline polyline in polylines) {
      await mapController.drawRoadManually(
        polyline.osmPolyline,
        RoadOption(
          roadColor: polyline.color,
          roadWidth: polyline.width.toDouble(),
        ),
      );
    }
  }

  void _addMarkersToMap(Set<Marker> markers) async {
    for (Marker marker in markers) {
      OSMBitmapDescriptor? icon = marker.icon as OSMBitmapDescriptor?;
      AssetMarker? assetMarker = icon?.descriptor;
      mapController.addMarker(
        marker.osmGeoPoint,
        markerIcon: MarkerIcon(
          assetMarker: assetMarker != null
              ? AssetMarker(
                  image: assetMarker.image,
                  scaleAssetImage: assetMarker.scaleAssetImage,
                )
              : null,
        ),
      );
    }
  }

  void _addCirclesToMap(Set<flutter_osm_plugin.CircleOSM> circles) {
    for (final flutter_osm_plugin.CircleOSM circle in circles) {
      mapController.drawCircle(circle);
    }
  }

  void _onMapCreated(flutter_osm_plugin.MapController controller) {
    widget.onMapCreated?.call(controller.platformMapController);
  }

  void _onTap(flutter_osm_plugin.GeoPoint position) {
    widget.onTap?.call(position.platformLatLng);
  }

  Future<void> mapIsReady(bool isReady) async {
    if (isReady) {
      _isMapReady = true;
      // Trigger map creation callback
      _onMapCreated(mapController);
      try {
        if (widget.myLocationEnabled) {
          await mapController.enableTracking(
            enableStopFollow: false,
            useDirectionMarker: true,
          );
        } else {
          // Set initial zoom level
          await mapController.setZoom(
            zoomLevel: widget.initialCameraPosition.zoom,
          );

          // Move camera to the initial position
          await mapController.moveTo(
            widget.initialCameraPosition.osmCameraPosition,
            animate: false,
          );
        }

        // Add circles, markers, and polylines to the map
        _addCirclesToMap(widget.circles.osmCircleSet);
        _addMarkersToMap(widget.markers);
        _drawPolylines(widget.polylines);
      } catch (e, stackTrace) {
        // Log or handle initialization errors
        debugPrint('Error during map initialization: $e');
        debugPrint(stackTrace.toString());
      }
    }
  }

  void _onCameraMove(flutter_osm_plugin.Region cameraPosition) async {
    double zoom = await mapController.getZoom();
    widget.onCameraMove?.call(
      CameraPosition(
        zoom: zoom,
        target: LatLng(
          cameraPosition.center.latitude,
          cameraPosition.center.longitude,
        ),
      ),
    );
  }

  void _onLongPress(flutter_osm_plugin.GeoPoint position) {
    widget.onLongPress?.call(LatLng(position.latitude, position.longitude));
  }
}
