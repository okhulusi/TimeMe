//
//  TMTableViewCell.h
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMTableViewCell : UITableViewCell
- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
- (void)configureForTimeInterval:(NSTimeInterval)timeInterval;
@end
