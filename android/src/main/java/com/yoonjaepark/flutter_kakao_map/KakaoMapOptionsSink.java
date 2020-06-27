// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import net.daum.mf.map.api.MapPointBounds;

interface KakaoMapOptionsSink {
    void setCameraTargetBounds(MapPointBounds bounds);

    void setCompassEnabled(boolean compassEnabled);

    void setMapToolbarEnabled(boolean setMapToolbarEnabled);

    void setMapType(int mapType);

    void setCurrentLocationTrackingMode(int currentLocationTrackingMode);

    void setHdMapTile(boolean hdMapTileEnabled);

    void setMinMaxZoomPreference(Float min, Float max);

    void setPadding(float top, float left, float bottom, float right);

    void setRotateGesturesEnabled(boolean rotateGesturesEnabled);

    void setScrollGesturesEnabled(boolean scrollGesturesEnabled);

    void setTiltGesturesEnabled(boolean tiltGesturesEnabled);

    void setTrackCameraPosition(boolean trackCameraPosition);

    void setZoomGesturesEnabled(boolean zoomGesturesEnabled);

    void setMyLocationEnabled(boolean myLocationEnabled);

    void setZoomControlsEnabled(boolean zoomControlsEnabled);

    void setMyLocationButtonEnabled(boolean myLocationButtonEnabled);

    void setIndoorEnabled(boolean indoorEnabled);

    void setTrafficEnabled(boolean trafficEnabled);

    void setBuildingsEnabled(boolean buildingsEnabled);

    void setInitialMarkers(Object initialMarkers);

    void setInitialPolygons(Object initialPolygons);

    void setInitialPolylines(Object initialPolylines);

    void setInitialCircles(Object initialCircles);
}
