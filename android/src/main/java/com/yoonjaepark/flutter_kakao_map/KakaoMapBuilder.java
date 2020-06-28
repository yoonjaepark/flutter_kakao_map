// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.graphics.Rect;
import android.util.Log;

import androidx.lifecycle.Lifecycle;

import net.daum.mf.map.api.CameraPosition;
import net.daum.mf.map.api.MapPointBounds;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import java.util.concurrent.atomic.AtomicInteger;

class KakaoMapBuilder implements KakaoMapOptionsSink {
    private final KakaoMapOptions options = new KakaoMapOptions();
    private boolean trackCameraPosition = false;
    private boolean myLocationEnabled = false;
    private boolean myLocationButtonEnabled = false;
    private boolean indoorEnabled = true;
    private boolean trafficEnabled = false;
    private boolean buildingsEnabled = true;
    private Object initialMarkers;
    private Object initialPolygons;
    private Object initialPolylines;
    private Object initialCircles;
    private Rect padding = new Rect(0, 0, 0, 0);
    private KakaoMapController controller;

    KakaoMapController build(
            int id,
            Context context,
            AtomicInteger state,
            BinaryMessenger binaryMessenger,
            Application application,
            Lifecycle lifecycle,
            PluginRegistry.Registrar registrar,
            int activityHashCode,
            Activity activity) {
        this.controller =
                new KakaoMapController(
                        id,
                        context,
                        state,
                        binaryMessenger,
                        application,
                        lifecycle,
                        registrar,
                        activityHashCode,
                        options,
                        activity);
        controller.setInitialMarkers(initialMarkers);
        return this.controller;
    }

    void setInitialCameraPosition(CameraPosition position) {
        options.setInitialCameraPosition(position);
    }

    @Override
    public void setCompassEnabled(boolean compassEnabled) {
    }

    @Override
    public void setMapToolbarEnabled(boolean setMapToolbarEnabled) {
    }

    @Override
    public void setCameraTargetBounds(MapPointBounds bounds) {
    }

    @Override
    public void setMapType(int mapType) {
    }

    @Override
    public void setCurrentLocationTrackingMode(int currentLocationTrackingMode) {

    }

    @Override
    public void setHdMapTile(boolean hdMapTileEnabled) {
    }

    @Override
    public void setMinMaxZoomPreference(Float min, Float max) {
    }

    @Override
    public void setPadding(float top, float left, float bottom, float right) {
        this.padding = new Rect((int) left, (int) top, (int) right, (int) bottom);
    }

    @Override
    public void setTrackCameraPosition(boolean trackCameraPosition) {
        this.trackCameraPosition = trackCameraPosition;
    }

    @Override
    public void setRotateGesturesEnabled(boolean rotateGesturesEnabled) {
    }

    @Override
    public void setScrollGesturesEnabled(boolean scrollGesturesEnabled) {
    }

    @Override
    public void setTiltGesturesEnabled(boolean tiltGesturesEnabled) {
    }

    @Override
    public void setZoomGesturesEnabled(boolean zoomGesturesEnabled) {
    }

    @Override
    public void setIndoorEnabled(boolean indoorEnabled) {
        this.indoorEnabled = indoorEnabled;
    }

    @Override
    public void setTrafficEnabled(boolean trafficEnabled) {
        this.trafficEnabled = trafficEnabled;
    }

    @Override
    public void setBuildingsEnabled(boolean buildingsEnabled) {
        this.buildingsEnabled = buildingsEnabled;
    }

    @Override
    public void setMyLocationEnabled(boolean myLocationEnabled) {
        this.myLocationEnabled = myLocationEnabled;
    }

    @Override
    public void setZoomControlsEnabled(boolean zoomControlsEnabled) {
    }

    @Override
    public void setMyLocationButtonEnabled(boolean myLocationButtonEnabled) {
        this.myLocationButtonEnabled = myLocationButtonEnabled;
    }

    @Override
    public void setInitialMarkers(Object initialMarkers) {
        this.initialMarkers = initialMarkers;
    }

    @Override
    public void setInitialPolygons(Object initialPolygons) {
        this.initialPolygons = initialPolygons;
    }

    @Override
    public void setInitialPolylines(Object initialPolylines) {
        this.initialPolylines = initialPolylines;
    }

    @Override
    public void setInitialCircles(Object initialCircles) {
        this.initialCircles = initialCircles;
    }
}
