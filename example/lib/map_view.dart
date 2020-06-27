// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';

import 'page.dart';

final LatLngBounds sydneyBounds = LatLngBounds(
  southwest: const LatLng(-34.022631, 150.620685),
  northeast: const LatLng(-33.571835, 151.325952),
);

class MapViewPage extends KakaoMapExampleAppPage {
  MapViewPage() : super(const Icon(Icons.map), 'Mapview');

  @override
  Widget build(BuildContext context) {
    return const MapViewBody();
  }
}

class MapViewBody extends StatefulWidget {
  const MapViewBody();

  @override
  State<StatefulWidget> createState() => MapViewBodyState();
}

class MapViewBodyState extends State<MapViewBody> {
  MapViewBodyState();

  static final CameraPosition _kInitialPosition = const CameraPosition(
    target: MapPoint(37.5087553, 127.0632877),
    zoom: 5,
  );
  CameraPosition _position = _kInitialPosition;
  CameraPosition _currenPosition = const CameraPosition(
    target: MapPoint(0, 0),
    zoom: 5,
  );
  bool _isMapCreated = false;
  bool _myLocationEnabled = true;
  bool _compassEnabled = true;
  MapType _mapType = MapType.standard;
  CurrentLocationTrackingMode _currentLocationTrackingMode =
      CurrentLocationTrackingMode.trackingModeOff;
  bool _hDMapTileEnabled = true;
  bool _myLocationButtonEnabled = true;
  KakaoMapController _controller;

  bool _isMoving = false;
  bool _mapToolbarEnabled = true;
  CameraTargetBounds _cameraTargetBounds = CameraTargetBounds.unbounded;
  MinMaxZoomPreference _minMaxZoomPreference = MinMaxZoomPreference.unbounded;
  bool _rotateGesturesEnabled = true;
  bool _scrollGesturesEnabled = true;
  bool _tiltGesturesEnabled = true;
  bool _zoomControlsEnabled = false;
  bool _zoomGesturesEnabled = true;
  bool _indoorViewEnabled = true;
  bool _myTrafficEnabled = false;
  bool _nightMode = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget _compassToggler() {
    return FlatButton(
      child: Text('${_compassEnabled ? 'disable' : 'enable'} compass'),
      onPressed: () {
        setState(() {
          _compassEnabled = !_compassEnabled;
        });
      },
    );
  }

  Widget _hDMapTileToggler() {
    return FlatButton(
      child: Text('${_hDMapTileEnabled ? 'disable' : 'enable'} map HDMapTile'),
      onPressed: () {
        setState(() {
          _hDMapTileEnabled = !_hDMapTileEnabled;
        });
      },
    );
  }

  Widget _mapTypeCycler() {
    final MapType nextType =
        MapType.values[(_mapType.index + 1) % MapType.values.length];
    return FlatButton(
      child: Text('change map type to $nextType'),
      onPressed: () {
        setState(() {
          _mapType = nextType;
        });
      },
    );
  }

  Widget _currentLocationTrackingModeCycler() {
    final CurrentLocationTrackingMode nextType =
        CurrentLocationTrackingMode.values[
            (_currentLocationTrackingMode.index + 1) %
                CurrentLocationTrackingMode.values.length];
    return FlatButton(
      child: Text('$nextType'),
      onPressed: () {
        setState(() {
          _currentLocationTrackingMode = nextType;
        });
      },
    );
  }

  Widget _clearMapTilePersistentCache() {
    return FlatButton(
      child: Text("Clear Map tile"),
      onPressed: () {
        _controller.clearMapTilePersistentCache();
      },
    );
  }

  Widget _zoomIn() {
    return FlatButton(
      onPressed: () {
        _controller.zoomIn();
      },
      child: const Text('zoomIn'),
    );
  }

  Widget _zoomOut() {
    return FlatButton(
      onPressed: () {
        _controller.zoomOut();
      },
      child: const Text('zoomOut'),
    );
  }

  Widget _getMapCenterPoint() {
    return FlatButton(
      onPressed: () async {
        final MapPoint mapPoint = await _controller.getMapCenterPoint();
        print(mapPoint);
      },
      child: const Text('getMapCenterPoint'),
    );
  }

  Widget _myLocationButtonToggler() {
    return FlatButton(
      child: Text(
          '${_myLocationButtonEnabled ? 'disable' : 'enable'} my location button'),
      onPressed: () {
        setState(() {
          _myLocationButtonEnabled = !_myLocationButtonEnabled;
        });
      },
    );
  }

  // Widget _mapToolbarToggler() {
  //   return FlatButton(
  //     child: Text('${_mapToolbarEnabled ? 'disable' : 'enable'} map toolbar'),
  //     onPressed: () {
  //       setState(() {
  //         _mapToolbarEnabled = !_mapToolbarEnabled;
  //       });
  //     },
  //   );
  // }

  // Widget _latLngBoundsToggler() {
  //   return FlatButton(
  //     child: Text(
  //       _cameraTargetBounds.bounds == null
  //           ? 'bound camera target'
  //           : 'release camera target',
  //     ),
  //     onPressed: () {
  //       setState(() {
  //         _cameraTargetBounds = _cameraTargetBounds.bounds == null
  //             ? CameraTargetBounds(sydneyBounds)
  //             : CameraTargetBounds.unbounded;
  //       });
  //     },
  //   );
  // }

  // Widget _zoomBoundsToggler() {
  //   return FlatButton(
  //     child: Text(_minMaxZoomPreference.minZoom == null
  //         ? 'bound zoom'
  //         : 'release zoom'),
  //     onPressed: () {
  //       setState(() {
  //         _minMaxZoomPreference = _minMaxZoomPreference.minZoom == null
  //             ? const MinMaxZoomPreference(12.0, 16.0)
  //             : MinMaxZoomPreference.unbounded;
  //       });
  //     },
  //   );
  // }

  // Widget _rotateToggler() {
  //   return FlatButton(
  //     child: Text('${_rotateGesturesEnabled ? 'disable' : 'enable'} rotate'),
  //     onPressed: () {
  //       setState(() {
  //         _rotateGesturesEnabled = !_rotateGesturesEnabled;
  //       });
  //     },
  //   );
  // }

  // Widget _scrollToggler() {
  //   return FlatButton(
  //     child: Text('${_scrollGesturesEnabled ? 'disable' : 'enable'} scroll'),
  //     onPressed: () {
  //       setState(() {
  //         _scrollGesturesEnabled = !_scrollGesturesEnabled;
  //       });
  //     },
  //   );
  // }

  // Widget _tiltToggler() {
  //   return FlatButton(
  //     child: Text('${_tiltGesturesEnabled ? 'disable' : 'enable'} tilt'),
  //     onPressed: () {
  //       setState(() {
  //         _tiltGesturesEnabled = !_tiltGesturesEnabled;
  //       });
  //     },
  //   );
  // }

  // Widget _zoomToggler() {
  //   return FlatButton(
  //     child: Text('${_zoomGesturesEnabled ? 'disable' : 'enable'} zoom'),
  //     onPressed: () {
  //       setState(() {
  //         _zoomGesturesEnabled = !_zoomGesturesEnabled;
  //       });
  //     },
  //   );
  // }

  // Widget _zoomControlsToggler() {
  //   return FlatButton(
  //     child:
  //         Text('${_zoomControlsEnabled ? 'disable' : 'enable'} zoom controls'),
  //     onPressed: () {
  //       setState(() {
  //         _zoomControlsEnabled = !_zoomControlsEnabled;
  //       });
  //     },
  //   );
  // }

  // Widget _indoorViewToggler() {
  //   return FlatButton(
  //     child: Text('${_indoorViewEnabled ? 'disable' : 'enable'} indoor'),
  //     onPressed: () {
  //       setState(() {
  //         _indoorViewEnabled = !_indoorViewEnabled;
  //       });
  //     },
  //   );
  // }

  // Widget _myLocationToggler() {
  //   return FlatButton(
  //     child: Text(
  //         '${_myLocationButtonEnabled ? 'disable' : 'enable'} my location button'),
  //     onPressed: () {
  //       setState(() {
  //         _myLocationEnabled = !_myLocationEnabled;
  //       });
  //     },
  //   );
  // }

  // Widget _myTrafficToggler() {
  //   return FlatButton(
  //     child: Text('${_myTrafficEnabled ? 'disable' : 'enable'} my traffic'),
  //     onPressed: () {
  //       setState(() {
  //         _myTrafficEnabled = !_myTrafficEnabled;
  //       });
  //     },
  //   );
  // }

  // Future<String> _getFileData(String path) async {
  //   return await rootBundle.loadString(path);
  // }

  // void _setMapStyle(String mapStyle) {
  //   setState(() {
  //     _nightMode = true;
  //     _controller.setMapStyle(mapStyle);
  //   });
  // }

  // Widget _nightModeToggler() {
  //   if (!_isMapCreated) {
  //     return null;
  //   }
  //   return FlatButton(
  //     child: Text('${_nightMode ? 'disable' : 'enable'} night mode'),
  //     onPressed: () {
  //       if (_nightMode) {
  //         setState(() {
  //           _nightMode = false;
  //           _controller.setMapStyle(null);
  //         });
  //       } else {
  //         _getFileData('assets/night_mode.json').then(_setMapStyle);
  //       }
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    final KakaoMap kakaoMap = KakaoMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
      compassEnabled: _compassEnabled,
      mapType: _mapType,
      hdMapTileEnabled: _hDMapTileEnabled,
      currentLocationTrackingMode: _currentLocationTrackingMode,
      myLocationEnabled: _myLocationEnabled,
      onCameraMove: _updateCameraPosition,
      onCurrentLocationUpdate: _onCurrentLocationUpdate,

      // mapToolbarEnabled: _mapToolbarEnabled,
      // cameraTargetBounds: _cameraTargetBounds,
      // minMaxZoomPreference: _minMaxZoomPreference,

      // rotateGesturesEnabled: _rotateGesturesEnabled,
      // scrollGesturesEnabled: _scrollGesturesEnabled,
      // tiltGesturesEnabled: _tiltGesturesEnabled,
      // zoomGesturesEnabled: _zoomGesturesEnabled,
      // zoomControlsEnabled: _zoomControlsEnabled,
      // indoorViewEnabled: _indoorViewEnabled,
      // myLocationButtonEnabled: _myLocationButtonEnabled,
      // trafficEnabled: _myTrafficEnabled,
    );

    final List<Widget> columnChildren = <Widget>[
      Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: kakaoMap,
          ),
        ),
      ),
    ];

    if (_isMapCreated) {
      columnChildren.add(
        Expanded(
          child: ListView(
            children: <Widget>[
              // Text('camera bearing: ${_position.bearing}'),
              Text(
                  'camera target: ${_position.target.latitude.toStringAsFixed(4)},'
                  '${_position.target.longitude.toStringAsFixed(4)}'),
              Text('camera zoom: ${_position.zoom}'),
              Text(
                  'current: ${_currenPosition.target.latitude.toStringAsFixed(4)},'
                  '${_currenPosition.target.longitude.toStringAsFixed(4)}'),
              _mapTypeCycler(),
              _hDMapTileToggler(),
              _clearMapTilePersistentCache(),
              _zoomIn(),
              _zoomOut(),
              _currentLocationTrackingModeCycler(),
              _getMapCenterPoint(),
              _myLocationButtonToggler(),
              // Text(_isMoving ? '(Camera moving)' : '(Camera idle)'),
              // _compassToggler(),
              // _mapToolbarToggler(),
              // _latLngBoundsToggler(),
              // _zoomBoundsToggler(),
              // _rotateToggler(),
              // _scrollToggler(),
              // _tiltToggler(),
              // _zoomToggler(),
              // _zoomControlsToggler(),
              // _indoorViewToggler(),
              // _myLocationToggler(),
              // _myTrafficToggler(),
              // _nightModeToggler(),
            ],
          ),
        ),
      );
    }
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );
  }

// StreamSubscription<OrientationEvent> _orientationEventSubscription;

// _orientationEventSubscription = orientationEvents.listen((OrientationEvent event) {
//     // orientation event occurred!
// });

  void _updateCameraPosition(CameraPosition position) {
    print("cxzkmcmzlkcml ${position.toString()}");
    setState(() {
      _position = position;
    });
  }

  void _onCurrentLocationUpdate(CameraPosition position) {
    print("_onCurrentLocationUpdate ${position.toString()}");
    setState(() {
      _currenPosition = position;
    });
  }

  void onMapCreated(KakaoMapController controller) {
    setState(() {
      _controller = controller;
      _isMapCreated = true;
    });
  }
}
