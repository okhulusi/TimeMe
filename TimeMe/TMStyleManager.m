//
//  TMStyleManager.m
//  TimeMe
//
//  Created by Clark Barry on 10/9/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMStyleManager.h"

@implementation TMStyleManager

static TMStyleManager *__instance = nil;
+ (instancetype)getInstance {
    if (!__instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
        __instance = [[TMStyleManager alloc] init];
        });
    }
    return __instance;
}

@end
