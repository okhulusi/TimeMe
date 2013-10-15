//
//  TimerManager.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import "TMIntervalTimer.h"

@interface TMIntervalTimer () {
    NSTimeInterval _timerStart;
    NSTimeInterval _intervalStart;
}
- (void)_updateTimers;
@end

@implementation TMIntervalTimer

@synthesize timerLength = _timerLength;

- (void) startTimer {
    _running = YES;
    _timerStart = [NSDate timeIntervalSinceReferenceDate];
    _intervalStart = _timerStart;
    [self _updateTimers];
}

- (void) stopTimer {
    _running = NO;
}

- (void)_updateTimers {
    if (_running) {
        NSTimeInterval currentTime = [NSDate timeIntervalSinceReferenceDate];
        
        if ([_intervals count]) {
            _intervalElapsedTime = currentTime - _intervalStart;
            NSTimeInterval currentInterval = [[_intervals firstObject] doubleValue];
            if (_intervalElapsedTime >= currentInterval) {
                _intervalStart = currentTime;
                [_intervals removeObjectAtIndex:0];
                _intervalLength = [_intervals count] ? [[_intervals firstObject] doubleValue] : 0;
                if ([self.delegate respondsToSelector:@selector(intervalTimerDidFinishInterval:)]) {
                    [self.delegate intervalTimerDidFinishInterval:self];
                }
            }
        }
        
        _timerElapsedTime = currentTime - _timerStart;
        if (_timerElapsedTime >= _timerLength) {
            _running = NO;
            if ([self.delegate respondsToSelector:@selector(intervalTimerDidFinishTimer:)]) {
                [self.delegate intervalTimerDidFinishTimer:self];
            }
        }
        [self performSelector:@selector(_updateTimers) withObject:nil afterDelay:.1];
    }
}

@end
