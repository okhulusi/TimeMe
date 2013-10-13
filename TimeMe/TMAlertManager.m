//
//  TMAlertManager.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMAlertManager.h"
#define TWO_MINUTES 2.*60.
#define ONE_MINUTE 60.
#define THIRTY_SECONDS 30.
#define TEN_SECONDS 10.

@implementation TMAlertManager

+ (NSArray *)alertIntervalsForCountdown:(NSTimeInterval)countdown {
    NSMutableArray *alerts = [[NSMutableArray alloc] initWithCapacity:5];
    while (countdown >= TWO_MINUTES) {
        
    }
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
