// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

library flutter_kakao_map;

import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart';
import 'package:flutter_kakao_map/src/method_channel/method_channel_kakao_maps_flutter.dart';
import 'package:flutter_kakao_map/src/platform_interface/kakao_maps_flutter_platform.dart';

export 'package:flutter_kakao_map/kakao_maps_flutter_platform_interface.dart'
    show
    ArgumentCallbacks,
    ArgumentCallback,
    BitmapDescriptor,
    CameraPosition,
    CameraPositionCallback,
    CameraTargetBounds,
    CameraUpdate,
    Cap,
    Circle,
    CircleId,
    InfoWindow,
    JointType,
    LatLng,
    LatLngBounds,
    MapStyleException,
    MapType,
    CurrentLocationTrackingMode,
    Marker,
    MarkerId,
    MinMaxZoomPreference,
    PatternItem,
    Polygon,
    PolygonId,
    Polyline,
    PolylineId,
    ScreenCoordinate;

part 'controller.dart';
part 'kakao_map.dart';

//typedef void KakaoMapCreatedCallback(KakaoMapController controller);
//
//class KakaoMap extends StatefulWidget {
//  const KakaoMap({
//    Key key,
//    this.onKakaoMapCreated,
//  }) : super(key: key);
//
//  final KakaoMapCreatedCallback onKakaoMapCreated;
//
//  @override
//  State<StatefulWidget> createState() => _KakaoMapState();
//}
//
//class _KakaoMapState extends State<KakaoMap> {
//  @override
//  Widget build(BuildContext context) {
//    if (defaultTargetPlatform == TargetPlatform.android) {
//      return AndroidView(
//        viewType: 'flutter_kakao_map',
//        onPlatformViewCreated: _onPlatformViewCreated,
//      );
//    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
//      return UiKitView(
//        viewType: 'flutter_kakao_map',
//        onPlatformViewCreated: _onPlatformViewCreated,
//      );
//    }
//    return Text(
//        '$defaultTargetPlatform is not yet supported by the text_view plugin');
//  }
//
//  void _onPlatformViewCreated(int id) {
//    if (widget.onKakaoMapCreated == null) {
//      return;
//    }
//    widget.onKakaoMapCreated(new KakaoMapController._(id));
//  }
//}
//
//class KakaoMapController {
//  KakaoMapController._(int id)
//      : _channel = new MethodChannel('flutter_kakao_map_$id');
//
//  final MethodChannel _channel;
//
//  Future<void> setMapCenterPoint(LatLng latLng) async {
//    assert(latLng != null);
//    return _channel.invokeMethod('setMapCenterPoint', latLng.toJson());
//  }
//}
//
//class LatLng {
//  /// Creates a geographical location specified in degrees [latitude] and
//  /// [longitude].
//  ///
//  /// The latitude is clamped to the inclusive interval from -90.0 to +90.0.
//  ///
//  /// The longitude is normalized to the half-open interval from -180.0
//  /// (inclusive) to +180.0 (exclusive)
//  const LatLng(double latitude, double longitude)
//      : assert(latitude != null),
//        assert(longitude != null),
//        latitude =
//            (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
//        longitude = (longitude + 180.0) % 360.0 - 180.0;
//
//  /// The latitude in degrees between -90.0 and 90.0, both inclusive.
//  final double latitude;
//
//  /// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
//  final double longitude;
//
//  /// Converts this object to something serializable in JSON.
//  dynamic toJson() {
//    return <double>[latitude, longitude];
//  }
//
//  /// Initialize a LatLng from an \[lat, lng\] array.
//  static LatLng fromJson(dynamic json) {
//    if (json == null) {
//      return null;
//    }
//    return LatLng(json[0], json[1]);
//  }
//
//  @override
//  String toString() => '$runtimeType($latitude, $longitude)';
//
//  @override
//  bool operator ==(Object o) {
//    return o is LatLng && o.latitude == latitude && o.longitude == longitude;
//  }
//
//  @override
//  int get hashCode => hashValues(latitude, longitude);
//}
