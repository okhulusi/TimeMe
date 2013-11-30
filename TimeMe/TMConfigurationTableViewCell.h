//
//  TMConfigurationTableViewCell.h
//  Bzz
//
//  Created by Clark Barry on 11/29/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTableViewCell.h"

@class TMTimerConfiguration;

@interface TMConfigurationTableViewCell : TMTableViewCell
- (void)configureForTimerConfiguration:(TMTimerConfiguration *)configuration;
@end
