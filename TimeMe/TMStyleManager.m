//
//  TMStyleManager.m
//  TimeMe
//
//  Created by Clark Barry on 10/9/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMStyleManager.h"

@interface TMStyleManager ()
- (UIImage *)_generateCheckedImage;
- (UIImage *)_generateUncheckedImage;
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
        _backgroundColor = [UIColor colorWithRed:0x66/256. green:0xC2/256. blue:0xE0/256. alpha:1];
        _highlightBackgroundColor = [UIColor colorWithRed:0x01/256. green:0x56/256. blue:0x66/256. alpha:.7];
        
        _textColor = [UIColor whiteColor];
        _highlightTextColor = [UIColor colorWithWhite:.9 alpha:1];
        
        _detailTextColor = [UIColor colorWithRed:0xFF/256. green:0xFF/256. blue:0xAF/256. alpha:1];
        _highlightDetailTextColor = [UIColor colorWithWhite:.9 alpha:1];
        
        _navigationBarTintColor = [UIColor whiteColor];
        _navigationBarTitleColor = _backgroundColor;
        
        _buttonColor = [UIColor colorWithRed:0xF6/256. green:0xFA/256. blue:0x91/256. alpha:.9];
        
        _font = [UIFont fontWithName:@"Thonburi" size:20];
        
        _checkedImage = [self _generateCheckedImage];
        _uncheckedImage = [self _generateUncheckedImage];
    }
    return self;
}

static UIImage *__checkImage = nil;
- (UIImage *)_generateCheckedImage {
    if (!__checkImage) {
        static dispatch_once_t onceTokenImage;
        dispatch_once(&onceTokenImage, ^{
            CGFloat height = 44;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(height, height), NO, 0);
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

static UIImage *__uncheckedImage = nil;
- (UIImage *)_generateUncheckedImage {
    if (!__uncheckedImage) {
        static dispatch_once_t onceTokenImage;
        dispatch_once(&onceTokenImage, ^{
            CGFloat height = 44;
            UIGraphicsBeginImageContextWithOptions(CGSizeMake(height, height), NO, 0);
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextSetLineWidth(context, 1);
            CGContextSetStrokeColorWithColor(context, _highlightBackgroundColor.CGColor);
            CGRect ellipseRect = CGRectMake(height/4, height/4, height/2, height/2);
            CGRect fillRect = CGRectInset(ellipseRect, 4, 4);
            CGContextStrokeEllipseInRect(context, fillRect);
            __uncheckedImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
        });
    }
    return __uncheckedImage;
}

@end
