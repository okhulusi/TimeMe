//
//  ViewController.h
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMTimePickerCell.h"
#import "TMAddIntervalViewController.h"

@class TMTimerConfiguration;

@interface TMViewController : UIViewController<UITableViewDelegate,UITableViewDataSource, TMTimePickerDelegate, TMAddIntervalDelegate>

- (id)initWithConfiguration:(TMTimerConfiguration *)configuration;

@end
