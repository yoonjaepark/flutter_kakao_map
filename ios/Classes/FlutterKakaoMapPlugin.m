// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "FlutterKakaoMapPlugin.h"
#import "KakaoMapController.h"

#pragma mark - KakaoMap plugin implementation

@implementation FlutterKakaoMapPlugin {
    NSObject<FlutterPluginRegistrar>* _registrar;
    FlutterMethodChannel* _channel;
    NSMutableDictionary* _mapControllers;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    KakaoMapFactory* kakaoMapFactory = [[KakaoMapFactory alloc] initWithRegistrar:registrar];
    [registrar registerViewFactory:kakaoMapFactory
                            withId:@"plugins.flutter.io/kakao_maps"
  gestureRecognizersBlockingPolicy:
     FlutterPlatformViewGestureRecognizersBlockingPolicyWaitUntilTouchesEnded];
}

- (KakaoMapController*)mapFromCall:(FlutterMethodCall*)call error:(FlutterError**)error {
    id mapId = call.arguments[@"map"];
    KakaoMapController* controller = _mapControllers[mapId];
    if (!controller && error) {
        *error = [FlutterError errorWithCode:@"unknown_map" message:nil details:mapId];
    }
    return controller;
}
@end
