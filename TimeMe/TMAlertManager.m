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
    if (_generatingAlerts) {
        [self stopAlerts];
    }
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
        [notification setSoundName:UILocalNotificationDefaultSoundName];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
    UILocalNotification *finalNotification = [[UILocalNotification alloc] init];
    NSDate *finalDate = [NSDate dateWithTimeInterval:_timerLength sinceDate:now];
    [finalNotification setFireDate:finalDate];
    [finalNotification setAlertBody:@":00"];
    [finalNotification setSoundName:UILocalNotificationDefaultSoundName];
    [[UIApplication sharedApplication] scheduleLocalNotification:finalNotification];
}

- (void)didFireAlert:(NSNumber *)alert {
    if ([_currentAlerts count]) {
        _intervalStart = [[NSDate date] timeIntervalSinceReferenceDate];
        NSTimeInterval oldInterval = [[_currentAlerts firstObject] doubleValue];
        [_currentAlerts removeObjectAtIndex:0];
        NSTimeInterval nextInterval = [_currentAlerts count] ? [[_currentAlerts firstObject] doubleValue] : _timerLength;
        _intervalLength = nextInterval - oldInterval;
        if ([self.delegate respondsToSelector:@selector(alertManager:didFireAlert:)]) {
            [self.delegate alertManager:self didFireAlert:alert];
        }
    } else {
        _generatingAlerts = NO;
        if ([self.delegate respondsToSelector:@selector(alertManager:didFinishAlerts:)]) {
            [self.delegate alertManager:self didFinishAlerts:alert];
        }
    }

}

- (void)stopAlerts {
    _generatingAlerts = NO;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

static NSString *kTimerLengthKey = @"timerlength";
static NSString *kCurrentAlertsKey = @"currentalerts";
static NSString *kStartTimeKey = @"starttime";
- (void)saveValues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setDouble:_timerLength forKey:kTimerLengthKey];
    [defaults setObject:_currentAlerts forKey:kCurrentAlertsKey];
    [defaults setDouble:_timerStart forKey:kStartTimeKey];
    [defaults synchronize];
}

- (void)reloadTimeValues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _timerLength = [defaults doubleForKey:kTimerLengthKey];
    _timerStart = [defaults doubleForKey:kStartTimeKey];
    
    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
    if (now > (_timerStart + _timerLength)) { //if the entire timer has expired
        _timerLength = 0;
        _timerStart = 0;
        _intervalLength = 0;
        _intervalStart = 0;
    } else {
        _currentAlerts = [[defaults objectForKey:kCurrentAlertsKey] mutableCopy];
        NSTimeInterval elapsedTime = now - _timerStart;
        while ([_currentAlerts count] && (elapsedTime > [[_currentAlerts firstObject] doubleValue])) {     //check if we have any expired timers
            if ([_currentAlerts count] == 1) {
                _intervalStart = [[_currentAlerts firstObject] doubleValue] + _timerStart;
                _intervalLength = _timerLength - [[_currentAlerts firstObject] doubleValue];
            }
            [_currentAlerts removeObjectAtIndex:0];
        }
        if ([_currentAlerts count]) {
            _intervalStart = _timerStart + [[_currentAlerts firstObject] doubleValue];
            if ([_currentAlerts count] > 1) {
                _intervalLength = [[_currentAlerts objectAtIndex:1] doubleValue] - [[_currentAlerts firstObject] doubleValue];
            } else {
                _intervalLength = _timerLength - [[_currentAlerts firstObject] doubleValue];
            }
        }
    }
}



@end
