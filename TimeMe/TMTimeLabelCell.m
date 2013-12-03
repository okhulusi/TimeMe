//
//  TMTimeLabelTableViewCell.m
//  TimeMe
//
//  Created by Clark Barry on 10/9/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimeLabelCell.h"
#import "TMStyleManager.h"
#import "NSString+TMTimeIntervalString.h"

@implementation TMTimeLabelCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [self setBackgroundColor:styleManager.backgroundColor];
        [self.textLabel setTextColor:styleManager.textColor];
        [self.textLabel setHighlightedTextColor:styleManager.highlightTextColor];
        [self.detailTextLabel setTextColor:styleManager.detailTextColor];
        [self.detailTextLabel setHighlightedTextColor:styleManager.highlightTextColor];
        [self.detailTextLabel setNumberOfLines:0];
    }
    return self;
}

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval {
    NSString *intervalString = [NSString stringForTimeInterval:timeInterval style:TMTimeIntervalStringWords];
    [self.detailTextLabel setText:intervalString];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGPoint cellCenter = self.contentView.center;
    CGPoint labelCenter = self.textLabel.center;
    labelCenter.y = cellCenter.y;
    [self.textLabel setCenter:labelCenter];
    
    labelCenter.x = self.detailTextLabel.center.x;
    [self.detailTextLabel setCenter:labelCenter];
}

@end
