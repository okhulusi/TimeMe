//
//  NSString+TMTimeIntervalString.h
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TMTimeIntervalString)
+ (NSString *)stringForTimeInterval:(NSTimeInterval)timeInterval;
@end
