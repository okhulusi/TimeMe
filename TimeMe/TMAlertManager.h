//
//  TMAlertManager.h
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMAlertManager : NSObject

+ (instancetype)getInstance;
- (void)scheduleAlertsForLength:(NSTimeInterval)length interval:(NSTimeInterval)interval;

- (void)scheduleAlertsForBackground;
- (void)cancelBackgroundAlerts;

@end