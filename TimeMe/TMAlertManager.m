//
//  TMAlertManager.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMAlertManager.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NSString+TMTimeIntervalString.h"

#define TWO_MINUTES (2.*60.)
#define ONE_MINUTE (60.)
#define THIRTY_SECONDS (30.)
#define TEN_SECONDS (10.)

const NSString *kTMAlertKey = @"tmalertkey";

@interface TMAlertManager () {
    NSMutableArray *_currentAlerts;
}
- (void)_popTopAlert;
@end

@implementation TMAlertManager

+ (NSArray *)alertIntervalsForTimerLength:(NSTimeInterval)timerLength {
    static NSArray *__baseTimes;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __baseTimes = @[@TWO_MINUTES,@ONE_MINUTE, @THIRTY_SECONDS, @TEN_SECONDS];
    });
    NSMutableArray *alerts = [[NSMutableArray alloc] initWithCapacity:5];
    
    while (timerLength/2. > TWO_MINUTES) {
        NSTimeInterval alertTime = (timerLength/2.);
        alertTime = round(alertTime/15.0);
        alertTime = alertTime * 15;
        [alerts addObject:@(alertTime)];
        timerLength = alertTime;
    }
    for (NSNumber *alertTime in __baseTimes) {
        if ([alertTime doubleValue] < timerLength) {
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

- (instancetype)init {
    self = [super init];
    if (self) {
        _currentAlerts = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startAlerts:(NSArray *)alerts {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    _generatingAlerts = YES;

    NSDate *now = [NSDate date];
    _timerStart = [now timeIntervalSinceReferenceDate];
    _intervalStart = [now timeIntervalSinceReferenceDate];
    //schedule the alerts
    
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
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"self" ascending:YES];
    [_currentAlerts sortUsingDescriptors:@[sortDescriptor]];
    _intervalLength = [[_currentAlerts firstObject] doubleValue];
    [self saveValues];
}

- (void)didFireAlert:(NSNumber *)alert {
    if ([_currentAlerts count]) {
        _intervalStart = [[NSDate date] timeIntervalSinceReferenceDate];
        [self _popTopAlert];
        if ([self.delegate respondsToSelector:@selector(alertManager:didFireAlert:)]) {
            [self.delegate alertManager:self didFireAlert:alert];
        }
    } else {
        _generatingAlerts = NO;
        if ([self.delegate respondsToSelector:@selector(alertManager:didFinishAlerts:)]) {
            [self.delegate alertManager:self didFinishAlerts:alert];
        }
    }
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

- (void)stopAlerts {
    _generatingAlerts = NO;
    [_currentAlerts removeAllObjects];
    [self saveValues];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
}

static NSString *kTimerLengthKey = @"timerlength";
static NSString *kCurrentAlertsKey = @"currentalerts";
static NSString *kStartTimeKey = @"starttime";
static NSString *kGeneratingAlertsKey = @"generatingalerts";
- (void)saveValues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_generatingAlerts forKey:kGeneratingAlertsKey];
    [defaults setDouble:_timerLength forKey:kTimerLengthKey];
    [defaults setObject:_currentAlerts forKey:kCurrentAlertsKey];
    [defaults setDouble:_timerStart forKey:kStartTimeKey];
    [defaults synchronize];
}

- (void)reloadTimeValues {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _generatingAlerts = [defaults boolForKey:kGeneratingAlertsKey];
    _timerLength = [defaults doubleForKey:kTimerLengthKey];
    _timerStart = [defaults doubleForKey:kStartTimeKey];
    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
    if (now > (_timerStart + _timerLength) && _generatingAlerts) { //if the entire timer has expired
        _generatingAlerts = NO;
    } else if (_generatingAlerts){
        [_currentAlerts removeAllObjects];
        [_currentAlerts addObjectsFromArray:[defaults objectForKey:kCurrentAlertsKey]];
        if ([_currentAlerts count]) {
            NSTimeInterval elapsedTime = now - _timerStart;
            _intervalStart = _timerStart;
            _intervalLength = _timerLength;
            while ([_currentAlerts count] && (elapsedTime > [[_currentAlerts firstObject] doubleValue])) {     //check if we have any expired timers
                NSTimeInterval intervalValue = [[_currentAlerts firstObject] doubleValue];
                _intervalStart += intervalValue;
                [self _popTopAlert];
            }
            if (![_currentAlerts count]) {
                _intervalLength = 0;
            }
        }
    }
}

- (void)_popTopAlert {
    NSTimeInterval oldInterval = [[_currentAlerts firstObject] doubleValue];
    [_currentAlerts removeObjectAtIndex:0];
    NSTimeInterval nextInterval = [_currentAlerts count] ? [[_currentAlerts firstObject] doubleValue] : 0;
    _intervalLength = nextInterval - oldInterval;
}



@end
