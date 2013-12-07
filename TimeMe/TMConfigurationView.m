//
//  TMConfigurationView.m
//  Bzz
//
//  Created by Clark Barry on 11/21/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMConfigurationView.h"
#import "TMTimerConfiguration.h"
#import "TMStyleManager.h"
#import "NSString+TMTimeIntervalString.h"

@interface TMConfigurationView () {
    UILabel *_mainLabel;
    UILabel *_timeLabel;
}

@end

@implementation TMConfigurationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [self setBackgroundColor:styleManager.backgroundColor];
        _mainLabel = [[UILabel alloc] init];
        [_mainLabel setBackgroundColor:styleManager.backgroundColor];
        [_mainLabel setTextColor:styleManager.textColor];
        [_mainLabel setFont:[styleManager.font fontWithSize:20]];
        [_mainLabel setTextAlignment:NSTextAlignmentLeft];
        [self addSubview:_mainLabel];
        
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setBackgroundColor:styleManager.backgroundColor];
        [_timeLabel setTextColor:styleManager.textColor];
        [_timeLabel setFont:[styleManager.font fontWithSize:18]];
        [_timeLabel setTextAlignment:NSTextAlignmentRight];
        [self addSubview:_timeLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_mainLabel setFrame:CGRectMake(10, 0,
                                    CGRectGetWidth(self.frame)/2. - 20, CGRectGetHeight(self.frame))];
    [_timeLabel setFrame:CGRectMake(CGRectGetWidth(self.frame)/2, 0,
                                    CGRectGetWidth(self.frame)/2 - 10, CGRectGetHeight(self.frame))];
    [_mainLabel setCenter:CGPointMake(_mainLabel.center.x, self.center.y)];
    [_timeLabel setCenter:CGPointMake(_timeLabel.center.x, self.center.y)];
    
}

- (void)configureForTimerConfiguration:(TMTimerConfiguration *)timeConfiguration {
    [_mainLabel setText:@"Duration"];
    NSString *intervalString = [NSString stringForTimeInterval:timeConfiguration.selectedTimeInterval style:TMTimeIntervalStringWords];
    [_timeLabel setText:intervalString];
}

@end
