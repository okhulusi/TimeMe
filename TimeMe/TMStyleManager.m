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

- (id)init {
    self = [super init];
    if (self) {
        _backgroundColor = [UIColor colorWithWhite:.2 alpha:1];
        _highlightBackgroundColor = [UIColor colorWithWhite:.8 alpha:1];
        
        _textColor = [UIColor whiteColor];
        _highlightTextColor = [_backgroundColor copy];
        
        _detailTextColor = [UIColor colorWithRed:0xC2/256. green:0x77/256. blue:0x9A/256. alpha:1];
        
        _navigationBarTintColor = [UIColor colorWithRed:0x79/256. green:0x60/256. blue:0x60/256. alpha:1];
        _navigationBarTitleColor = [UIColor whiteColor];
    }
    return self;
}

@end
