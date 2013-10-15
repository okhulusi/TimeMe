//
//  TMAlertManager.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMAlertManager.h"

#import "NSMutableArray+TMFrontLoading.h"
#import "NSString+TMTimeIntervalString.h"

#define TWO_MINUTES (2.*60.)
#define ONE_MINUTE (60.)
#define THIRTY_SECONDS (30.)
#define TEN_SECONDS (10.)

const NSString *kTMAlertKey = @"tmalertkey";

@interface TMAlertManager () {
    NSMutableArray *_currentAlerts;
}

- (NSArray *)_alertIntervalsForCountdown:(NSTimeInterval)countdown;
@end

@implementation TMAlertManager

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

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentAlerts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)_alertIntervalsForCountdown:(NSTimeInterval)countdown {
    static NSArray *__baseTimes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __baseTimes = @[@TWO_MINUTES,@ONE_MINUTE, @THIRTY_SECONDS, @TEN_SECONDS];
    });
    NSMutableArray *alerts = [[NSMutableArray alloc] initWithCapacity:5];
    
    while (countdown/2. > TWO_MINUTES) {
        NSTimeInterval alertTime = (countdown/2.);
        alertTime = round(alertTime/15.0);
        alertTime = alertTime * 15;
        [alerts addObject:@(alertTime)];
        countdown = alertTime;
    }
    for (NSNumber *alertTime in __baseTimes) {
        if ([alertTime doubleValue] < countdown) {
            [alerts addObject:alertTime];
        }
    }
    return alerts;
}

- (void)setTimerLength:(NSTimeInterval)timerLength {
    NSAssert(!_generatingAlerts, @"Tried to change timerLength when running");
    _timerLength = timerLength;
    _alertIntervals = [self _alertIntervalsForCountdown:_timerLength];
}

- (void)startAlerts:(NSArray *)alerts {
    _generatingAlerts = YES;

    NSDate *now = [NSDate date];
    _timerStart = [now timeIntervalSinceReferenceDate];
    _intervalStart = [now timeIntervalSinceReferenceDate];
    //schedule the alerts
    if ([alerts count]) {
        _intervalLength = _timerLength - [[alerts firstObject] doubleValue];
    }
    
    [_currentAlerts removeAllObjects];
    for (NSNumber *alertInterval in alerts) {
        NSTimeInterval delay = _timerLength - [alertInterval doubleValue];
        [_currentAlerts addObject:@(delay)];
        NSDate *alertDate = [NSDate dateWithTimeInterval:delay sinceDate:now];
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        [notification setFireDate:alertDate];
        [notification setAlertBody:[NSString stringForTimeInterval:[alertInterval doubleValue] style:TMTimeIntervalStringDigital]];
        [notification setUserInfo:@{kTMAlertKey:alertInterval}];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    UILocalNotification *finalNotification = [[UILocalNotification alloc] init];
    NSDate *finalDate = [NSDate dateWithTimeInterval:_timerLength sinceDate:now];
    [finalNotification setFireDate:finalDate];
    [finalNotification setAlertBody:@"00:00"];
    [[UIApplication sharedApplication] scheduleLocalNotification:finalNotification];
}

- (void)didFireAlert:(NSNumber *)alert {
    if ([_currentAlerts count]) {
        NSTimeInterval delay = _timerLength - [alert doubleValue];
        NSAssert(delay == [[_currentAlerts firstObject] doubleValue], @"Alerts are out of order");
        _intervalStart = [[NSDate date] timeIntervalSinceReferenceDate];
        NSTimeInterval oldInterval = [[_currentAlerts firstObject] doubleValue];
        [_currentAlerts removeObjectAtIndex:0];
        NSTimeInterval nextInterval = [_currentAlerts count] ? [[_currentAlerts firstObject] doubleValue] : _timerLength;
        _intervalLength = nextInterval - oldInterval;
        //set up the new delay
    } else {
        //we're done
        _generatingAlerts = NO;
    }
}

- (void)stopAlerts {
    _generatingAlerts = NO;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

- (void)reloadTimeValues {
    //check if we have any expired timers
}

- (void)saveValues {
    //write them back
}

@end
