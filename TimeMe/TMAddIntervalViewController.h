//
//  TMAddIntervalViewController.h
//  Bzz
//
//  Created by Clark Barry on 11/13/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMTimePickerCell.h"

@class TMAddIntervalViewController;
@protocol TMAddIntervalDelegate <NSObject>
- (void)addIntervalController:(TMAddIntervalViewController *)addIntervalController didSelectInterval:(NSTimeInterval)timeInterval;
- (void)addIntervalControllerDidCancel:(TMAddIntervalViewController *)addIntervalController ;

@end

@interface TMAddIntervalViewController : UITableViewController<TMTimePickerDelegate>
@property (weak)id<TMAddIntervalDelegate> delegate;

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval;
@end
