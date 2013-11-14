//
//  TMAddIntervalViewController.m
//  Bzz
//
//  Created by Clark Barry on 11/13/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMAddIntervalViewController.h"
#import "TMStyleManager.h"

#import "TMTimePickerCell.h"

@interface TMAddIntervalViewController () {
    NSTimeInterval _maxTimeInterval;
    NSTimeInterval _selectedTimeInterval;
}
- (void)_cancelButtonPressed;
- (void)_doneButtonPressed;
@end

@implementation TMAddIntervalViewController

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval {
    _maxTimeInterval = timeInterval;
    [self.tableView reloadData];
}

#pragma mark - Internal

- (void)_cancelButtonPressed {
    if ([self.delegate respondsToSelector:@selector(addIntervalControllerDidCancel:)]) {
        [self.delegate addIntervalControllerDidCancel:self];
    }
}

- (void)_doneButtonPressed {
    if ([self.delegate respondsToSelector:@selector(addIntervalController:didSelectInterval:)]) {
        [self.delegate addIntervalController:self didSelectInterval:_selectedTimeInterval];
    }
}

#pragma mark - TMTimePickerDelegate 

- (NSTimeInterval)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    _selectedTimeInterval = timeInterval;
    return _selectedTimeInterval;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *kTimePickerCellID = @"addintervaltimepickercellid";
    TMTimePickerCell *cell = [tableView dequeueReusableCellWithIdentifier:kTimePickerCellID];
    if (!cell) {
        cell = [[TMTimePickerCell alloc] initWithReuseIdentifier:kTimePickerCellID];
        cell.delegate = self;
    }
    [cell configureForTimeInterval:_selectedTimeInterval];
    return cell;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    [self.tableView setBackgroundColor:styleManager.backgroundColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancelButtonPressed)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_doneButtonPressed)];
    [self.navigationItem setRightBarButtonItem:doneButton];
}

@end
