//
//  TMAlertManager.h
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMIntervalTimer.h"

@class TMAlertManager;

@protocol TMAlertDelegate <NSObject>
- (void)alertManager:(TMAlertManager *)alertManager didFireAlert:(NSNumber *)alert;
- (void)alertManager:(TMAlertManager *)alertManager didFinishAlerts:(NSNumber *)alert;
@end

@interface TMAlertManager : NSObject<TMIntervalTimerDelegate>

+ (instancetype)getInstance;

- (void)startAlerts:(NSArray *)alerts;
- (void)stopAlerts;

- (void)scheduleAlertsForBackground;
- (void)cancelBackgroundAlerts;

@property (nonatomic) NSTimeInterval timerLength;
@property (readonly) TMIntervalTimer *timer;
@property (nonatomic) NSArray *alertIntervals;
@property (nonatomic) BOOL generatingAlerts;
@property (weak) id<TMAlertDelegate>delegate;

@end
