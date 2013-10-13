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
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    UIColor *backgroundColor = highlighted ? styleManager.highlightBackgroundColor : styleManager.backgroundColor;
    [self.contentView setBackgroundColor:backgroundColor];
    [self setBackgroundColor:backgroundColor];
}

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval {
    NSString *intervalString = [NSString stringForTimeInterval:timeInterval style:TMTimeIntervalStringWords];
    [self.detailTextLabel setText:intervalString];
}

@end
