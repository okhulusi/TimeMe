//
//  TMTableViewCell.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTableViewCell.h"
#import "TMStyleManager.h"


@implementation TMTableViewCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [self initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [self.textLabel setFont:[styleManager.font fontWithSize:20]];
        [self.detailTextLabel setFont:[styleManager.font fontWithSize:18]];
    }
    return self;
}

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval {
    //no op
}

@end
