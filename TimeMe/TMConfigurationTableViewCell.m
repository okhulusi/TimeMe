//
//  TMConfigurationTableViewCell.m
//  Bzz
//
//  Created by Clark Barry on 11/29/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMConfigurationTableViewCell.h"
#import "TMTimerConfiguration.h"
#import "NSString+TMTimeIntervalString.h"
#import "TMStyleManager.h"
@implementation TMConfigurationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [self.detailTextLabel setTextColor:styleManager.textColor];
        [self.detailTextLabel setHighlightedTextColor:styleManager.highlightTextColor];
    }
    return self;
}

- (void)configureForTimerConfiguration:(TMTimerConfiguration *)configuration {
    NSString *title = [NSString stringForTimeInterval:configuration.selectedTimeInterval style:TMTimeIntervalStringWords];
    [self.textLabel setText:title];
    
    NSString *detail = [NSString stringWithFormat:@"Bzz %ld time",(unsigned long)[configuration.selectedAlerts count]];
    if ([configuration.selectedAlerts count] != 1) {
        detail = [detail stringByAppendingString:@"s"];
    }
    [self.detailTextLabel setText:detail];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    UIColor *backgroundColor = highlighted ? styleManager.highlightBackgroundColor : styleManager.backgroundColor;
    [self.contentView setBackgroundColor:backgroundColor];
    [self setBackgroundColor:backgroundColor];
}
@end
