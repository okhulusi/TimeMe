//
//  NSString+TMTimeIntervalString.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "NSString+TMTimeIntervalString.h"

@implementation NSString (TMTimeIntervalString)

+ (NSString *)stringForTimeInterval:(NSTimeInterval)timeInterval {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:startDate];
    
    unsigned int conversionFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [calender components:conversionFlags fromDate:startDate toDate:endDate options:0];
    
    NSString *intervalString = @"";
    if([components hour]){
        intervalString = [NSString stringWithFormat:@"%ld hours", (long)[components hour]];
        if ([components hour] != 1) {
            intervalString = [intervalString stringByAppendingString:@"s"];
        }
    }
    
    if([components minute]){
        NSString *minuteString = [NSString stringWithFormat:@"%ld minute",(long)[components minute]];
        if ([components minute] != 1) {
            minuteString = [minuteString stringByAppendingString:@"s"];
        }
        if ([intervalString length]) {
            intervalString = [intervalString stringByAppendingString:@", "];
        }
        intervalString = [intervalString stringByAppendingString:minuteString];
    }
    
    NSString *secondString = [NSString stringWithFormat:@"%ld second",(long)[components second]];
    if ([components second] != 1) {
        secondString = [secondString stringByAppendingString:@"s"];
    }
    if ([intervalString length]) {
        intervalString = [intervalString stringByAppendingString:@", "];
    }
    if ([components second] || ![intervalString length]) {
        intervalString = [intervalString stringByAppendingString:secondString];
    }
    
    return intervalString;
}
@end
