//
//  TMTimerView.m
//  TimeMe
//
//  Created by Clark Barry on 10/10/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimerView.h"
#import "TMStyleManager.h"
#import "TMAlertManager.h"
#import "NSString+TMTimeIntervalString.h"

#define UPDATE_INTERVAL .05

@interface TMTimerView () {
    BOOL _updating;
    
    UILabel *_timerLabel;
    UILabel *_intervalLabel;
}

- (void)_updateLabels;
@end

@implementation TMTimerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _updating = NO;
        
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        CGRect labelFrame = CGRectMake(0, 0, frame.size.width, frame.size.height/2);
        _timerLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [_timerLabel setTextAlignment:NSTextAlignmentCenter];
        [_timerLabel setFont:[styleManager.font fontWithSize:70]];
        [_timerLabel setTextColor:styleManager.textColor];
        [_timerLabel setHighlightedTextColor:styleManager.highlightTextColor];
        [_timerLabel setText:@"00:00:00"];
        [_timerLabel sizeToFit];
        [_timerLabel setFrame:CGRectMake(0, frame.size.height/2 - _timerLabel.frame.size.height,
                                         frame.size.width, _timerLabel.frame.size.height)];
        [self addSubview:_timerLabel];
        
        labelFrame = CGRectMake(0, frame.size.height/2, frame.size.width, frame.size.height/2);
        _intervalLabel = [[UILabel alloc] initWithFrame:labelFrame];
        [_intervalLabel setTextAlignment:NSTextAlignmentCenter];
        [_intervalLabel setTextColor:styleManager.textColor];
        [_intervalLabel setHighlightedTextColor:styleManager.highlightTextColor];
        [_intervalLabel setFont:[styleManager.font fontWithSize:60]];
        [_intervalLabel setText:@"00:00:00"];
        [self addSubview:_intervalLabel];
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted {
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    UIColor *backgroundColor = highlighted ? styleManager.highlightBackgroundColor : styleManager.backgroundColor;
    [self setBackgroundColor:backgroundColor];
    [_timerLabel setHighlighted:highlighted];
    [_intervalLabel setHighlighted:highlighted];
}

- (void)beginUpdating {
    _updating = YES;
    [self _updateLabels];
}

- (void)_updateLabels {
    NSTimeInterval now = [[NSDate date] timeIntervalSinceReferenceDate];
    
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    NSTimeInterval elapsedTimer = now - alertManager.timerStart;
    NSTimeInterval timerLeft = alertManager.timerLength - elapsedTimer;
    if (timerLeft < 0) {
        timerLeft = 0;
    }
    NSString *timerText = [NSString stringForTimeInterval:timerLeft style:TMTimeIntervalStringDigital];
    
    
    NSTimeInterval elapsedInterval = now - (alertManager.intervalStart);
    NSTimeInterval intervalLeft = alertManager.intervalLength - elapsedInterval;
    if (intervalLeft < 0) {
        intervalLeft = 0;
    }
    NSString *intervalText = [NSString stringForTimeInterval:intervalLeft style:TMTimeIntervalStringDigital];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timerLabel setText:timerText];
        [_intervalLabel setText:intervalText];
    });
    if (_updating) {
        [self performSelector:@selector(_updateLabels) withObject:nil afterDelay:UPDATE_INTERVAL];
    }
}

- (void)endUpdating {
    _updating = NO;
}


@end
