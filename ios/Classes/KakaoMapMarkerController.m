// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "KakaoMapMarkerController.h"
#import "JsonConversions.h"

static UIImage* ExtractIcon(NSObject<FlutterPluginRegistrar>* registrar, NSArray* icon);
static void InterpretInfoWindow(id<KakaoMapMarkerOptionsSink> sink, NSDictionary* data);

@implementation KakaoMapMarkerController {
  MTMapPOIItem* _marker;
  MTMapView* _mapView;
  BOOL _consumeTapEvents;
}
- (instancetype)initMarkerWithPosition:(MTMapPointGeo)position
                              markerId:(NSString*)markerId
                               mapView:(MTMapView*)mapView {
  self = [super init];
  if (self) {
    _mapView = mapView;
      _marker = [MTMapPOIItem poiItem];
      _marker.userObject = markerId;
      [_mapView addPOIItems:[NSArray arrayWithObjects:_marker, nil]];
    _consumeTapEvents = NO;
  }
  return self;
}
- (void)showInfoWindow {
}
- (void)hideInfoWindow {
}
- (BOOL)consumeTapEvents {
  return _consumeTapEvents;
}
- (void)removeMarker {
    [_mapView removePOIItem:_marker];
}
- (void)onMarkerTab {
}

#pragma mark - KakaoMapMarkerOptionsSink methods

- (void)setConsumeTapEvents:(BOOL)consumes {
  _consumeTapEvents = consumes;
}
- (void)setDraggable:(BOOL)draggable {
    if(draggable) {
        _marker.draggable = YES;
    } else {
        _marker.draggable = NO;
    }
}
- (void)setFlat:(BOOL)flat {
}
- (void)setIcon:(UIImage*)icon {
}
- (void)setInfoWindowAnchor:(CGPoint)anchor {
}
- (void)setInfoWindowTitle:(NSString*)title snippet:(NSString*)snippet {
  _marker.itemName = title;
}
- (void)setPosition:(MTMapPoint*)position {
    _marker.mapPoint = position;
}
- (void)setRotation:(CLLocationDegrees)rotation {
  _marker.rotation = rotation;
}
- (void)setMarkerType:(int)markerType {
    MTMapPOIItemMarkerType type;
    if (markerType == 0) {
        type = MTMapPOIItemMarkerTypeBluePin;
    } else if (markerType == 1) {
        type = MTMapPOIItemMarkerTypeRedPin;
    } else if (markerType == 2) {
        type = MTMapPOIItemMarkerTypeYellowPin;
    } else {
    }
    _marker.markerType = MTMapPOIItemMarkerTypeBluePin;
}
- (void)setMarkerSelectedType:(int)markerSelectedType {
    MTMapPOIItemMarkerSelectedType type;
       if (markerSelectedType == 0) {
           type = MTMapPOIItemMarkerSelectedTypeNone;
       } else if (markerSelectedType == 1) {
           type = MTMapPOIItemMarkerSelectedTypeBluePin;
       } else if (markerSelectedType == 2) {
           type = MTMapPOIItemMarkerSelectedTypeRedPin;
       } else if (markerSelectedType == 3) {
           type = MTMapPOIItemMarkerSelectedTypeYellowPin;
       } else {
       }
       _marker.markerSelectedType = MTMapPOIItemMarkerSelectedTypeYellowPin;
}
@end

static double ToDouble(NSNumber* data) { return [KakaoMapJsonConversions toDouble:data]; }

static float ToFloat(NSNumber* data) { return [KakaoMapJsonConversions toFloat:data]; }

static MTMapPoint* ToLocation(NSArray* data) {
    return [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake([KakaoMapJsonConversions toFloat:data[0]], [KakaoMapJsonConversions toFloat:data[1]])];
}

static int ToInt(NSNumber* data) { return [KakaoMapJsonConversions toInt:data]; }

static BOOL ToBool(NSNumber* data) { return [KakaoMapJsonConversions toBool:data]; }

static void InterpretMarkerOptions(NSDictionary* data, id<KakaoMapMarkerOptionsSink> sink,
                                   NSObject<FlutterPluginRegistrar>* registrar) {
  NSNumber* alpha = data[@"alpha"];
  if (alpha != nil) {
  }
  NSArray* anchor = data[@"anchor"];
  if (anchor) {
  }
  NSNumber* draggable = data[@"draggable"];
  if (draggable != nil) {
    [sink setDraggable:ToBool(draggable)];
  }
  NSArray* icon = data[@"icon"];
  if (icon) {
    UIImage* image = ExtractIcon(registrar, icon);
    [sink setIcon:image];
  }
  NSNumber* flat = data[@"flat"];
  if (flat != nil) {
    [sink setFlat:ToBool(flat)];
  }
  NSNumber* consumeTapEvents = data[@"consumeTapEvents"];
  if (consumeTapEvents != nil) {
    [sink setConsumeTapEvents:ToBool(consumeTapEvents)];
  }
  InterpretInfoWindow(sink, data);
  NSArray* position = data[@"position"];
  if (position) {
    [sink setPosition:ToLocation(position)];
  }
  NSNumber* rotation = data[@"rotation"];
  if (rotation != nil) {
    [sink setRotation:ToDouble(rotation)];
  }
  NSNumber* visible = data[@"visible"];
  if (visible != nil) {
  }
  NSNumber* zIndex = data[@"zIndex"];
  if (zIndex != nil) {
  }
  
    NSNumber* markerType = data[@"markerType"];
    if (markerType != nil) {
      [sink setMarkerType:ToInt(markerType)];
    }
    
    NSNumber* markerSelectedType = data[@"markerSelectedType"];
       if (markerType != nil) {
         [sink setMarkerSelectedType:ToInt(markerSelectedType)];
       }
}

static void InterpretInfoWindow(id<KakaoMapMarkerOptionsSink> sink, NSDictionary* data) {
  NSDictionary* infoWindow = data[@"infoWindow"];
  if (infoWindow) {
    NSString* title = infoWindow[@"title"];
    NSString* snippet = infoWindow[@"snippet"];
    if (title) {
      [sink setInfoWindowTitle:title snippet:snippet];
    }
    NSArray* infoWindowAnchor = infoWindow[@"infoWindowAnchor"];
    if (infoWindowAnchor) {
    }
  }
}

static UIImage* scaleImage(UIImage* image, NSNumber* scaleParam) {
  double scale = 1.0;
  if ([scaleParam isKindOfClass:[NSNumber class]]) {
    scale = scaleParam.doubleValue;
  }
  if (fabs(scale - 1) > 1e-3) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * scale)
                         orientation:(image.imageOrientation)];
  }
  return image;
}

static UIImage* ExtractIcon(NSObject<FlutterPluginRegistrar>* registrar, NSArray* iconData) {
  UIImage* image;
  if ([iconData.firstObject isEqualToString:@"defaultMarker"]) {
    CGFloat hue = (iconData.count == 1) ? 0.0f : ToDouble(iconData[1]);
  } else if ([iconData.firstObject isEqualToString:@"fromAsset"]) {
    if (iconData.count == 2) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
    } else {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]
                                                   fromPackage:iconData[2]]];
    }
  } else if ([iconData.firstObject isEqualToString:@"fromAssetImage"]) {
    if (iconData.count == 3) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
      NSNumber* scaleParam = iconData[2];
      image = scaleImage(image, scaleParam);
    } else {
      NSString* error =
          [NSString stringWithFormat:@"'fromAssetImage' should have exactly 3 arguments. Got: %lu",
                                     (unsigned long)iconData.count];
      NSException* exception = [NSException exceptionWithName:@"InvalidBitmapDescriptor"
                                                       reason:error
                                                     userInfo:nil];
      @throw exception;
    }
  } else if ([iconData[0] isEqualToString:@"fromBytes"]) {
    if (iconData.count == 2) {
      @try {
        FlutterStandardTypedData* byteData = iconData[1];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        image = [UIImage imageWithData:[byteData data] scale:screenScale];
      } @catch (NSException* exception) {
        @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                       reason:@"Unable to interpret bytes as a valid image."
                                     userInfo:nil];
      }
    } else {
      NSString* error = [NSString
          stringWithFormat:@"fromBytes should have exactly one argument, the bytes. Got: %lu",
                           (unsigned long)iconData.count];
      NSException* exception = [NSException exceptionWithName:@"InvalidByteDescriptor"
                                                       reason:error
                                                     userInfo:nil];
      @throw exception;
    }
  }

  return image;
}

@implementation MarkersController {
  NSMutableDictionary* _markerIdToController;
  FlutterMethodChannel* _methodChannel;
  NSObject<FlutterPluginRegistrar>* _registrar;
  MTMapView* _mapView;
}
- (instancetype)init:(FlutterMethodChannel*)methodChannel
             mapView:(MTMapView*)mapView
           registrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  self = [super init];
  if (self) {
    _methodChannel = methodChannel;
    _mapView = mapView;
    _markerIdToController = [NSMutableDictionary dictionaryWithCapacity:1];
    _registrar = registrar;
  }
  return self;
}
- (void)addMarkers:(NSArray*)markersToAdd {
  for (NSDictionary* marker in markersToAdd) {
      NSArray *position = marker[@"position"];
      float latdouble = [position[0] floatValue];
      float londouble = [position[1] floatValue];
    NSString* markerId = [MarkersController getMarkerId:marker];
      MTMapPointGeo mapPointGeo = MTMapPointGeoMake(latdouble, londouble);
    KakaoMapMarkerController* controller =
        [[KakaoMapMarkerController alloc] initMarkerWithPosition:mapPointGeo
                                                            markerId:markerId
                                                             mapView:_mapView];
    InterpretMarkerOptions(marker, controller, _registrar);
    _markerIdToController[markerId] = controller;
  }
}
- (void)changeMarkers:(NSArray*)markersToChange {
  for (NSDictionary* marker in markersToChange) {
    NSString* markerId = [MarkersController getMarkerId:marker];
    KakaoMapMarkerController* controller = _markerIdToController[markerId];
    if (!controller) {
      continue;
    }
          InterpretMarkerOptions(marker, controller, _registrar);
  }
}
- (void)removeMarkerIds:(NSArray*)markerIdsToRemove {
  for (NSString* markerId in markerIdsToRemove) {
    if (!markerId) {
      continue;
    }
    KakaoMapMarkerController* controller = _markerIdToController[markerId];
    if (!controller) {
      continue;
    }
    [controller removeMarker];
    [_markerIdToController removeObjectForKey:markerId];
  }
}
- (BOOL)onMarkerTap:(NSString*)markerId {
  if (!markerId) {
    return NO;
  }
  KakaoMapMarkerController* controller = _markerIdToController[markerId];
  if (!controller) {
    return NO;
  }
  [controller onMarkerTab];
  [_methodChannel invokeMethod:@"marker#onTap" arguments:@{@"markerId" : markerId}];
  return controller.consumeTapEvents;
}
- (void)onMarkerDragEnd:(NSString*)markerId coordinate:(CLLocationCoordinate2D)coordinate {
  if (!markerId) {
    return;
  }
  KakaoMapMarkerController* controller = _markerIdToController[markerId];
  if (!controller) {
    return;
  }
}
- (void)onInfoWindowTap:(NSString*)markerId {
  if (markerId && _markerIdToController[markerId]) {
    [_methodChannel invokeMethod:@"infoWindow#onTap" arguments:@{@"markerId" : markerId}];
  }
}
- (void)showMarkerInfoWindow:(NSString*)markerId result:(FlutterResult)result {
  KakaoMapMarkerController* controller = _markerIdToController[markerId];
  if (controller) {
    [controller showInfoWindow];
    result(nil);
  } else {
    result([FlutterError errorWithCode:@"Invalid markerId"
                               message:@"showInfoWindow called with invalid markerId"
                               details:nil]);
  }
}
- (void)hideMarkerInfoWindow:(NSString*)markerId result:(FlutterResult)result {
  KakaoMapMarkerController* controller = _markerIdToController[markerId];
  if (controller) {
    [controller hideInfoWindow];
    result(nil);
  } else {
    result([FlutterError errorWithCode:@"Invalid markerId"
                               message:@"hideInfoWindow called with invalid markerId"
                               details:nil]);
  }
}
- (void)isMarkerInfoWindowShown:(NSString*)markerId result:(FlutterResult)result {
  KakaoMapMarkerController* controller = _markerIdToController[markerId];
  if (controller) {
    result(@([controller isInfoWindowShown]));
  } else {
    result([FlutterError errorWithCode:@"Invalid markerId"
                               message:@"isInfoWindowShown called with invalid markerId"
                               details:nil]);
  }
}
+ (NSString*)getMarkerId:(NSDictionary*)marker {
  return marker[@"markerId"];
}
@end
