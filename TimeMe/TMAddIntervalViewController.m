//
//  TMAddIntervalViewController.m
//  Bzz
//
//  Created by Clark Barry on 11/13/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMAddIntervalViewController.h"
#import "TMStyleManager.h"

@interface TMAddIntervalViewController ()

@end

@implementation TMAddIntervalViewController

- (void)loadView {
    [super loadView];
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    [self.tableView setBackgroundColor:styleManager.backgroundColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

@end
