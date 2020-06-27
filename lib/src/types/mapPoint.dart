// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show hashValues;
import 'package:meta/meta.dart';

/// A pair of latitude and longitude coordinates, stored as degrees.
class MapPoint {
  /// 지도 화면 위 한 지점을 표현할 수 있는 Point Class.
  /// 지도 화면 위의 위치와 관련된 작업을 처리할 때 항상 MapPoint 객체를 사용한다.
  /// MapPoint 객체는 위경도값(WGS84) 을 이용하여 생성하거나, 평면 좌표값(WCONG, CONG, WTM, …) 을 이용하여 생성할 수 있다.
  const MapPoint(double latitude, double longitude)
      : assert(latitude != null),
        assert(longitude != null),
        latitude =
            (latitude < -90.0 ? -90.0 : (90.0 < latitude ? 90.0 : latitude)),
        longitude = (longitude + 180.0) % 360.0 - 180.0;

  /// The latitude in degrees between -90.0 and 90.0, both inclusive.
  final double latitude;

  /// The longitude in degrees between -180.0 (inclusive) and 180.0 (exclusive).
  final double longitude;

  /// Converts this object to something serializable in JSON.
  dynamic toJson() {
    return <double>[latitude, longitude];
  }

  /// Initialize a LatLng from an \[lat, lng\] array.
  static MapPoint fromJson(dynamic json) {
    if (json == null) {
      return null;
    }
    return MapPoint(json[0], json[1]);
  }

  @override
  String toString() => '$runtimeType($latitude, $longitude)';

  @override
  bool operator ==(Object o) {
    return o is MapPoint && o.latitude == latitude && o.longitude == longitude;
  }

  @override
  int get hashCode => hashValues(latitude, longitude);
}

/// A latitude/longitude aligned rectangle.
///
/// The rectangle conceptually includes all points (lat, lng) where
/// * lat ∈ [`bottomLeft.latitude`, `topRight.latitude`]
/// * lng ∈ [`bottomLeft.longitude`, `topRight.longitude`],
///   if `bottomLeft.longitude` ≤ `topRight.longitude`,
/// * lng ∈ [-180, `topRight.longitude`] ∪ [`bottomLeft.longitude`, 180],
///   if `topRight.longitude` < `bottomLeft.longitude`
class MapPointBounds {
  /// Creates geographical bounding box with the specified corners.
  ///
  /// The latitude of the bottomLeft corner cannot be larger than the
  /// latitude of the topRight corner.
  MapPointBounds({@required this.bottomLeft, @required this.topRight})
      : assert(bottomLeft != null),
        assert(topRight != null),
        assert(bottomLeft.latitude <= topRight.latitude);

  /// The bottomLeft corner of the rectangle.
  final MapPoint bottomLeft;

  /// The topRight corner of the rectangle.
  final MapPoint topRight;

  /// Converts this object to something serializable in JSON.
  dynamic toJson() {
    return <dynamic>[bottomLeft.toJson(), topRight.toJson()];
  }

  /// Returns whether this rectangle contains the given [MapPoint].
  bool contains(MapPoint point) {
    return _containsLatitude(point.latitude) &&
        _containsLongitude(point.longitude);
  }

  bool _containsLatitude(double lat) {
    return (bottomLeft.latitude <= lat) && (lat <= topRight.latitude);
  }

  bool _containsLongitude(double lng) {
    if (bottomLeft.longitude <= topRight.longitude) {
      return bottomLeft.longitude <= lng && lng <= topRight.longitude;
    } else {
      return bottomLeft.longitude <= lng || lng <= topRight.longitude;
    }
  }

  /// Converts a list to [MapPointBounds].
  static MapPointBounds fromList(dynamic json) {
    if (json == null) {
      return null;
    }
    return MapPointBounds(
      bottomLeft: MapPoint.fromJson(json[0]),
      topRight: MapPoint.fromJson(json[1]),
    );
  }

  @override
  String toString() {
    return '$runtimeType($bottomLeft, $topRight)';
  }

  @override
  bool operator ==(Object o) {
    return o is MapPointBounds &&
        o.bottomLeft == bottomLeft &&
        o.topRight == topRight;
  }

  @override
  int get hashCode => hashValues(bottomLeft, topRight);
}
