//
//  TMStyleManager.m
//  TimeMe
//
//  Created by Clark Barry on 10/9/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMStyleManager.h"

@interface TMStyleManager ()
- (UIImage *)_generateCheckImage;
@end

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
        _backgroundColor = [UIColor colorWithRed:0x4A/256. green:0x42/256. blue:0x51/256. alpha:1];
        _highlightBackgroundColor = [UIColor colorWithRed:0x85/256. green:0x75/256. blue:0x75/256. alpha:1];
        
        _textColor = [UIColor colorWithWhite:.85 alpha:1];
        _highlightTextColor = _backgroundColor;
        
        _detailTextColor = [UIColor colorWithRed:0xE9/256. green:0xE5/256. blue:0x8E/256. alpha:1];
        
        _navigationBarTintColor = [UIColor colorWithRed:0xE9/256. green:0xE5/256. blue:0x8E/256. alpha:1];
        _navigationBarTitleColor = _backgroundColor;
        
        _font = [UIFont fontWithName:@"ChalkboardSE-Bold" size:20];
        
        _checkImage = [self _generateCheckImage];
    }
    return self;
}

static UIImage *__checkImage = nil;
- (UIImage *)_generateCheckImage {
    if (!__checkImage) {
        static dispatch_once_t onceTokenImage;
        dispatch_once(&onceTokenImage, ^{
            CGFloat height = 44;
            UIGraphicsBeginImageContext(CGSizeMake(height, height));
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGRect ellipseRect = CGRectMake(height/4, height/4, height/2, height/2);
            CGRect fillRect = CGRectInset(ellipseRect, 1, 1);
            CGContextSetFillColorWithColor(context, _detailTextColor.CGColor);
            CGContextFillEllipseInRect(context, fillRect);
            CGContextFillPath(context);
            __checkImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        });
    }
    return __checkImage;
}

@end
