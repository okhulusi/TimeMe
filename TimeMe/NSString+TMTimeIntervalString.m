//
//  NSString+TMTimeIntervalString.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "NSString+TMTimeIntervalString.h"

@implementation NSString (TMTimeIntervalString)

+ (NSString *)stringForTimeInterval:(NSTimeInterval)timeInterval style:(TMTimeIntervalStringStyle)style {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:startDate];
    
    unsigned int conversionFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [calender components:conversionFlags fromDate:startDate toDate:endDate options:0];
    NSString *intervalString = @"";
    if (style == TMTimeIntervalStringWords) {
        if([components hour]){
            intervalString = [NSString stringWithFormat:@"%ld hr",(long)[components hour]];
            if ([components hour] != 1) {
                intervalString = [intervalString stringByAppendingString:@"s"];
            }
        }
        
        if([components minute]){
            NSString *minuteString = [NSString stringWithFormat:@"%ld min",(long)[components minute]];
            if ([components minute] != 1) {
                minuteString = [minuteString stringByAppendingString:@"s"];
            }
            if ([intervalString length]) {
                intervalString = [intervalString stringByAppendingString:@", "];
            }
            intervalString = [intervalString stringByAppendingString:minuteString];
        }
        
        NSString *secondString = [NSString stringWithFormat:@"%ld sec",(long)[components second]];
        if ([components second] != 1) {
            secondString = [secondString stringByAppendingString:@"s"];
        }
        if ([intervalString length] && [components second]) {
            intervalString = [intervalString stringByAppendingString:@", "];
        }
        if ([components second] || ![intervalString length]) {
            intervalString = [intervalString stringByAppendingString:secondString];
        }
    } else if (style == TMTimeIntervalStringDigital) {
        if ([components hour]) {
            intervalString = [intervalString stringByAppendingFormat:@"%02ld:",(long)[components hour]];
        }
        if ([components minute] || [intervalString length]) {
            intervalString = [intervalString stringByAppendingFormat:@"%02ld",(long)[components minute]];
        }
        intervalString = [intervalString stringByAppendingFormat:@":%02ld",(long)[components second]];
    }
    return intervalString;
}
@end
