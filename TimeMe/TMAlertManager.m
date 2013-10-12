//
//  TMAlertManager.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMAlertManager.h"

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

- (void)scheduleAlertsForLength:(NSTimeInterval)length interval:(NSTimeInterval)interval {
    
}


- (void)scheduleAlertsForBackground {

}

- (void)cancelBackgroundAlerts {

}
@end
