// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Point;
import android.util.Log;

import net.daum.android.map.coord.MapCoord;
import net.daum.mf.map.api.CameraPosition;
import net.daum.mf.map.api.CameraUpdate;
import net.daum.mf.map.api.CameraUpdateFactory;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.api.MapPointBounds;

import io.flutter.view.FlutterMain;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Conversions between JSON-like values and KakaoMaps data types. */
class Convert {
    static Object mapPointToJson(MapPoint mapPoint) {
        return Arrays.asList(mapPoint.getMapPointGeoCoord().latitude, mapPoint.getMapPointGeoCoord().longitude);
    }

        static CameraUpdate toCameraUpdate(Object o, float density) {
        final List<?> data = toList(o);
        switch (toString(data.get(0))) {
            case "newMapPoint":
            case "newCameraPosition":
            case "newMapPointAndDiameter":
            case "newLatLngZoom":
            default:
                throw new IllegalArgumentException("Cannot interpret " + o + " as CameraUpdate");
        }
    }

    private static boolean toBoolean(Object o) {
        return (Boolean) o;
    }

    static CameraPosition toCameraPosition(Object o) {
        final Map<?, ?> data = toMap(o);
        final Object target = data.get("target");
        final Object zoomLevel = data.get("zoom");
        List list = toList(target);
        MapPoint mapPoint = MapPoint.mapPointWithGeoCoord(toDouble(list.get(0)), toDouble(list.get(1)));
        return new CameraPosition(mapPoint, toInt(zoomLevel));
    }

    private static double toDouble(Object o) {
        return ((Number) o).doubleValue();
    }

    private static float toFloat(Object o) {
        return ((Number) o).floatValue();
    }

    private static Float toFloatWrapper(Object o) {
        return (o == null) ? null : toFloat(o);
    }

    static int toInt(Object o) {
        return ((Number) o).intValue();
    }

    static Object cameraPositionToJson(CameraPosition position) {
        if (position == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>();
        data.put("bearing", position.bearing);
        data.put("tilt", position.tilt);
        return data;
    }

    static Object latlngBoundsToJson(MapPointBounds latLngBounds) {
        final Map<String, Object> arguments = new HashMap<>(2);
        return arguments;
    }

    static Object markerIdToJson(String markerId) {
        if (markerId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("markerId", markerId);
        return data;
    }

    static Object polygonIdToJson(String polygonId) {
        if (polygonId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("polygonId", polygonId);
        return data;
    }

    static Object polylineIdToJson(String polylineId) {
        if (polylineId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("polylineId", polylineId);
        return data;
    }

    static Object circleIdToJson(String circleId) {
        if (circleId == null) {
            return null;
        }
        final Map<String, Object> data = new HashMap<>(1);
        data.put("circleId", circleId);
        return data;
    }

    static Point toPoint(Object o) {
        Map<String, Integer> screenCoordinate = (Map<String, Integer>) o;
        return new Point(screenCoordinate.get("x"), screenCoordinate.get("y"));
    }

    static Map<String, Integer> pointToJson(Point point) {
        final Map<String, Integer> data = new HashMap<>(2);
        data.put("x", point.x);
        data.put("y", point.y);
        return data;
    }

    private static List<?> toList(Object o) {
        return (List<?>) o;
    }

    private static Map<?, ?> toMap(Object o) {
        return (Map<?, ?>) o;
    }

    private static float toFractionalPixels(Object o, float density) {
        return toFloat(o) * density;
    }

    private static int toPixels(Object o, float density) {
        return (int) toFractionalPixels(o, density);
    }

    private static Bitmap toBitmap(Object o) {
        byte[] bmpData = (byte[]) o;
        Bitmap bitmap = BitmapFactory.decodeByteArray(bmpData, 0, bmpData.length);
        if (bitmap == null) {
            throw new IllegalArgumentException("Unable to decode bytes as a valid bitmap.");
        } else {
            return bitmap;
        }
    }

    private static Point toPoint(Object o, float density) {
        final List<?> data = toList(o);
        return new Point(toPixels(data.get(0), density), toPixels(data.get(1), density));
    }

    private static String toString(Object o) {
        return (String) o;
    }

    static void interpretKakaoMapOptions(Object o, KakaoMapOptionsSink sink) {
        final Map<?, ?> data = toMap(o);
        final Object cameraTargetBounds = data.get("cameraTargetBounds");
        if (cameraTargetBounds != null) {
            final List<?> targetData = toList(cameraTargetBounds);
        }
        final Object compassEnabled = data.get("compassEnabled");
        if (compassEnabled != null) {
            sink.setCompassEnabled(toBoolean(compassEnabled));
        }
        final Object mapType = data.get("mapType");
        if (mapType != null) {
            sink.setMapType(toInt(mapType));
        }
        final Object currentLocationTrackingMode = data.get("currentLocationTrackingMode");
        if( currentLocationTrackingMode != null) {
            sink.setCurrentLocationTrackingMode(toInt(currentLocationTrackingMode));
        }
        final Object hdMapTile = data.get("hdMapTile");
        if (hdMapTile != null) {
            sink.setHdMapTile(toBoolean(hdMapTile));
        }
        final Object minMaxZoomPreference = data.get("minMaxZoomPreference");
        if (minMaxZoomPreference != null) {
            final List<?> zoomPreferenceData = toList(minMaxZoomPreference);
            sink.setMinMaxZoomPreference(
                    toFloatWrapper(zoomPreferenceData.get(0)),
                    toFloatWrapper(zoomPreferenceData.get(1)));
        }
        final Object padding = data.get("padding");
        if (padding != null) {
            final List<?> paddingData = toList(padding);
            sink.setPadding(
                    toFloat(paddingData.get(0)),
                    toFloat(paddingData.get(1)),
                    toFloat(paddingData.get(2)),
                    toFloat(paddingData.get(3)));
        }
        final Object rotateGesturesEnabled = data.get("rotateGesturesEnabled");
        if (rotateGesturesEnabled != null) {
            sink.setRotateGesturesEnabled(toBoolean(rotateGesturesEnabled));
        }
        final Object scrollGesturesEnabled = data.get("scrollGesturesEnabled");
        if (scrollGesturesEnabled != null) {
            sink.setScrollGesturesEnabled(toBoolean(scrollGesturesEnabled));
        }
        final Object tiltGesturesEnabled = data.get("tiltGesturesEnabled");
        if (tiltGesturesEnabled != null) {
            sink.setTiltGesturesEnabled(toBoolean(tiltGesturesEnabled));
        }
        final Object trackCameraPosition = data.get("trackCameraPosition");
        if (trackCameraPosition != null) {
            sink.setTrackCameraPosition(toBoolean(trackCameraPosition));
        }
        final Object zoomGesturesEnabled = data.get("zoomGesturesEnabled");
        if (zoomGesturesEnabled != null) {
            sink.setZoomGesturesEnabled(toBoolean(zoomGesturesEnabled));
        }
        final Object myLocationEnabled = data.get("myLocationEnabled");
        if (myLocationEnabled != null) {
            sink.setMyLocationEnabled(toBoolean(myLocationEnabled));
        }
        final Object zoomControlsEnabled = data.get("zoomControlsEnabled");
        if (zoomControlsEnabled != null) {
            sink.setZoomControlsEnabled(toBoolean(zoomControlsEnabled));
        }
        final Object myLocationButtonEnabled = data.get("myLocationButtonEnabled");
        if (myLocationButtonEnabled != null) {
            sink.setMyLocationButtonEnabled(toBoolean(myLocationButtonEnabled));
        }
        final Object indoorEnabled = data.get("indoorEnabled");
        if (indoorEnabled != null) {
            sink.setIndoorEnabled(toBoolean(indoorEnabled));
        }
    }

    /** Returns the dartMarkerId of the interpreted marker. */
    static String interpretMarkerOptions(Object o, MarkerOptionsSink sink) {
        final Map<?, ?> data = toMap(o);
        final Object alpha = data.get("alpha");
        if (alpha != null) {
            sink.setAlpha(toFloat(alpha));
        }
        final Object anchor = data.get("anchor");
        if (anchor != null) {
            final List<?> anchorData = toList(anchor);
            sink.setAnchor(toFloat(anchorData.get(0)), toFloat(anchorData.get(1)));
        }
        final Object consumeTapEvents = data.get("consumeTapEvents");
        if (consumeTapEvents != null) {
            sink.setConsumeTapEvents(toBoolean(consumeTapEvents));
        }
        final Object draggable = data.get("draggable");
        if (draggable != null) {
            sink.setDraggable(toBoolean(draggable));
        }
        final Object flat = data.get("flat");
        if (flat != null) {
        }
//        final Object icon = data.get("icon");
//        if (icon != null) {
//            sink.setIcon(toBitmapDescriptor(icon));
//        }

        final Object infoWindow = data.get("infoWindow");
        if (infoWindow != null) {
            interpretInfoWindowOptions(sink, (Map<String, Object>) infoWindow);
        }
        final Object position = data.get("position");
        if (position != null) {
            List list = toList(position);
            MapPoint mapPoint = MapPoint.mapPointWithGeoCoord(toDouble(list.get(0)), toDouble(list.get(1)));
            sink.setPosition(mapPoint);
        }
        final Object rotation = data.get("rotation");
        if (rotation != null) {
            sink.setRotation(toFloat(rotation));
        }
        final Object visible = data.get("visible");
        if (visible != null) {
//            sink.setVisible(toBoolean(visible));
        }
        final Object zIndex = data.get("zIndex");
        if (zIndex != null) {
//            sink.setZIndex(toFloat(zIndex));
        }
        final String markerId = (String) data.get("markerId");

        final int markerType = toInt(data.get("markerType"));
        if (markerType > -1) {
            sink.setMarkerType(toInt(markerType));
        }

        final int markerSelectedType = toInt(data.get("markerSelectedType"));
        if (markerSelectedType > -1) {
            sink.setMarkerSelectedType(toInt(markerSelectedType));
        }

        if (markerId == null) {
            throw new IllegalArgumentException("markerId was null");
        } else {
            return markerId;
        }
    }

    private static void interpretInfoWindowOptions(
            MarkerOptionsSink sink, Map<String, Object> infoWindow) {
        String title = (String) infoWindow.get("title");
        String snippet = (String) infoWindow.get("snippet");
        // snippet is nullable.
        if (title != null) {
            sink.setInfoWindowText(title, snippet);
        }
        Object infoWindowAnchor = infoWindow.get("anchor");
        if (infoWindowAnchor != null) {
            final List<?> anchorData = toList(infoWindowAnchor);
            sink.setInfoWindowAnchor(toFloat(anchorData.get(0)), toFloat(anchorData.get(1)));
        }
    }
}
