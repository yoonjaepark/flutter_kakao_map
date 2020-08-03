// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <DaumMap/MTMapView.h>
#import <MapKit/MapKit.h>
NS_ASSUME_NONNULL_BEGIN

// Defines map UI options writable from Flutter.
@protocol KakaoMapOptionsSink
- (void)setCameraTargetBounds:(nullable MTMapBounds *)bounds;
- (void)setCompassEnabled:(BOOL)enabled;
- (void)setIndoorEnabled:(BOOL)enabled;

- (void)setMapType:(MTMapType)type;
- (void)setCurrentLocationTrackingMode:(MTMapCurrentLocationTrackingMode)currentLocationTrackingMode;
- (void)setHDMapTile:(BOOL)enabled;

- (void)setMinZoom:(float)minZoom maxZoom:(float)maxZoom;
- (void)setRotateGesturesEnabled:(BOOL)enabled;
- (void)setScrollGesturesEnabled:(BOOL)enabled;
- (void)setTiltGesturesEnabled:(BOOL)enabled;
- (void)setTrackCameraPosition:(BOOL)enabled;
- (void)setZoomGesturesEnabled:(BOOL)enabled;
- (nullable NSString *)setMapStyle:(NSString *)mapStyle;
@end

// Defines map overlay controllable from Flutter.
@interface KakaoMapController
: NSObject <MTMapViewDelegate, KakaoMapOptionsSink, FlutterPlatformView>
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(nullable id)args
                    registrar:(NSObject<FlutterPluginRegistrar> *)registrar;
@end

// Allows the engine to create new Kakao Map instances.
@interface KakaoMapFactory : NSObject <FlutterPlatformViewFactory>
- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar;
@end

NS_ASSUME_NONNULL_END
