// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <DaumMap/MTMapView.h>
#import "KakaoMapController.h"
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

// Defines marker UI options writable from Flutter.
@protocol KakaoMapMarkerOptionsSink
- (void)setAlpha:(float)alpha;
- (void)setAnchor:(CGPoint)anchor;
- (void)setConsumeTapEvents:(BOOL)consume;
- (void)setDraggable:(BOOL)draggable;
- (void)setFlat:(BOOL)flat;
- (void)setIcon:(UIImage*)icon;
- (void)setInfoWindowAnchor:(CGPoint)anchor;
- (void)setInfoWindowTitle:(NSString*)title snippet:(NSString*)snippet;
- (void)setPosition:(MTMapPoint*)position;
- (void)setRotation:(CLLocationDegrees)rotation;
- (void)setVisible:(BOOL)visible;
- (void)setZIndex:(int)zIndex;
- (void)setMarkerType:(int)markerType;
- (void)setMarkerSelectedType:(int)markerSelectedType;
@end

// Defines marker controllable by Flutter.
@interface KakaoMapMarkerController : NSObject <KakaoMapMarkerOptionsSink>
@property(atomic, readonly) NSString* markerId;
- (instancetype)initMarkerWithPosition:(MTMapPointGeo)position
                              markerId:(NSString*)markerId
                               mapView:(MTMapView*)mapView;
- (void)showInfoWindow;
- (void)hideInfoWindow;
- (BOOL)isInfoWindowShown;
- (BOOL)consumeTapEvents;
- (void)removeMarker;
@end

@interface MarkersController : NSObject
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MTMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar;
- (void)addMarkers:(NSArray*)markersToAdd;
- (void)changeMarkers:(NSArray*)markersToChange;
- (void)removeMarkerIds:(NSArray*)markerIdsToRemove;
- (BOOL)onMarkerTap:(NSString*)markerId;
- (void)onMarkerDragEnd:(NSString*)markerId coordinate:(CLLocationCoordinate2D)coordinate;
- (void)onInfoWindowTap:(NSString*)markerId;
- (void)showMarkerInfoWindow:(NSString*)markerId result:(FlutterResult)result;
- (void)hideMarkerInfoWindow:(NSString*)markerId result:(FlutterResult)result;
- (void)isMarkerInfoWindowShown:(NSString*)markerId result:(FlutterResult)result;
@end

NS_ASSUME_NONNULL_END
