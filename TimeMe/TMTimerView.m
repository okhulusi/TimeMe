//
//  TMTimerView.m
//  TimeMe
//
//  Created by Clark Barry on 10/10/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimerView.h"
#import "TMIntervalTimer.h"

#define UPDATE_INTERVAL .1

@interface TMTimerView () {
    TMIntervalTimer *_timer;
    BOOL _updating;
    
    UILabel *_timerLabel;
    UILabel *_intervalLabel;
}

- (void)_updateLabels;
@end

@implementation TMTimerView

- (id)initWithFrame:(CGRect)frame intervalTimer:(TMIntervalTimer *)timer {
    self = [super initWithFrame:frame];
    if (self) {
        _timer = timer;
        _updating = NO;
        
        [self setBackgroundColor:[UIColor blueColor]];
        //layout labels
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {

}

- (void)beginUpdating {

}

- (void)_updateLabels {
    
}

- (void)endUpdating {
    
}


@end
