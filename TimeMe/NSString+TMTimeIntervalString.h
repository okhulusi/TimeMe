//
//  NSString+TMTimeIntervalString.h
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

enum{
    TMTimeIntervalStringWords,
    TMTimeIntervalStringDigital
} typedef TMTimeIntervalStringStyle;

@interface NSString (TMTimeIntervalString)
+ (NSString *)stringForTimeInterval:(NSTimeInterval)timeInterval style:(TMTimeIntervalStringStyle)style;
@end
