// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "KakaoMapController.h"
#import "JsonConversions.h"
#import "KakaoMapMarkerController.h"

#pragma mark - Conversion of JSON-like values sent via platform channels. Forward declarations.

static NSDictionary* PointToJson(CGPoint point);
static CGPoint ToCGPoint(NSDictionary* json);
static MTMapCameraUpdate* ToCameraUpdate(NSArray* data);
static NSDictionary* CoordinateBoundsToJson(MTMapBounds* bounds);
static void InterpretMapOptions(NSDictionary* data, id<KakaoMapOptionsSink> sink);
static double ToDouble(NSNumber* data) { return [KakaoMapJsonConversions toDouble:data]; }
static int ToInt(NSNumber* data) { return [KakaoMapJsonConversions toInt:data]; }

static NSArray* MapPointToJson(MTMapPoint* mapPoint);
static NSDictionary* ToPositon(NSDictionary* json);
@implementation KakaoMapFactory {
    NSObject<FlutterPluginRegistrar>* _registrar;
}

- (instancetype)initWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    self = [super init];
    if (self) {
        _registrar = registrar;
    }
    return self;
}

- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}

- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    return [[KakaoMapController alloc] initWithFrame:frame
                                      viewIdentifier:viewId
                                           arguments:args
                                           registrar:_registrar];
}
@end

@implementation KakaoMapController {
    MTMapView* _mapView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
    NSObject<FlutterPluginRegistrar>* _registrar;
    double lat;
    double lan;
    BOOL  showCurrentLocationMarker;
    BOOL compassEnabled;
    int zoomLevel;
    MarkersController* _markersController;
}

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
                    registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if (self = [super init]) {
        
        _viewId = viewId;
        
        if (args[@"initialCameraPosition"]) {
            NSDictionary *position = ToPositon(args[@"initialCameraPosition"]);
            lat = ToDouble(position[@"lat"]);
            lan = ToDouble(position[@"lan"]);
            NSNumber *zoom = @([position[@"zoomLevel"] intValue]);
            
            zoomLevel = ToInt(zoom);
        }
        _mapView = [[MTMapView alloc] initWithFrame: frame];
        
        NSString* channelName =
        [NSString stringWithFormat:@"plugins.flutter.io/kakao_maps_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName
                                               binaryMessenger:registrar.messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            if (weakSelf) {
                [weakSelf onMethodCall:call result:result];
            }
        }];
        _mapView.delegate = weakSelf;
        _registrar = registrar;
        _markersController = [[MarkersController alloc] init:_channel
                                                          mapView:_mapView
                                                        registrar:registrar];
               id markersToAdd = args[@"markersToAdd"];
               if ([markersToAdd isKindOfClass:[NSArray class]]) {
                 [_markersController addMarkers:markersToAdd];
               }
    }
    return self;
}

- (UIView*)view {
    return _mapView;
}

- (void)observeValueForKeyPath:(NSString*)keyPath
                      ofObject:(id)object
                        change:(NSDictionary*)change
                       context:(void*)context {
    if (object == _mapView && [keyPath isEqualToString:@"frame"]) {
        CGRect bounds = _mapView.bounds;
        if (CGRectEqualToRect(bounds, CGRectZero)) {
            // The workaround is to fix an issue that the camera location is not current when
            // the size of the map is zero at initialization.
            // So We only care about the size of the `_mapView`, ignore the frame changes when the size is
            // zero.
            return;
        }
        [_mapView removeObserver:self forKeyPath:@"frame"];
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([call.method isEqualToString:@"map#show"]) {
    } else if ([call.method isEqualToString:@"map#hide"]) {
    } else if ([call.method isEqualToString:@"map#zoomIn"]) {
        [_mapView zoomInAnimated:YES];
    } else if ([call.method isEqualToString:@"map#zoomOut"]) {
        [_mapView zoomOutAnimated:YES];
    } else if ([call.method isEqualToString:@"map#clearMapTilePersistentCache"]) {
        [MTMapView clearMapTilePersistentCache];
    } else if ([call.method isEqualToString:@"camera#animate"]) {
    } else if ([call.method isEqualToString:@"camera#move"]) {
        [self moveWithCameraUpdate:ToCameraUpdate(call.arguments[@"cameraUpdate"])];
        result(nil);
    } else if ([call.method isEqualToString:@"map#update"]) {
        InterpretMapOptions(call.arguments[@"options"], self);
    } else if ([call.method isEqualToString:@"map#getVisibleRegion"]) {
    }  else if ([call.method isEqualToString:@"map#getMapCenterPoint"]) {
        
        if (_mapView != nil) {
            result(MapPointToJson(_mapView.mapCenterPoint));
        } else {
            result([FlutterError errorWithCode:@"KakaoMap uninitialized"
                                       message:@"getMapCenterPoint called prior to map initialization"
                                       details:nil]);
        }
    } else if ([call.method isEqualToString:@"map#waitForMap"]) {
        result(nil);
    } else if ([call.method isEqualToString:@"map#takeSnapshot"]) {
        if (@available(iOS 10.0, *)) {
            if (_mapView != nil) {
            }
        } else {
            NSLog(@"Taking snapshots is not supported for Flutter Google Maps prior to iOS 10.");
            result(nil);
        }
    } else if ([call.method isEqualToString:@"markers#update"]) {
        id markersToAdd = call.arguments[@"markersToAdd"];
        if ([markersToAdd isKindOfClass:[NSArray class]]) {
            [_markersController addMarkers:markersToAdd];
        }
              id markersToChange = call.arguments[@"markersToChange"];
              if ([markersToChange isKindOfClass:[NSArray class]]) {
                [_markersController changeMarkers:markersToChange];
              }
              id markerIdsToRemove = call.arguments[@"markerIdsToRemove"];
              if ([markerIdsToRemove isKindOfClass:[NSArray class]]) {
                [_markersController removeMarkerIds:markerIdsToRemove];
              }
    } else if ([call.method isEqualToString:@"markers#showInfoWindow"]) {
    } else if ([call.method isEqualToString:@"markers#hideInfoWindow"]) {
    } else if ([call.method isEqualToString:@"markers#isInfoWindowShown"]) {
    } else if ([call.method isEqualToString:@"map#isCompassEnabled"]) {
    } else if ([call.method isEqualToString:@"map#getMinMaxZoomLevels"]) {
    } else if ([call.method isEqualToString:@"map#getZoomLevel"]) {
    } else if ([call.method isEqualToString:@"map#isZoomGesturesEnabled"]) {
    } else if ([call.method isEqualToString:@"map#isZoomControlsEnabled"]) {
    } else if ([call.method isEqualToString:@"map#isTiltGesturesEnabled"]) {
    } else if ([call.method isEqualToString:@"map#isRotateGesturesEnabled"]) {
    } else if ([call.method isEqualToString:@"map#isScrollGesturesEnabled"]) {
    } else if ([call.method isEqualToString:@"map#isMyLocationButtonEnabled"]) {
    } else if ([call.method isEqualToString:@"map#setStyle"]) {
    } else {
        result(FlutterMethodNotImplemented);
    }
}

// 이벤트
- (void)mapView:(MTMapView*)mapView openAPIKeyAuthenticationResultCode:(int)resultCode resultMessage:(NSString*)resultMessage {
    [_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(lat, lan)] zoomLevel:(int)zoomLevel animated:YES];
}


// 단말의 현위치 좌표값
- (void)mapView:(MTMapView*)mapView updateCurrentLocation:(MTMapPoint*)location withAccuracy:(MTMapLocationAccuracy)accuracy {
    [_channel invokeMethod:@"camera#onCurrentLocationUpdate" arguments:@{
        @"position": MapPointToJson(location),
        @"accuracy": @(accuracy)
    }];
}

//단말의 방향(Heading) 각도값을 통보받을 수 있다.
- (void)mapView:(MTMapView*)mapView updateDeviceHeading:(MTMapRotationAngle)headingAngle {
    id event = @{
        @"action": @"currentHeading",
        @"headingAngle": @(headingAngle),
    };
}

// 단말 사용자가 POI Item을 선택한 경우
- (BOOL)mapView:(MTMapView*)mapView selectedPOIItem:(MTMapPOIItem*)poiItem {
    NSString *markerId = [NSString stringWithFormat:@"%@", poiItem.userObject];
    [_markersController onMarkerTap:markerId];
    return YES;
}

// 단말 사용자가 POI Item 아이콘(마커) 위에 나타난 말풍선(Callout Balloon)을 터치한 경우
- (void)mapView:(MTMapView *)mapView touchedCalloutBalloonOfPOIItem:(MTMapPOIItem *)poiItem {
    id event = @{
        @"action": @"markerPress",
        @"id": @(poiItem.tag),
        @"coordinate": @{
                @"latitude": @(poiItem.mapPoint.mapPointGeo.latitude),
                @"longitude": @(poiItem.mapPoint.mapPointGeo.longitude)
        }
    };
}

// 단말 사용자가 길게 누른후(long press) 끌어서(dragging) 위치 이동 가능한 POI Item의 위치를 이동시킨 경우
- (void)mapView:(MTMapView*)mapView draggablePOIItem:(MTMapPOIItem*)poiItem movedToNewMapPoint:(MTMapPoint*)newMapPoint {
    id event = @{
        @"action": @"markerMoved",
        @"id": @(poiItem.tag),
        @"coordinate": @{
                @"latitude": @(newMapPoint.mapPointGeo.latitude),
                @"longitude": @(newMapPoint.mapPointGeo.longitude)
        }
    };
}

// 지도 중심 좌표가 이동한 경우
- (void)mapView:(MTMapView*)mapView centerPointMovedTo:(MTMapPoint*)mapCenterPoint {
    id event = @{
        @"action": @"regionChange",
        @"coordinate": @{
                @"latitude": @(mapCenterPoint.mapPointGeo.latitude),
                @"longitude": @(mapCenterPoint.mapPointGeo.longitude)
        }
    };
    [_channel invokeMethod:@"camera#onMove" arguments:@{@"position" : MapPointToJson(mapCenterPoint)}];
}

- (void)mapView:(MTMapView*)mapView singleTapOnMapPoint:(MTMapPoint*)mapPoint {
    [_channel invokeMethod:@"map#onTap" arguments:@{@"position" : MapPointToJson(mapPoint)}];
}

- (void)mapView:(MTMapView*)mapView longPressOnMapPoint:(MTMapPoint*)mapPoint {
  [_channel invokeMethod:@"map#onLongPress" arguments:@{@"position" : MapPointToJson(mapPoint)}];
}

- (void)moveWithCameraUpdate:(MTMapCameraUpdate*)cameraUpdate {
}

- (void)setCompassEnabled:(BOOL)enabled {
    compassEnabled = enabled;
}

- (void)setMapType:(MTMapType)mapType {
    _mapView.baseMapType = mapType;
}

- (void)setCurrentLocationTrackingMode:(MTMapCurrentLocationTrackingMode)currentLocationTrackingMode {
    _mapView.currentLocationTrackingMode = currentLocationTrackingMode;
}

- (void)setHDMapTile:(BOOL)enabled {
    _mapView.useHDMapTile = enabled;
}

- (void)setShowCurrentLocationMarker:(BOOL)enabled {
    showCurrentLocationMarker = enabled;
}

//#pragma mark - Implementations of JSON conversion functions.

static NSArray* MapPointToJson(MTMapPoint* mapPoint) {
    return @[@(mapPoint.mapPointGeo.latitude), @(mapPoint.mapPointGeo.longitude)];
}

static NSDictionary* ToPositon(NSDictionary* position) {
    if (!position) {
        return nil;
    }
    NSArray *target = position[@"target"];
    NSString *zoomLevel = position[@"zoom"];
    
    return @{
        @"lat" : @(ToDouble(target[0])),
        @"lan" : @(ToDouble(target[1])),
        @"zoomLevel" : zoomLevel,
    };
}

static BOOL ToBool(NSNumber* data) { return [KakaoMapJsonConversions toBool:data]; }

static CGPoint ToCGPoint(NSDictionary* json) {
    double x = ToDouble(json[@"x"]);
    double y = ToDouble(json[@"y"]);
    return CGPointMake(x, y);
}

static MTMapType ToMapType(NSNumber* json) {
    int value = ToInt(json);
    return (MTMapType)(value == 0 ? 0 : value);
}

static MTMapCurrentLocationTrackingMode ToCurrentLocationTrackingMode(NSNumber* json) {
    int value = ToInt(json);
    return (MTMapCurrentLocationTrackingMode)(value == 0 ? 0 : value);
}

static MTMapCameraUpdate* ToCameraUpdate(NSArray* data) {
    NSString* update = data[0];
    return nil;
}

static void InterpretMapOptions(NSDictionary* data, id<KakaoMapOptionsSink> sink) {
    NSArray* cameraTargetBounds = data[@"cameraTargetBounds"];
    NSError * err;
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:data options:0 error:&err];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    NSNumber* compassEnabled = data[@"compassEnabled"];
    if (compassEnabled != nil) {
        [sink setCompassEnabled:ToBool(compassEnabled)];
    }
    id mapType = data[@"mapType"];
    if (mapType) {
        [sink setMapType:ToMapType(mapType)];
    }
    id currentLocationTrackingMode = data[@"currentLocationTrackingMode"];
    if (currentLocationTrackingMode) {
        [sink setCurrentLocationTrackingMode:ToCurrentLocationTrackingMode(currentLocationTrackingMode)];
    }
    id hdMapTile = data[@"hdMapTile"];
    if (hdMapTile) {
        [sink setHDMapTile:ToBool(hdMapTile)];
    }
    NSNumber* showCurrentLocationMarker = data[@"showCurrentLocationMarker"];
    if (showCurrentLocationMarker != nil) {
        [sink setShowCurrentLocationMarker:ToBool(showCurrentLocationMarker)];
    }
}

@end

