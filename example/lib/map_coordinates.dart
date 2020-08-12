// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';
import 'page.dart';

const CameraPosition _kInitialPosition =
    CameraPosition(target: MapPoint(37.5087553, 127.0632877), zoom: 5);

class MapCoordinatesPage extends KakaoMapExampleAppPage {
  MapCoordinatesPage() : super(const Icon(Icons.map), 'Map coordinates');

  @override
  Widget build(BuildContext context) {
    return const _MapCoordinatesBody();
  }
}

class _MapCoordinatesBody extends StatefulWidget {
  const _MapCoordinatesBody();

  @override
  State<StatefulWidget> createState() => _MapCoordinatesBodyState();
}

class _MapCoordinatesBodyState extends State<_MapCoordinatesBody> {
  _MapCoordinatesBodyState();

  KakaoMapController _controller;
  MapPoint _visibleRegion = MapPoint(37.5087553, 127.0632877);
  bool _isMapCreated = false;

  @override
  Widget build(BuildContext context) {
    final KakaoMap kakaoMap = KakaoMap(
      onMapCreated: onMapCreated,
      initialCameraPosition: _kInitialPosition,
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

    if (_isMapCreated != null) {
      final String currentVisibleRegion = 'VisibleRegion:'
          '\nnortheast: ${_visibleRegion.latitude},'
          '\nsouthwest: ${_visibleRegion.longitude}';
      columnChildren.add(Center(child: Text(currentVisibleRegion)));
      columnChildren.add(_getMapCenterPointButton());
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: columnChildren,
    );
  }

    void onMapCreated(KakaoMapController controller) {
    setState(() {
      _controller = controller;
      _isMapCreated = true;
    });
  }

  Widget _getMapCenterPointButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RaisedButton(
        child: const Text('Get Map Center Point'),
        onPressed: () async {
          final MapPoint visibleRegion =
              await _controller.getMapCenterPoint();
          setState(() {
            _visibleRegion = visibleRegion;
          });
        },
      ),
    );
  }
}
