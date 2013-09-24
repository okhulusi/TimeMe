//
//  TimerManager.h
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMIntervalTimer;
@protocol TMIntervalTimerDelegate <NSObject>
//fired when a small interval completes
- (void)intervalTimerDidFinishInterval:(TMIntervalTimer *)intervalTimer;
//fired when the timer length expires
- (void)intervalTimerDidFinishTimer:(TMIntervalTimer *)intervalTimer;
@end


@interface TMIntervalTimer : NSObject

@property NSTimeInterval intervalLength;
@property NSTimeInterval timerLength;

@property (weak)id<TMIntervalTimerDelegate>delegate;

- (void)startTimer;
- (void)stopTimer;

@end
