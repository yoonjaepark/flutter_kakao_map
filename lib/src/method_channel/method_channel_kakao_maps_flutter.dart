// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';
import 'package:flutter_kakao_map/src/platform_interface/kakao_maps_flutter_platform.dart';
import 'package:stream_transform/stream_transform.dart';

/// An implementation of [KakaoMapsFlutterPlatform] that uses [MethodChannel] to communicate with the native code.
///
/// The `kakao_maps_flutter` plugin code itself never talks to the native code directly. It delegates
/// all those calls to an instance of a class that extends the KakaoMapsFlutterPlatform.
///
/// The architecture above allows for platforms that communicate differently with the native side
/// (like web) to have a common interface to extend.
///
/// This is the instance that runs when the native side talks to your Flutter app through MethodChannels,
/// like the Android and iOS platforms.
class MethodChannelKakaoMapsFlutter extends KakaoMapsFlutterPlatform {
  // Keep a collection of id -> channel
  // Every method call passes the int mapId
  final Map<int, MethodChannel> _channels = {};

  /// Accesses the MethodChannel associated to the passed mapId.
  MethodChannel channel(int mapId) {
    return _channels[mapId];
  }

  /// Initializes the platform interface with [id].
  ///
  /// This method is called when the plugin is first initialized.
  @override
  Future<void> init(int mapId) {
    MethodChannel channel;
    if (!_channels.containsKey(mapId)) {
      channel = MethodChannel('plugins.flutter.io/kakao_maps_$mapId');
      channel.setMethodCallHandler(
          (MethodCall call) => _handleMethodCall(call, mapId));
      _channels[mapId] = channel;
    }
    return channel.invokeMethod<void>('map#waitForMap');
  }

  // The controller we need to broadcast the different events coming
  // from handleMethodCall.
  //
  // It is a `broadcast` because multiple controllers will connect to
  // different stream views of this Controller.
  final StreamController<MapEvent> _mapEventStreamController =
      StreamController<MapEvent>.broadcast();

  // Returns a filtered view of the events in the _controller, by mapId.
  Stream<MapEvent> _events(int mapId) =>
      _mapEventStreamController.stream.where((event) => event.mapId == mapId);

  @override
  Stream<CameraMoveStartedEvent> onCameraMoveStarted({@required int mapId}) {
    return _events(mapId).whereType<CameraMoveStartedEvent>();
  }

  @override
  Stream<CameraMoveEvent> onCameraMove({@required int mapId}) {
    return _events(mapId).whereType<CameraMoveEvent>();
  }

  @override
  Stream<CameraCurrentLocationEvent> onCurrentLocationUpdate(
      {@required int mapId}) {
    return _events(mapId).whereType<CameraCurrentLocationEvent>();
  }

  @override
  Stream<MarkerSelectEvent> onMarkerSelect(
      {@required int mapId}) {
    return _events(mapId).whereType<MarkerSelectEvent>();
  }


  @override
  Stream<CameraIdleEvent> onCameraIdle({@required int mapId}) {
    return _events(mapId).whereType<CameraIdleEvent>();
  }

  @override
  Stream<MarkerTapEvent> onMarkerTap({@required int mapId}) {
    return _events(mapId).whereType<MarkerTapEvent>();
  }

  @override
  Stream<InfoWindowTapEvent> onInfoWindowTap({@required int mapId}) {
    return _events(mapId).whereType<InfoWindowTapEvent>();
  }

  @override
  Stream<MarkerDragEndEvent> onMarkerDragEnd({@required int mapId}) {
    return _events(mapId).whereType<MarkerDragEndEvent>();
  }

  @override
  Stream<PolylineTapEvent> onPolylineTap({@required int mapId}) {
    return _events(mapId).whereType<PolylineTapEvent>();
  }

  @override
  Stream<PolygonTapEvent> onPolygonTap({@required int mapId}) {
    return _events(mapId).whereType<PolygonTapEvent>();
  }

  @override
  Stream<CircleTapEvent> onCircleTap({@required int mapId}) {
    return _events(mapId).whereType<CircleTapEvent>();
  }

  @override
  Stream<MapTapEvent> onTap({@required int mapId}) {
    return _events(mapId).whereType<MapTapEvent>();
  }

  @override
  Stream<MapLongPressEvent> onLongPress({@required int mapId}) {
    return _events(mapId).whereType<MapLongPressEvent>();
  }

  Future<dynamic> _handleMethodCall(MethodCall call, int mapId) async {
    print("call.arguments['position']");
    print(call.arguments['position']);
    switch (call.method) {
      case 'camera#onMoveStarted':
        _mapEventStreamController.add(CameraMoveStartedEvent(mapId));
        break;
      case 'camera#onCurrentLocationUpdate':
        print("camera#onCurrentLocationUpdate");
        print(mapId);
        _mapEventStreamController.add(CameraCurrentLocationEvent(
          mapId,
          CameraPosition(
              target: MapPoint(call.arguments['position'][0],
                  call.arguments['position'][1])),
        ));
        break;
      case 'camera#onMove':
        print("camera#onMove");
        print(mapId);
        _mapEventStreamController.add(CameraMoveEvent(
          mapId,
          CameraPosition(
              target: MapPoint(call.arguments['position'][0],
                  call.arguments['position'][1])),
        ));
        break;
      case 'camera#onIdle':
        _mapEventStreamController.add(CameraIdleEvent(mapId));
        break;
      case 'marker#onTap':
        _mapEventStreamController.add(MarkerTapEvent(
          mapId,
          MarkerId(call.arguments['markerId']),
        ));
        break;
      case 'marker#onMarkerSelect':
        print("marker#onMarkerSelect");
        print(call.arguments);
        // print(MarkerTag(call.arguments['markerId']));
        _mapEventStreamController.add(MarkerSelectEvent(
          mapId,
          MarkerTag(target: MapPoint(call.arguments['target'][0],
                  call.arguments['target'][1]), tag: call.arguments['id'].toString()),
        ));
        break;
      case 'marker#onDragEnd':
        _mapEventStreamController.add(MarkerDragEndEvent(
          mapId,
          MapPoint.fromJson(call.arguments['position']),
          MarkerId(call.arguments['markerId']),
        ));
        break;
      case 'infoWindow#onTap':
        _mapEventStreamController.add(InfoWindowTapEvent(
          mapId,
          MarkerId(call.arguments['markerId']),
        ));
        break;
      case 'polyline#onTap':
        _mapEventStreamController.add(PolylineTapEvent(
          mapId,
          PolylineId(call.arguments['polylineId']),
        ));
        break;
      case 'polygon#onTap':
        _mapEventStreamController.add(PolygonTapEvent(
          mapId,
          PolygonId(call.arguments['polygonId']),
        ));
        break;
      case 'circle#onTap':
        _mapEventStreamController.add(CircleTapEvent(
          mapId,
          CircleId(call.arguments['circleId']),
        ));
        break;
      case 'map#onTap':
        _mapEventStreamController.add(MapTapEvent(
          mapId,
          MapPoint.fromJson(call.arguments['position']),
        ));
        break;
      case 'map#onLongPress':
        _mapEventStreamController.add(MapLongPressEvent(
          mapId,
          MapPoint.fromJson(call.arguments['position']),
        ));
        break;
      default:
        throw MissingPluginException();
    }
  }

  /// Updates configuration options of the map user interface.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  @override
  Future<void> updateMapOptions(
    Map<String, dynamic> optionsUpdate, {
    @required int mapId,
  }) {
    assert(optionsUpdate != null);
    return channel(mapId).invokeMethod<void>(
      'map#update',
      <String, dynamic>{
        'options': optionsUpdate,
      },
    );
  }

  /// Updates marker configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  @override
  Future<void> updateMarkers(
    MarkerUpdates markerUpdates, {
    @required int mapId,
  }) {
    assert(markerUpdates != null);
    return channel(mapId).invokeMethod<void>(
      'markers#update',
      markerUpdates.toJson(),
    );
  }

  /// Updates polygon configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  @override
  Future<void> updatePolygons(
    PolygonUpdates polygonUpdates, {
    @required int mapId,
  }) {
    assert(polygonUpdates != null);
    return channel(mapId).invokeMethod<void>(
      'polygons#update',
      polygonUpdates.toJson(),
    );
  }

  /// Updates polyline configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  @override
  Future<void> updatePolylines(
    PolylineUpdates polylineUpdates, {
    @required int mapId,
  }) {
    assert(polylineUpdates != null);
    return channel(mapId).invokeMethod<void>(
      'polylines#update',
      polylineUpdates.toJson(),
    );
  }

  /// Updates circle configuration.
  ///
  /// Change listeners are notified once the update has been made on the
  /// platform side.
  ///
  /// The returned [Future] completes after listeners have been notified.
  @override
  Future<void> updateCircles(
    CircleUpdates circleUpdates, {
    @required int mapId,
  }) {
    assert(circleUpdates != null);
    return channel(mapId).invokeMethod<void>(
      'circles#update',
      circleUpdates.toJson(),
    );
  }

  /// Starts an animated change of the map camera position.
  ///
  /// The returned [Future] completes after the change has been started on the
  /// platform side.
  @override
  Future<void> animateCamera(
    CameraUpdate cameraUpdate, {
    @required int mapId,
  }) {
    return channel(mapId)
        .invokeMethod<void>('camera#animate', <String, dynamic>{
      'cameraUpdate': cameraUpdate.toJson(),
    });
  }

  /// Changes the map camera position.
  ///
  /// The returned [Future] completes after the change has been made on the
  /// platform side.
  @override
  Future<void> moveCamera(
    CameraUpdate cameraUpdate, {
    @required int mapId,
  }) {
    return channel(mapId).invokeMethod<void>('camera#move', <String, dynamic>{
      'cameraUpdate': cameraUpdate.toJson(),
    });
  }

  //  @override
  // Future<void> currentLocationUpdate(
  //     CameraUpdate cameraUpdate, {
  //       @required int mapId,
  //     }) {
  //   return channel(mapId).invokeMethod<void>('camera#currentLocationUpdate', <String, dynamic>{
  //     'cameraUpdate': cameraUpdate.toJson(),
  //   });
  // }

  /// Sets the styling of the base map.
  ///
  /// Set to `null` to clear any previous custom styling.
  ///
  /// If problems were detected with the [mapStyle], including un-parsable
  /// styling JSON, unrecognized feature type, unrecognized element type, or
  /// invalid styler keys: [MapStyleException] is thrown and the current
  /// style is left unchanged.
  ///
  /// The style string can be generated using [map style tool](https://mapstyle.withgoogle.com/).
  /// Also, refer [iOS](https://developers.google.com/maps/documentation/ios-sdk/style-reference)
  /// and [Android](https://developers.google.com/maps/documentation/android-sdk/style-reference)
  /// style reference for more information regarding the supported styles.
  @override
  Future<void> setMapStyle(
    String mapStyle, {
    @required int mapId,
  }) async {
    final List<dynamic> successAndError = await channel(mapId)
        .invokeMethod<List<dynamic>>('map#setStyle', mapStyle);
    final bool success = successAndError[0];
    if (!success) {
      throw MapStyleException(successAndError[1]);
    }
  }

  /// Return the region that is visible in a map.
  @override
  Future<LatLngBounds> getVisibleRegion({
    @required int mapId,
  }) async {
    final Map<String, dynamic> latLngBounds = await channel(mapId)
        .invokeMapMethod<String, dynamic>('map#getVisibleRegion');
    final LatLng southwest = LatLng.fromJson(latLngBounds['southwest']);
    final LatLng northeast = LatLng.fromJson(latLngBounds['northeast']);

    return LatLngBounds(northeast: northeast, southwest: southwest);
  }

  /// Return point [Map<String, int>] of the [screenCoordinateInJson] in the current map view.
  ///
  /// A projection is used to translate between on screen location and geographic coordinates.
  /// Screen location is in screen pixels (not display pixels) with respect to the top left corner
  /// of the map, not necessarily of the whole screen.
  @override
  Future<ScreenCoordinate> getScreenCoordinate(
    LatLng latLng, {
    @required int mapId,
  }) async {
    final Map<String, int> point = await channel(mapId)
        .invokeMapMethod<String, int>(
            'map#getScreenCoordinate', latLng.toJson());

    return ScreenCoordinate(x: point['x'], y: point['y']);
  }

  /// Returns [LatLng] corresponding to the [ScreenCoordinate] in the current map view.
  ///
  /// Returned [LatLng] corresponds to a screen location. The screen location is specified in screen
  /// pixels (not display pixels) relative to the top left of the map, not top left of the whole screen.
  @override
  Future<LatLng> getLatLng(
    ScreenCoordinate screenCoordinate, {
    @required int mapId,
  }) async {
    final List<dynamic> latLng = await channel(mapId)
        .invokeMethod<List<dynamic>>(
            'map#getLatLng', screenCoordinate.toJson());
    return LatLng(latLng[0], latLng[1]);
  }

  /// Programmatically show the Info Window for a [Marker].
  ///
  /// The `markerId` must match one of the markers on the map.
  /// An invalid `markerId` triggers an "Invalid markerId" error.
  ///
  /// * See also:
  ///   * [hideMarkerInfoWindow] to hide the Info Window.
  ///   * [isMarkerInfoWindowShown] to check if the Info Window is showing.
  @override
  Future<void> showMarkerInfoWindow(
    MarkerId markerId, {
    @required int mapId,
  }) {
    assert(markerId != null);
    return channel(mapId).invokeMethod<void>(
        'markers#showInfoWindow', <String, String>{'markerId': markerId.value});
  }

  /// Programmatically hide the Info Window for a [Marker].
  ///
  /// The `markerId` must match one of the markers on the map.
  /// An invalid `markerId` triggers an "Invalid markerId" error.
  ///
  /// * See also:
  ///   * [showMarkerInfoWindow] to show the Info Window.
  ///   * [isMarkerInfoWindowShown] to check if the Info Window is showing.
  @override
  Future<void> hideMarkerInfoWindow(
    MarkerId markerId, {
    @required int mapId,
  }) {
    assert(markerId != null);
    return channel(mapId).invokeMethod<void>(
        'markers#hideInfoWindow', <String, String>{'markerId': markerId.value});
  }

  @override
  Future<bool> clearMapTilePersistentCache({
    @required int mapId,
  }) {
    return channel(mapId).invokeMethod<bool>('map#clearMapTilePersistentCache');
  }

  @override
  Future<bool> zoomIn({
    @required int mapId,
  }) {
    return channel(mapId).invokeMethod<bool>('map#zoomIn');
  }

  @override
  Future<bool> zoomOut({
    @required int mapId,
  }) {
    return channel(mapId).invokeMethod<bool>('map#zoomOut');
  }

  @override
  Future<MapPoint> getMapCenterPoint({
    @required int mapId,
  }) async {
    final List<dynamic> mapPoint = await channel(mapId)
        .invokeMethod<List<dynamic>>('map#getMapCenterPoint');
    return MapPoint(mapPoint[0], mapPoint[1]);
  }

  /// Returns `true` when the [InfoWindow] is showing, `false` otherwise.
  ///
  /// The `markerId` must match one of the markers on the map.
  /// An invalid `markerId` triggers an "Invalid markerId" error.
  ///
  /// * See also:
  ///   * [showMarkerInfoWindow] to show the Info Window.
  ///   * [hideMarkerInfoWindow] to hide the Info Window.
  @override
  Future<bool> isMarkerInfoWindowShown(
    MarkerId markerId, {
    @required int mapId,
  }) {
    assert(markerId != null);
    return channel(mapId).invokeMethod<bool>('markers#isInfoWindowShown',
        <String, String>{'markerId': markerId.value});
  }

  /// Returns the current zoom level of the map
  @override
  Future<double> getZoomLevel({
    @required int mapId,
  }) {
    return channel(mapId).invokeMethod<double>('map#getZoomLevel');
  }

  /// Returns the image bytes of the map
  @override
  Future<Uint8List> takeSnapshot({
    @required int mapId,
  }) {
    return channel(mapId).invokeMethod<Uint8List>('map#takeSnapshot');
  }

  /// This method builds the appropriate platform view where the map
  /// can be rendered.
  /// The `mapId` is passed as a parameter from the framework on the
  /// `onPlatformViewCreated` callback.
  @override
  Widget buildView(
      Map<String, dynamic> creationParams,
      Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers,
      PlatformViewCreatedCallback onPlatformViewCreated) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.flutter.io/kakao_maps',
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType: 'plugins.flutter.io/kakao_maps',
        onPlatformViewCreated: onPlatformViewCreated,
        gestureRecognizers: gestureRecognizers,
        creationParams: creationParams,
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the maps plugin');
  }
}
