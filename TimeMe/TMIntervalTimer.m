//
//  TimerManager.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "TMIntervalTimer.h"


/*  User sets interval for a duration,
    option to vibrate twice on last ring.
    When app is awake, flash on interval.
*/

@implementation TMIntervalTimer

@synthesize timerLength = _timerLength;
@synthesize intervalLength = _intervalLength;

@synthesize counter = _counter;

- (id) init
{
    if(self = [super init]){
        _counter = 0;
    }
    
    return self;
}

- (id) initWithTimerLength: (NSTimeInterval)timerLength andIntervalLength: (NSTimeInterval)intervalLength
{
    if(self = [super init]){
        _timerLength = timerLength;
        _intervalLength = intervalLength;
    }
    
    return self;
}

- (void) startTimer
{
    
}

- (void) stopTimer
{
    
}

//pseudo code, not to be implemented
- (void) update:(NSInteger)dt
{
    _counter+=dt;
    if((int)_counter % (int)_timerLength == 0){
        for(int i = 0; i < 4; i++){
            AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
            wait(1);
            //end timer entirely.
        }
    }
    
    // Vibrate once per interval
    if((int)_counter % (int)_intervalLength == 0){
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
    
    //Vibrate an additional time if this is the last interval
    if((int)_counter % (int)_intervalLength == 0 && _timerLength - _counter == _intervalLength){
        AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    }
}

@end
