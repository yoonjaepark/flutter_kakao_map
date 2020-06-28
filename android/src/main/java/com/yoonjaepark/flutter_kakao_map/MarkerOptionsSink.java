// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import net.daum.mf.map.api.MapPoint;

/** Receiver of Marker configuration options. */
interface MarkerOptionsSink {
    void setAlpha(float alpha);

    void setAnchor(float u, float v);

    void setConsumeTapEvents(boolean consumeTapEvents);

    void setDraggable(boolean draggable);

    void setInfoWindowAnchor(float u, float v);

    void setInfoWindowText(String title, String snippet);

    void setPosition(MapPoint position);

    void setRotation(float rotation);

    void setMarkerType(int markerType);

    void setMarkerSelectedType(int markerSelectedType);
}
