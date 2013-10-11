//
//  TMStyleManager.h
//  TimeMe
//
//  Created by Clark Barry on 10/9/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMStyleManager : NSObject

+ (instancetype)getInstance;

@property (readonly) UIColor *backgroundColor;
@property (readonly) UIColor *highlightBackgroundColor;

@property (readonly) UIColor *textColor;
@property (readonly) UIColor *highlightTextColor;

@property (readonly) UIColor *detailTextColor;
@property (readonly) UIColor *highlightDetailTextColor;

@property (readonly) UIColor *navigationBarTintColor;
@property (readonly) UIColor *navigationBarTitleColor;


@end
