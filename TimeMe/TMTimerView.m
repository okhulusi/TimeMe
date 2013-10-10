//
//  TMTimerView.m
//  TimeMe
//
//  Created by Clark Barry on 10/10/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimerView.h"
#import "TMIntervalTimer.h"
#import "TMStyleManager.h"

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
        
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        CGRect labelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        _timerLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [_timerLabel setTextAlignment:NSTextAlignmentCenter];
        [_timerLabel setFont:[styleManager.font fontWithSize:70]];
        [_timerLabel setText:@"00:00:00"];
        [_timerLabel sizeToFit];
        [_timerLabel setFrame:CGRectMake(0, frame.size.height/2 - _timerLabel.frame.size.height,
                                         frame.size.width, _timerLabel.frame.size.height)];
        [self addSubview:_timerLabel];
        
        labelFrame = CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2);
        _intervalLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [_intervalLabel setTextAlignment:NSTextAlignmentCenter];
        [_intervalLabel setFont:[styleManager.font fontWithSize:60]];
        [_intervalLabel setText:@"00:00:00"];
        [self addSubview:_intervalLabel];
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
