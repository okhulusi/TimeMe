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
        _timerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_timerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_timerLabel setTextAlignment:NSTextAlignmentCenter];
        [_timerLabel setFont:[styleManager.font fontWithSize:70]];
        [_timerLabel setTextColor:styleManager.textColor];
        [_timerLabel setHighlightedTextColor:styleManager.highlightTextColor];
        [_timerLabel setText:@"00:00:00"];
        [_timerLabel sizeToFit];
        [_timerLabel setFrame:CGRectZero];
        [self addSubview:_timerLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_timerLabel
                                                         attribute:NSLayoutAttributeBaseline
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_timerLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
        
        _intervalLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_intervalLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_intervalLabel setTextAlignment:NSTextAlignmentCenter];
        [_intervalLabel setTextColor:styleManager.textColor];
        [_intervalLabel setHighlightedTextColor:styleManager.highlightTextColor];
        [_intervalLabel setFont:[styleManager.font fontWithSize:60]];
        [_intervalLabel setText:@"00:00:00"];
        [self addSubview:_intervalLabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_intervalLabel
                                                         attribute:NSLayoutAttributeTop
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_timerLabel
                                                         attribute:NSLayoutAttributeBottom
                                                        multiplier:1.0
                                                          constant:20]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_intervalLabel
                                                         attribute:NSLayoutAttributeCenterX
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterX
                                                        multiplier:1.0
                                                          constant:0]];
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
