// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import net.daum.mf.map.api.MapPOIItem;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.api.MapView;

/** Controller of a single Marker on the map. */
class MarkerController implements MarkerOptionsSink {

    private final MapPOIItem marker;
    private final int kakaoMapsTag;
    private boolean consumeTapEvents;

    MarkerController(MapPOIItem marker, boolean consumeTapEvents) {
        this.marker = marker;
        this.consumeTapEvents = consumeTapEvents;
        this.kakaoMapsTag = marker.getTag();
    }

    void remove(MapView mapView) {
        mapView.removePOIItem(marker);
    }

    @Override
    public void setAlpha(float alpha) {
        marker.setAlpha(alpha);
    }

    @Override
    public void setAnchor(float u, float v) {
    }

    @Override
    public void setConsumeTapEvents(boolean consumeTapEvents) {
        this.consumeTapEvents = consumeTapEvents;
    }

    @Override
    public void setDraggable(boolean draggable) {
        marker.setDraggable(draggable);
    }

    @Override
    public void setInfoWindowAnchor(float u, float v) {
    }

    @Override
    public void setInfoWindowText(String title, String snippet) {
    }

    @Override
    public void setPosition(MapPoint position) {
        marker.setMapPoint(position);
    }

    @Override
    public void setRotation(float rotation) {
        marker.setRotation(rotation);
    }

    @Override
    public void setMarkerType(int markerType) {
        marker.setMarkerType(MapPOIItem.MarkerType.values()[markerType]);
    }

    @Override
    public void setMarkerSelectedType(int markerSelectedType) {
        marker.setSelectedMarkerType(MapPOIItem.MarkerType.values()[markerSelectedType]);
    }

    int getKakaoMapsMarkerId() {
        return kakaoMapsTag;
    }

    boolean consumeTapEvents() {
        return consumeTapEvents;
    }

    public void showInfoWindow() {
    }

    public void hideInfoWindow() {
    }

    public boolean isInfoWindowShown() {
        return false;
    }
}
