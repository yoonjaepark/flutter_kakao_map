// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import <Flutter/Flutter.h>
#import <DaumMap/MTMapView.h>
#import <MapKit/MapKit.h>

@interface KakaoMapJsonConversions : NSObject
+ (bool)toBool:(NSNumber*)data;
+ (int)toInt:(NSNumber*)data;
+ (double)toDouble:(NSNumber*)data;
+ (float)toFloat:(NSNumber*)data;
+ (UIColor*)toColor:(NSNumber*)data;
//+ (CLLocationCoordinate2D)toLocation:(NSArray*)data;
//+ (CGPoint)toPoint:(NSArray*)data;
//+ (NSArray*)positionToJson:(CLLocationCoordinate2D)position;
//+ (NSArray<CLLocation*>*)toPoints:(NSArray*)data;
@end
