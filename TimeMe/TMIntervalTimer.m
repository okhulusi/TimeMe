//
//  TimerManager.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMIntervalTimer.h"


/*  User sets interval for a duration,
    option to vibrate twice on last ring.
    When app is awake, flash on interval.
*/

@implementation TMIntervalTimer

@synthesize intervalLength = _intervalLength;
@synthesize timerLength = _timerLength;

- (id) init{
    if(self = [super init]){
        
    }
    
    return self;
}

- (void) update:(NSInteger)dt{
    
}

@end
