//
//  TMAlertManager.h
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSString *kTMAlertKey;

@class TMAlertManager;

@protocol TMAlertDelegate <NSObject>
- (void)alertManager:(TMAlertManager *)alertManager didFireAlert:(NSNumber *)alert;
- (void)alertManager:(TMAlertManager *)alertManager didFinishAlerts:(NSNumber *)alert;
@end

@interface TMAlertManager : NSObject

+ (NSArray *)alertIntervalsForTimerLength:(NSTimeInterval)timerLength;

+ (instancetype)getInstance;

- (void)startAlerts:(NSArray *)alerts;
- (void)didFireAlert:(NSNumber *)alert;
- (void)stopAlerts;

- (void)reloadTimeValues;
- (void)saveValues;


@property (nonatomic) NSTimeInterval timerLength;
@property (readonly) NSTimeInterval intervalLength;

@property (readonly) NSTimeInterval timerStart;
@property (readonly) NSTimeInterval intervalStart;

@property (nonatomic) BOOL generatingAlerts;
@property (weak) id<TMAlertDelegate>delegate;

@end

