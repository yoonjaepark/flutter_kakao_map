// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of flutter_kakao_map;

/// Callback method for when the map is ready to be used.
///
/// Pass to [KakaoMap.onMapCreated] to receive a [KakaoMapController] when the
/// map is created.
typedef void MapCreatedCallback(KakaoMapController controller);

/// A widget which displays a map with data obtained from the Kakao Maps service.
class KakaoMap extends StatefulWidget {
  /// Creates a widget displaying data from Kakao Maps services.
  ///
  /// [AssertionError] will be thrown if [initialCameraPosition] is null;
  const KakaoMap({
    Key key,
    @required this.initialCameraPosition,
    this.onMapCreated,
    this.gestureRecognizers,
    this.compassEnabled = true,
    this.cameraTargetBounds = CameraTargetBounds.unbounded,
    this.mapType = MapType.standard,
    this.currentLocationTrackingMode =
        CurrentLocationTrackingMode.trackingModeOff,
    this.hdMapTileEnabled = true,
    this.minMaxZoomPreference = MinMaxZoomPreference.unbounded,
    this.rotateGesturesEnabled = true,
    this.scrollGesturesEnabled = true,
    this.zoomControlsEnabled = true,
    this.zoomGesturesEnabled = true,
    this.tiltGesturesEnabled = true,
    this.myLocationEnabled = false,
    this.showCurrentLocationMarker = false,
    this.myLocationButtonEnabled = true,

    /// If no padding is specified default padding will be 0.
    this.padding = const EdgeInsets.all(0),
    this.indoorViewEnabled = false,
    this.markers,
    this.onCameraMoveStarted,
    this.onCameraMove,
    this.onCurrentLocationUpdate,
    this.onCameraIdle,
    this.onMarkerSelect,
    this.onTap,
    this.onLongPress,
  })  : assert(initialCameraPosition != null),
        super(key: key);

  /// Callback method for when the map is ready to be used.
  ///
  /// Used to receive a [KakaoMapController] for this [KakaoMap].
  final MapCreatedCallback onMapCreated;

  /// 지도 카메라의 초기 위치입니다.
  final CameraPosition initialCameraPosition;

  /// True if the map should show a compass when rotated.
  final bool compassEnabled;

  /// Geographical bounding box for the camera target.
  final CameraTargetBounds cameraTargetBounds;

  /// 지도 종류
  final MapType mapType;

  /// 현위치 트랙킹 타입
  final CurrentLocationTrackingMode currentLocationTrackingMode;

  /// 고해상도 지도 타일 사용 여부를 설정한다.
  final bool hdMapTileEnabled;

  /// Preferred bounds for the camera zoom level.
  ///
  /// Actual bounds depend on map data and device.
  final MinMaxZoomPreference minMaxZoomPreference;

  /// True if the map view should respond to rotate gestures.
  final bool rotateGesturesEnabled;

  /// True if the map view should respond to scroll gestures.
  final bool scrollGesturesEnabled;

  /// True if the map view should show zoom controls. This includes two buttons
  /// to zoom in and zoom out. The default value is to show zoom controls.
  ///
  /// This is only supported on Android. And this field is silently ignored on iOS.
  final bool zoomControlsEnabled;

  /// True if the map view should respond to zoom gestures.
  final bool zoomGesturesEnabled;

  /// True if the map view should respond to tilt gestures.
  final bool tiltGesturesEnabled;

  /// Padding to be set on map. See https://developers.google.com/maps/documentation/android-sdk/map#map_padding for more details.
  final EdgeInsets padding;

  /// Markers to be placed on the map.
  final Set<Marker> markers;

  /// Called when the camera starts moving.
  ///
  /// This can be initiated by the following:
  /// 1. Non-gesture animation initiated in response to user actions.
  ///    For example: zoom buttons, my location button, or marker clicks.
  /// 2. Programmatically initiated animation.
  /// 3. Camera motion initiated in response to user gestures on the map.
  ///    For example: pan, tilt, pinch to zoom, or rotate.
  final VoidCallback onCameraMoveStarted;

  /// 지도 중심 좌표가 이동한 경우 호출된다.
  final CameraPositionCallback onCameraMove;

  /// CurrentLocationEventListener interface를 구현하는 객체를 MapView 객체에 등록하여
  /// 현위치 트래킹 이벤트를 통보받을 수 있다.
  final CameraPositionCallback onCurrentLocationUpdate;

  //단말 사용자가 POI Item을 선택한 경우 호출된다.
  // 사용자가 MapView 에 등록된 POI Item 아이콘(마커)를 터치한 경우 호출된다.
  final MarkerSelectCallback onMarkerSelect;

  /// Called when camera movement has ended, there are no pending
  /// animations and the user has stopped interacting with the map.
  final VoidCallback onCameraIdle;

  /// 사용자가 지도 위를 터치한 경우 호출된다.
  final ArgumentCallback<MapPoint> onTap;

  /// 사용자가 지도 위 한 지점을 길게 누른 경우(long press) 호출된다.
  final ArgumentCallback<MapPoint> onLongPress;

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
  final bool myLocationEnabled;
  final bool showCurrentLocationMarker;

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
  final bool myLocationButtonEnabled;

  /// Enables or disables the indoor view from the map
  final bool indoorViewEnabled;

  /// Which gestures should be consumed by the map.
  ///
  /// It is possible for other gesture recognizers to be competing with the map on pointer
  /// events, e.g if the map is inside a [ListView] the [ListView] will want to handle
  /// vertical drags. The map will claim gestures that are recognized by any of the
  /// recognizers on this list.
  ///
  /// When this set is empty or null, the map will only handle pointer events for gestures that
  /// were not claimed by any other gesture recognizer.
  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers;

  /// Creates a [State] for this [KakaoMap].
  @override
  State createState() => _KakaoMapState();
}

class _KakaoMapState extends State<KakaoMap> {
  final Completer<KakaoMapController> _controller =
      Completer<KakaoMapController>();

  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  _KakaoMapOptions _kakaoMapOptions;

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> creationParams = <String, dynamic>{
      'initialCameraPosition': widget.initialCameraPosition?.toMap(),
      'options': _kakaoMapOptions.toMap(),
      'markersToAdd': serializeMarkerSet(widget.markers),
    };
    return _kakaoMapsFlutterPlatform.buildView(
      creationParams,
      widget.gestureRecognizers,
      onPlatformViewCreated,
    );
  }

  @override
  void initState() {
    super.initState();
    _kakaoMapOptions = _KakaoMapOptions.fromWidget(widget);
    _markers = keyByMarkerId(widget.markers);
  }

  @override
  void didUpdateWidget(KakaoMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateOptions();
    _updateMarkers();
  }

  void _updateOptions() async {
    final _KakaoMapOptions newOptions = _KakaoMapOptions.fromWidget(widget);
    final Map<String, dynamic> updates =
        _kakaoMapOptions.updatesMap(newOptions);
    if (updates.isEmpty) {
      return;
    }
    final KakaoMapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateMapOptions(updates);
    _kakaoMapOptions = newOptions;
  }

  void _updateMarkers() async {
    final KakaoMapController controller = await _controller.future;
    // ignore: unawaited_futures
    controller._updateMarkers(
        MarkerUpdates.from(_markers.values.toSet(), widget.markers));
    _markers = keyByMarkerId(widget.markers);
  }

  Future<void> onPlatformViewCreated(int id) async {
    final KakaoMapController controller = await KakaoMapController.init(
      id,
      widget.initialCameraPosition,
      this,
    );
    _controller.complete(controller);
    if (widget.onMapCreated != null) {
      widget.onMapCreated(controller);
    }
  }

  void onMarkerTap(MarkerId markerId) {
    assert(markerId != null);
    if (_markers[markerId]?.onTap != null) {
      _markers[markerId].onTap();
    }
  }

  void onMarkerDragEnd(MarkerId markerId, MapPoint position) {
    assert(markerId != null);
    if (_markers[markerId]?.onDragEnd != null) {
      _markers[markerId].onDragEnd(position);
    }
  }

  void onInfoWindowTap(MarkerId markerId) {
    assert(markerId != null);
    if (_markers[markerId]?.infoWindow?.onTap != null) {
      _markers[markerId].infoWindow.onTap();
    }
  }

  void onTap(MapPoint position) {
    assert(position != null);
    if (widget.onTap != null) {
      widget.onTap(position);
    }
  }

  void onLongPress(MapPoint position) {
    assert(position != null);
    if (widget.onLongPress != null) {
      widget.onLongPress(position);
    }
  }
}

/// Configuration options for the KakaoMaps user interface.
///
/// When used to change configuration, null values will be interpreted as
/// "do not change this configuration option".
class _KakaoMapOptions {
  _KakaoMapOptions(
      {this.compassEnabled,
      this.cameraTargetBounds,
      this.mapType,
      this.currentLocationTrackingMode,
      this.hdMapTileEnabled,
      this.minMaxZoomPreference,
      this.rotateGesturesEnabled,
      this.scrollGesturesEnabled,
      this.tiltGesturesEnabled,
      this.trackCameraPosition,
      this.zoomControlsEnabled,
      this.zoomGesturesEnabled,
      this.myLocationEnabled,
      this.myLocationButtonEnabled,
      this.padding,
      this.indoorViewEnabled});

  static _KakaoMapOptions fromWidget(KakaoMap map) {
    return _KakaoMapOptions(
      compassEnabled: map.compassEnabled,
      cameraTargetBounds: map.cameraTargetBounds,
      mapType: map.mapType,
      currentLocationTrackingMode: map.currentLocationTrackingMode,
      hdMapTileEnabled: map.hdMapTileEnabled,
      minMaxZoomPreference: map.minMaxZoomPreference,
      rotateGesturesEnabled: map.rotateGesturesEnabled,
      scrollGesturesEnabled: map.scrollGesturesEnabled,
      tiltGesturesEnabled: map.tiltGesturesEnabled,
      trackCameraPosition: map.onCameraMove != null,
      zoomControlsEnabled: map.zoomControlsEnabled,
      zoomGesturesEnabled: map.zoomGesturesEnabled,
      myLocationEnabled: map.myLocationEnabled,
      myLocationButtonEnabled: map.myLocationButtonEnabled,
      padding: map.padding,
      indoorViewEnabled: map.indoorViewEnabled,
    );
  }

  final bool compassEnabled;

  final CameraTargetBounds cameraTargetBounds;

  final MapType mapType;

  final CurrentLocationTrackingMode currentLocationTrackingMode;

  final bool hdMapTileEnabled;

  final MinMaxZoomPreference minMaxZoomPreference;

  final bool rotateGesturesEnabled;

  final bool scrollGesturesEnabled;

  final bool tiltGesturesEnabled;

  final bool trackCameraPosition;

  final bool zoomControlsEnabled;

  final bool zoomGesturesEnabled;

  final bool myLocationEnabled;

  final bool myLocationButtonEnabled;

  final EdgeInsets padding;

  final bool indoorViewEnabled;

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> optionsMap = <String, dynamic>{};

    void addIfNonNull(String fieldName, dynamic value) {
      if (value != null) {
        optionsMap[fieldName] = value;
      }
    }

    addIfNonNull('compassEnabled', compassEnabled);
    addIfNonNull('cameraTargetBounds', cameraTargetBounds?.toJson());
    addIfNonNull('mapType', mapType?.index);
    addIfNonNull(
        'currentLocationTrackingMode', currentLocationTrackingMode?.index);
    addIfNonNull('hdMapTile', hdMapTileEnabled);
    addIfNonNull('minMaxZoomPreference', minMaxZoomPreference?.toJson());
    addIfNonNull('rotateGesturesEnabled', rotateGesturesEnabled);
    addIfNonNull('scrollGesturesEnabled', scrollGesturesEnabled);
    addIfNonNull('tiltGesturesEnabled', tiltGesturesEnabled);
    addIfNonNull('zoomControlsEnabled', zoomControlsEnabled);
    addIfNonNull('zoomGesturesEnabled', zoomGesturesEnabled);
    addIfNonNull('trackCameraPosition', trackCameraPosition);
    addIfNonNull('myLocationEnabled', myLocationEnabled);
    addIfNonNull('myLocationButtonEnabled', myLocationButtonEnabled);
    addIfNonNull('padding', <double>[
      padding?.top,
      padding?.left,
      padding?.bottom,
      padding?.right,
    ]);
    addIfNonNull('indoorEnabled', indoorViewEnabled);
    return optionsMap;
  }

  Map<String, dynamic> updatesMap(_KakaoMapOptions newOptions) {
    final Map<String, dynamic> prevOptionsMap = toMap();

    return newOptions.toMap()
      ..removeWhere(
          (String key, dynamic value) => prevOptionsMap[key] == value);
  }
}
