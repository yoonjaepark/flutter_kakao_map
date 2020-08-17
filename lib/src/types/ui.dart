import 'dart:ui' show hashValues;
import 'types.dart';

// 현위치 트랙킹 타입 enumeration
enum CurrentLocationTrackingMode {
  /// 현위치 트랙킹 모드 및 나침반 모드 Off
  trackingModeOff,

  /// 현위치 트랙킹 모드 On, 단말의 위치에 따라 지도 중심이 이동한다. 나침반 모드는 꺼진 상태
  trackingModeOnWithoutHeading,

  /// 현위치 트랙킹 모드 On + 나침반 모드 On, 단말의 위치에 따라 지도 중심이 이동하며 단말의 방향에 따라 지도가 회전한다.(나침반 모드 On)
  trackingModeOnWithHeading,

  // 현위치 트랙킹 모드 On + 나침반 모드 On + 지도이동 Offm 지도중심이동을 하지 않는다. (나침반 모드 On)
  trackingOnWithHeadingWithoutMapMoving,

  trackingOnWithHeadingWithMapMoving
}

enum MapType {
  /// 기본 지도
  standard,

  /// 위성 지도
  satellite,

  /// 하이브리드 지도
  hybrid,
}

/// Bounds for the map camera target.
// Used with [KakaoMapOptions] to wrap a [LatLngBounds] value. This allows
// distinguishing between specifying an unbounded target (null `LatLngBounds`)
// from not specifying anything (null `CameraTargetBounds`).
class CameraTargetBounds {
  /// Creates a camera target bounds with the specified bounding box, or null
  /// to indicate that the camera target is not bounded.
  const CameraTargetBounds(this.bounds);

  /// The geographical bounding box for the map camera target.
  ///
  /// A null value means the camera target is unbounded.
  final LatLngBounds bounds;

  /// Unbounded camera target.
  static const CameraTargetBounds unbounded = CameraTargetBounds(null);

  /// Converts this object to something serializable in JSON.
  dynamic toJson() => <dynamic>[bounds?.toJson()];

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final CameraTargetBounds typedOther = other;
    return bounds == typedOther.bounds;
  }

  @override
  int get hashCode => bounds.hashCode;

  @override
  String toString() {
    return 'CameraTargetBounds(bounds: $bounds)';
  }
}

/// Preferred bounds for map camera zoom level.
// Used with [KakaoMapOptions] to wrap min and max zoom. This allows
// distinguishing between specifying unbounded zooming (null `minZoom` and
// `maxZoom`) from not specifying anything (null `MinMaxZoomPreference`).
class MinMaxZoomPreference {
  /// Creates a immutable representation of the preferred minimum and maximum zoom values for the map camera.
  ///
  /// [AssertionError] will be thrown if [minZoom] > [maxZoom].
  const MinMaxZoomPreference(this.minZoom, this.maxZoom)
      : assert(minZoom == null || maxZoom == null || minZoom <= maxZoom);

  /// The preferred minimum zoom level or null, if unbounded from below.
  final double minZoom;

  /// The preferred maximum zoom level or null, if unbounded from above.
  final double maxZoom;

  /// Unbounded zooming.
  static const MinMaxZoomPreference unbounded =
      MinMaxZoomPreference(null, null);

  /// Converts this object to something serializable in JSON.
  dynamic toJson() => <dynamic>[minZoom, maxZoom];

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final MinMaxZoomPreference typedOther = other;
    return minZoom == typedOther.minZoom && maxZoom == typedOther.maxZoom;
  }

  @override
  int get hashCode => hashValues(minZoom, maxZoom);

  @override
  String toString() {
    return 'MinMaxZoomPreference(minZoom: $minZoom, maxZoom: $maxZoom)';
  }
}

/// Exception when a map style is invalid or was unable to be set.
///
/// See also: `setStyle` on [KakaoMapController] for why this exception
/// might be thrown.
class MapStyleException implements Exception {
  /// Default constructor for [MapStyleException].
  const MapStyleException(this.cause);

  /// The reason `KakaoMapController.setStyle` would throw this exception.
  final String cause;
}
