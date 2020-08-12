// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:ui' show hashValues, Offset;

import 'package:flutter/foundation.dart' show ValueChanged, VoidCallback;
import 'package:meta/meta.dart' show immutable, required;

import 'types.dart';

dynamic _offsetToJson(Offset offset) {
  if (offset == null) {
    return null;
  }
  return <dynamic>[offset.dx, offset.dy];
}


// POI Item 아이콘(마커) 타입
enum MarkerType {
  /// 파란색 핀 
  markerTypeBluePin,

  /// 빨간색 핀
  markerTypeRedPin,

  /// 노란색 핀
  markerTypeYellowPin,

  // 개발자가 지정한 POI Item 아이콘 이미지 사용
  markerTypeCustomImage,
}

enum MarkerSelectedType {
  /// 선택 효과를 사용하지 않음
  markerSelectedTypeNone,

  /// 파란색 핀 
  markerSelectedTypeBluePin,

  /// 빨간색 핀
  markerSelectedTypeRedPin,

  /// 노란색 핀
  markerSelectedTypeYellowPin,

  /// 개발자가 지정한 POI Item 아이콘 이미지 사용
  markerSelectedTypeCustomImage,
}

enum ShowAnimationType {
  /// 애니메이션 없음
  showAnimationTypeNoAnimation,

  /// POI Item 아이콘이 하늘에서 지도 위로 떨어지는 애니매이션
  showAnimationTypeDropFromHeaven,

  /// POI Item 아이콘이 땅위에서 스프링처럼 튀어나오는 듯한 애니매이션
  showAnimationTypeSpringFromGround
}

/// Text labels for a [Marker] info window.
class InfoWindow {
  /// Creates an immutable representation of a label on for [Marker].
  const InfoWindow({
    this.title,
    this.snippet,
    this.anchor = const Offset(0.5, 0.0),
    this.onTap,
  });

  /// Text labels specifying that no text is to be displayed.
  static const InfoWindow noText = InfoWindow();

  /// Text displayed in an info window when the user taps the marker.
  ///
  /// A null value means no title.
  final String title;

  /// Additional text displayed below the [title].
  ///
  /// A null value means no additional text.
  final String snippet;

  /// The icon image point that will be the anchor of the info window when
  /// displayed.
  ///
  /// The image point is specified in normalized coordinates: An anchor of
  /// (0.0, 0.0) means the top left corner of the image. An anchor
  /// of (1.0, 1.0) means the bottom right corner of the image.
  final Offset anchor;

  /// onTap callback for this [InfoWindow].
  final VoidCallback onTap;

  /// Creates a new [InfoWindow] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  InfoWindow copyWith({
    String titleParam,
    String snippetParam,
    Offset anchorParam,
    VoidCallback onTapParam,
  }) {
    return InfoWindow(
      title: titleParam ?? title,
      snippet: snippetParam ?? snippet,
      anchor: anchorParam ?? anchor,
      onTap: onTapParam ?? onTap,
    );
  }

  dynamic _toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('title', title);
    addIfPresent('snippet', snippet);
    addIfPresent('anchor', _offsetToJson(anchor));

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final InfoWindow typedOther = other;
    return title == typedOther.title &&
        snippet == typedOther.snippet &&
        anchor == typedOther.anchor;
  }

  @override
  int get hashCode => hashValues(title.hashCode, snippet, anchor);

  @override
  String toString() {
    return 'InfoWindow{title: $title, snippet: $snippet, anchor: $anchor}';
  }
}

/// The position of the map "camera", the view point from which the world is shown in the map view.
///
/// Aggregates the camera's [target] geographical location, its [zoom] level,
/// [tilt] angle, and [bearing].
class MarkerTag {
  /// Creates a immutable representation of the [KakaoMap] camera.
  ///
  /// [AssertionError] is thrown if [bearing], [target], [tilt], or [zoom] are
  /// null.
  const MarkerTag({
    // this.bearing = 0.0,
    @required this.target,
    // this.tilt = 0.0,
    @required this.tag,
  })  : 
  // assert(bearing != null),
        assert(target != null),
  // assert(tilt != null),
        assert(tag != null);

  /// The camera's bearing in degrees, measured clockwise from north.
  ///
  /// A bearing of 0.0, the default, means the camera points north.
  /// A bearing of 90.0 means the camera points east.
  // final double bearing;

  /// The geographical location that the camera is pointing at.
  final MapPoint target;

  /// The angle, in degrees, of the camera angle from the nadir.
  ///
  /// A tilt of 0.0, the default and minimum supported value, means the camera
  /// is directly facing the Earth.
  ///
  /// The maximum tilt value depends on the current tag level. Values beyond
  /// the supported range are allowed, but on applying them to a map they will
  /// be silently clamped to the supported range.
  // final double tilt;

  /// The tag level of the camera.
  ///
  /// A tag of 0.0, the default, means the screen width of the world is 256.
  /// Adding 1.0 to the tag level doubles the screen width of the map. So at
  /// tag level 3.0, the screen width of the world is 2³x256=2048.
  ///
  /// Larger tag levels thus means the camera is placed closer to the surface
  /// of the Earth, revealing more detail in a narrower geographical region.
  ///
  /// The supported tag level range depends on the map data and device. Values
  /// beyond the supported range are allowed, but on applying them to a map they
  /// will be silently clamped to the supported range.
  final String tag;

  /// Serializes [MarkerTag].
  ///
  /// Mainly for internal use when calling [CameraUpdate.newMarkerTag].
  dynamic toMap() => <String, dynamic>{
        // 'bearing': bearing,
        'target': target.toJson(),
        // 'tilt': tilt,
        'tag': tag,
      };

  /// Deserializes [MarkerTag] from a map.
  ///
  /// Mainly for internal use.
  static MarkerTag fromMap(dynamic json) {
    if (json == null) {
      return null;
    }
    return MarkerTag(
      // bearing: json['bearing'],
      target: MapPoint.fromJson(json['target']),
      // tilt: json['tilt'],
      tag: json['tag'],
    );
  }

  @override
  bool operator ==(dynamic other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final MarkerTag typedOther = other;
    return 
        // bearing == typedOther.bearing &&
        target == typedOther.target &&
        // tilt == typedOther.tilt &&
        tag == typedOther.tag;
  }

  @override
  // int get hashCode => hashValues(bearing, target, tilt, tag);
  int get hashCode => hashValues(target, tag);

  @override
  String toString() =>
      // 'MarkerTag(bearing: $bearing, target: $target, tilt: $tilt, tag: $tag)';
      'MarkerTag(target: $target, tag: $tag)';
}

/// Uniquely identifies a [Marker] among [KakaoMap] markers.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class MarkerId {
  /// Creates an immutable identifier for a [Marker].
  MarkerId(this.value) : assert(value != null);

  /// value of the [MarkerId].
  final String value;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final MarkerId typedOther = other;
    return value == typedOther.value;
  }

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() {
    return 'MarkerId{value: $value}';
  }
}

/// Marks a geographical location on the map.
///
/// A marker icon is drawn oriented against the device's screen rather than
/// the map's surface; that is, it will not necessarily change orientation
/// due to map rotations, tilting, or zooming.
@immutable
class Marker {
  /// Creates a set of marker configuration options.
  ///
  /// Default marker options.
  ///
  /// Specifies a marker that
  /// * is fully opaque; [alpha] is 1.0
  /// * uses icon bottom center to indicate map position; [anchor] is (0.5, 1.0)
  /// * has default tap handling; [consumeTapEvents] is false
  /// * is stationary; [draggable] is false
  /// * is drawn against the screen, not the map; [flat] is false
  /// * has a default icon; [icon] is `BitmapDescriptor.defaultMarker`
  /// * anchors the info window at top center; [infoWindowAnchor] is (0.5, 0.0)
  /// * has no info window text; [infoWindowText] is `InfoWindowText.noText`
  /// * is positioned at 0, 0; [position] is `MapPoint(0.0, 0.0)`
  /// * has an axis-aligned icon; [rotation] is 0.0
  /// * is visible; [visible] is true
  /// * is placed at the base of the drawing order; [zIndex] is 0.0
  /// * reports [onTap] events
  /// * reports [onDragEnd] events
  const Marker({
    @required this.markerId,
    this.alpha = 1.0,
    this.anchor = const Offset(0.5, 1.0),
    this.consumeTapEvents = false,
    this.draggable = false,
    this.flat = false,
    this.icon = BitmapDescriptor.defaultMarker,
    this.infoWindow = InfoWindow.noText,
    this.position = const MapPoint(0.0, 0.0),
    this.rotation = 0.0,
    this.visible = true,
    this.zIndex = 0.0,
    this.markerType = MarkerType.markerTypeBluePin,
    this.markerSelectedType = MarkerSelectedType.markerSelectedTypeNone,
    this.showAnimationType = ShowAnimationType.showAnimationTypeDropFromHeaven,
    this.onTap,
    this.onDragEnd,
  }) : assert(alpha == null || (0.0 <= alpha && alpha <= 1.0));

  /// Uniquely identifies a [Marker].
  final MarkerId markerId;

  /// The opacity of the marker, between 0.0 and 1.0 inclusive.
  ///
  /// 0.0 means fully transparent, 1.0 means fully opaque.
  final double alpha;

  /// The icon image point that will be placed at the [position] of the marker.
  ///
  /// The image point is specified in normalized coordinates: An anchor of
  /// (0.0, 0.0) means the top left corner of the image. An anchor
  /// of (1.0, 1.0) means the bottom right corner of the image.
  final Offset anchor;

  /// True if the marker icon consumes tap events. If not, the map will perform
  /// default tap handling by centering the map on the marker and displaying its
  /// info window.
  final bool consumeTapEvents;

  /// True if the marker is draggable by user touch events.
  final bool draggable;

  /// True if the marker is rendered flatly against the surface of the Earth, so
  /// that it will rotate and tilt along with map camera movements.
  final bool flat;

  /// A description of the bitmap used to draw the marker icon.
  final BitmapDescriptor icon;

  /// A Kakao Maps InfoWindow.
  ///
  /// The window is displayed when the marker is tapped.
  final InfoWindow infoWindow;

  /// Geographical location of the marker.
  final MapPoint position;

  /// Rotation of the marker image in degrees clockwise from the [anchor] point.
  final double rotation;

  /// True if the marker is visible.
  final bool visible;

  /// The z-index of the marker, used to determine relative drawing order of
  /// map overlays.
  ///
  /// Overlays are drawn in order of z-index, so that lower values means drawn
  /// earlier, and thus appearing to be closer to the surface of the Earth.
  final double zIndex;

  final MarkerType markerType;

  final MarkerSelectedType markerSelectedType;
  
  final ShowAnimationType showAnimationType;

  /// Callbacks to receive tap events for markers placed on this map.
  final VoidCallback onTap;

  /// Signature reporting the new [MapPoint] at the end of a drag event.
  final ValueChanged<MapPoint> onDragEnd;

  /// Creates a new [Marker] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  Marker copyWith({
    double alphaParam,
    Offset anchorParam,
    bool consumeTapEventsParam,
    bool draggableParam,
    bool flatParam,
    BitmapDescriptor iconParam,
    InfoWindow infoWindowParam,
    MapPoint positionParam,
    double rotationParam,
    bool visibleParam,
    double zIndexParam,
    MarkerType markerTypeParam,
    MarkerSelectedType markerSelectedTypeParam,
    ShowAnimationType showAnimationTypeParam,
    VoidCallback onTapParam,
    ValueChanged<MapPoint> onDragEndParam,
  }) {
    return Marker(
      markerId: markerId,
      alpha: alphaParam ?? alpha,
      anchor: anchorParam ?? anchor,
      consumeTapEvents: consumeTapEventsParam ?? consumeTapEvents,
      draggable: draggableParam ?? draggable,
      flat: flatParam ?? flat,
      icon: iconParam ?? icon,
      infoWindow: infoWindowParam ?? infoWindow,
      position: positionParam ?? position,
      rotation: rotationParam ?? rotation,
      visible: visibleParam ?? visible,
      zIndex: zIndexParam ?? zIndex,
      markerType: markerTypeParam ?? markerType,
      markerSelectedType: markerSelectedTypeParam ?? markerSelectedType,
      showAnimationType: showAnimationTypeParam ?? showAnimationType,
      onTap: onTapParam ?? onTap,
      onDragEnd: onDragEndParam ?? onDragEnd,
    );
  }

  /// Creates a new [Marker] object whose values are the same as this instance.
  Marker clone() => copyWith();

  /// Converts this object to something serializable in JSON.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};

    void addIfPresent(String fieldName, dynamic value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('markerId', markerId.value);
    addIfPresent('alpha', alpha);
    addIfPresent('anchor', _offsetToJson(anchor));
    addIfPresent('consumeTapEvents', consumeTapEvents);
    addIfPresent('draggable', draggable);
    addIfPresent('flat', flat);
    addIfPresent('icon', icon?.toJson());
    addIfPresent('infoWindow', infoWindow?._toJson());
    addIfPresent('position', position?.toJson());
    addIfPresent('rotation', rotation);
    addIfPresent('visible', visible);
    addIfPresent('zIndex', zIndex);
    addIfPresent('markerType', markerType.index);
    addIfPresent('markerSelectedType', markerSelectedType.index);
    addIfPresent('showAnimationType', showAnimationType.index);
    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other.runtimeType != runtimeType) return false;
    final Marker typedOther = other;
    return markerId == typedOther.markerId &&
        alpha == typedOther.alpha &&
        anchor == typedOther.anchor &&
        consumeTapEvents == typedOther.consumeTapEvents &&
        draggable == typedOther.draggable &&
        flat == typedOther.flat &&
        icon == typedOther.icon &&
        infoWindow == typedOther.infoWindow &&
        position == typedOther.position &&
        rotation == typedOther.rotation &&
        visible == typedOther.visible &&
        zIndex == typedOther.zIndex && 
        markerType == typedOther.markerType &&
        markerSelectedType == typedOther.markerSelectedType &&
        showAnimationType == typedOther.showAnimationType;
  }

  @override
  int get hashCode => markerId.hashCode;

  @override
  String toString() {
    return 'Marker{markerId: $markerId, alpha: $alpha, anchor: $anchor, '
        'consumeTapEvents: $consumeTapEvents, draggable: $draggable, flat: $flat, '
        'icon: $icon, infoWindow: $infoWindow, position: $position, rotation: $rotation, '
        'visible: $visible, zIndex: $zIndex, markerType: $markerType, markerSelectedType: $markerSelectedType, '
        'showAnimationType: $showAnimationType, onTap: $onTap }';
  }
}
