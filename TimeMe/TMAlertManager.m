//
//  TMAlertManager.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMAlertManager.h"
#import "NSMutableArray+TMFrontLoading.h"

#define TWO_MINUTES (2.*60.)
#define ONE_MINUTE (60.)
#define THIRTY_SECONDS (30.)
#define TEN_SECONDS (10.)

@implementation TMAlertManager

+ (NSArray *)alertIntervalsForCountdown:(NSTimeInterval)countdown {
    static NSArray *__baseTimes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __baseTimes = @[@TEN_SECONDS,@THIRTY_SECONDS,@ONE_MINUTE,@TWO_MINUTES];
    });
    NSMutableArray *alerts = [[NSMutableArray alloc] initWithCapacity:5];

    while (countdown/2. > TWO_MINUTES) {
        [alerts addObject:@(countdown/2.)];
        countdown = countdown/2.;
    }
    for (NSNumber *alertTime in __baseTimes) {
        if ([alertTime doubleValue] < countdown) {
            [alerts addObject:alertTime];
        }
    }
    return alerts;
}

static TMAlertManager *__instance = nil;
+ (instancetype)getInstance {
    if (!__instance) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            __instance = [[TMAlertManager alloc] init];
        });
    }
    return __instance;
}

- (void)scheduleAlertsForLength:(NSTimeInterval)length interval:(NSTimeInterval)interval {
    
}


- (void)scheduleAlertsForBackground {

}

- (void)cancelBackgroundAlerts {

}
@end
