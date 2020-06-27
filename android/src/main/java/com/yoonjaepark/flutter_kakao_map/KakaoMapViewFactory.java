// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import android.app.Activity;
import android.content.Context;

import android.app.Application;
import android.content.Context;
import android.util.Log;

import androidx.lifecycle.Lifecycle;

import net.daum.mf.map.api.CameraPosition;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.PluginRegistry;
import io.flutter.plugin.common.StandardMessageCodec;
import io.flutter.plugin.platform.PlatformView;
import io.flutter.plugin.platform.PlatformViewFactory;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

public class KakaoMapViewFactory extends PlatformViewFactory {
    private final AtomicInteger mActivityState;
    private final BinaryMessenger binaryMessenger;
    private final Application application;
    private final int activityHashCode;
    private final Lifecycle lifecycle;
    private final PluginRegistry.Registrar registrar; // V1 embedding only.
    private final Activity activity;

    public KakaoMapViewFactory(AtomicInteger state,
                               BinaryMessenger binaryMessenger,
                               Application application,
                               Lifecycle lifecycle,
                               PluginRegistry.Registrar registrar,
                               int activityHashCode,
                               Activity activity) {
        super(StandardMessageCodec.INSTANCE);
        mActivityState = state;
        this.binaryMessenger = binaryMessenger;
        this.application = application;
        this.activityHashCode = activityHashCode;
        this.lifecycle = lifecycle;
        this.registrar = registrar;
        this.activity = activity;
    }


    @SuppressWarnings("unchecked")
    @Override
    public PlatformView create(Context context, int id, Object args) {
        Map<String, Object> params = (Map<String, Object>) args;
        final KakaoMapBuilder builder = new KakaoMapBuilder();

        Convert.interpretKakaoMapOptions(params.get("options"), builder);
        if (params.containsKey("initialCameraPosition")) {
            CameraPosition position = Convert.toCameraPosition(params.get("initialCameraPosition"));
            Log.d("initialCameraPosition", position.toString());
            builder.setInitialCameraPosition(position);
        }
//        if (params.containsKey("markersToAdd")) {
//            builder.setInitialMarkers(params.get("markersToAdd"));
//        }
//        if (params.containsKey("polygonsToAdd")) {
//            builder.setInitialPolygons(params.get("polygonsToAdd"));
//        }
//        if (params.containsKey("polylinesToAdd")) {
//            builder.setInitialPolylines(params.get("polylinesToAdd"));
//        }
//        if (params.containsKey("circlesToAdd")) {
//            builder.setInitialCircles(params.get("circlesToAdd"));
//        }
        return builder.build(
                id,
                context,
                mActivityState,
                binaryMessenger,
                application,
                lifecycle,
                registrar,
                activityHashCode,
                activity);
    }
}