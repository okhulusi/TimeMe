//
//  TMTimeLabelTableViewCell.m
//  TimeMe
//
//  Created by Clark Barry on 10/9/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimeLabelTableViewCell.h"
#import "TMStyleManager.h"

@implementation TMTimeLabelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

@end
