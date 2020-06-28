// Copyright 2020 The yjpark. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

#import "JsonConversions.h"

@implementation KakaoMapJsonConversions

+ (bool)toBool:(NSNumber*)data {
    return data.boolValue;
}

+ (int)toInt:(NSNumber*)data {
    return data.intValue;
}

+ (double)toDouble:(NSNumber*)data {
    return data.doubleValue;
}

+ (float)toFloat:(NSNumber*)data {
    return data.floatValue;
}

+ (UIColor*)toColor:(NSNumber*)numberColor {
    unsigned long value = [numberColor unsignedLongValue];
    return [UIColor colorWithRed:((float)((value & 0xFF0000) >> 16)) / 255.0
                           green:((float)((value & 0xFF00) >> 8)) / 255.0
                            blue:((float)(value & 0xFF)) / 255.0
                           alpha:((float)((value & 0xFF000000) >> 24)) / 255.0];
}

@end
