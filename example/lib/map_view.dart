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
  KakaoMapController _controller;
  MapPoint _centerMapPoint = const MapPoint(0, 0);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
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
        setState(() {
          _centerMapPoint = mapPoint;
        });
      },
      child: const Text('getMapCenterPoint'),
    );
  }

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
              Text('center: ${_centerMapPoint.latitude.toStringAsFixed(4)}, ${_centerMapPoint.longitude.toStringAsFixed(4)}'),
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

  void _updateCameraPosition(CameraPosition position) {
    setState(() {
      _position = position;
    });
  }

  void _onCurrentLocationUpdate(CameraPosition position) {
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
