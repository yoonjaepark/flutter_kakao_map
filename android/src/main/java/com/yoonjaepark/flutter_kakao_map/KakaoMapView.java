// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import android.app.Activity;
import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.util.AttributeSet;
import android.util.Base64;
import android.util.Log;
import android.view.SurfaceView;
import android.view.View;
import android.widget.TextView;

import androidx.annotation.NonNull;

import net.daum.mf.map.api.MapView;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.platform.PlatformView;

public class KakaoMapView extends MapView {
    public KakaoMapView(Activity activity) {
        super(activity);
    }

    public KakaoMapView(Context context) {
        super(context);
    }

    public KakaoMapView(Context context, AttributeSet attrs) {
        super(context, attrs);
    }

    public KakaoMapView(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);
    }
}