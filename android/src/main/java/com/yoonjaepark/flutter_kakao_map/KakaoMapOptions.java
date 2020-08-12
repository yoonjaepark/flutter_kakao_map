// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

package com.yoonjaepark.flutter_kakao_map;

import net.daum.mf.map.api.CameraPosition;

public class KakaoMapOptions {
    public CameraPosition initialCameraPosition;

    public void setInitialCameraPosition(CameraPosition position) {
        this.initialCameraPosition = position;
    }
}
