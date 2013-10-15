//
//  TMAlertManager.h
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMAlertManager;
@class TMIntervalTimer;

@protocol TMAlertDelegate <NSObject>
- (void)alertManager:(TMAlertManager *)alertManager didFireAlert:(NSNumber *)alert;
@end

@interface TMAlertManager : NSObject

+ (instancetype)getInstance;

- (void)startAlerts:(NSArray *)alerts;
- (void)stopAlerts;

- (void)scheduleAlertsForBackground;
- (void)cancelBackgroundAlerts;

@property (nonatomic) NSTimeInterval timerLength;
@property (nonatomic) TMIntervalTimer *timer;
@property (nonatomic) NSArray *alertIntervals;
@property (nonatomic) BOOL generatingAlerts;
@property (weak) id<TMAlertDelegate>delegate;

@end
