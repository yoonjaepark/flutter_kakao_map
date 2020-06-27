// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_kakao_map/flutter_kakao_map.dart';
import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';

import 'page.dart';

const CameraPosition _kInitialPosition =
    CameraPosition(target: MapPoint(-33.852, 151.211), zoom: 11.0);

class SnapshotPage extends KakaoMapExampleAppPage {
  SnapshotPage()
      : super(const Icon(Icons.camera_alt), 'Take a snapshot of the map');

  @override
  Widget build(BuildContext context) {
    return _SnapshotBody();
  }
}

class _SnapshotBody extends StatefulWidget {
  @override
  _SnapshotBodyState createState() => _SnapshotBodyState();
}

class _SnapshotBodyState extends State<_SnapshotBody> {
  KakaoMapController _mapController;
  Uint8List _imageBytes;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 180,
            child: KakaoMap(
              onMapCreated: onMapCreated,
              initialCameraPosition: _kInitialPosition,
            ),
          ),
          FlatButton(
            child: Text('Take a snapshot'),
            onPressed: () async {
              final imageBytes = await _mapController?.takeSnapshot();
              setState(() {
                _imageBytes = imageBytes;
              });
            },
          ),
          Container(
            decoration: BoxDecoration(color: Colors.blueGrey[50]),
            height: 180,
            child: _imageBytes != null ? Image.memory(_imageBytes) : null,
          ),
        ],
      ),
    );
  }

  void onMapCreated(KakaoMapController controller) {
    _mapController = controller;
  }
}
