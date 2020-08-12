package com.yoonjaepark.flutter_kakao_map;
// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import net.daum.mf.map.api.MapPOIItem;
import net.daum.mf.map.api.MapPoint;
import net.daum.mf.map.n.api.internal.NativePOIItemMarkerManager;

class MarkerBuilder implements MarkerOptionsSink {
    private final MapPOIItem mapPOIItem;
    private boolean consumeTapEvents;

    MarkerBuilder() {
        this.mapPOIItem = new MapPOIItem();
    }

    MapPOIItem build() {
        return mapPOIItem;
    }

    boolean consumeTapEvents() {
        return consumeTapEvents;
    }

    @Override
    public void setAlpha(float alpha) {
        mapPOIItem.setAlpha(alpha);
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
        mapPOIItem.setDraggable(draggable);
    }

    @Override
    public void setInfoWindowAnchor(float u, float v) {
//        markerOptions.infoWindowAnchor(u, v);
    }

    @Override
    public void setInfoWindowText(String title, String snippet) {
        mapPOIItem.setItemName(title);
    }

    @Override
    public void setPosition(MapPoint position) {
        mapPOIItem.setMapPoint(position);
    }

    @Override
    public void setRotation(float rotation) {
        mapPOIItem.setRotation(rotation);
    }

    @Override
    public void setMarkerType(int markerType) {
        mapPOIItem.setMarkerType(MapPOIItem.MarkerType.values()[markerType]);
    }

    @Override
    public void setMarkerSelectedType(int markerSelectedType) {
        mapPOIItem.setSelectedMarkerType(MapPOIItem.MarkerType.values()[markerSelectedType]);
    }
}
