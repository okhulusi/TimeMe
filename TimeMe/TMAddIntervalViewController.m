//
//  TMAddIntervalViewController.m
//  Bzz
//
//  Created by Clark Barry on 11/13/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMAddIntervalViewController.h"
#import "TMStyleManager.h"

#import "TMTimeLabelCell.h"
#import "TMTimePickerCell.h"

@interface TMAddIntervalViewController () {
    NSTimeInterval _maxTimeInterval;
    NSTimeInterval _selectedTimeInterval;
    UITableView *_tableView;
}
- (void)_cancelButtonPressed;
- (void)_doneButtonPressed;
@end

@implementation TMAddIntervalViewController

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval {
    _maxTimeInterval = timeInterval;
    [_tableView reloadData];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TMTableViewCell *cell = nil;
    if (indexPath.section == 0) {
        static NSString *kTimerPickerTitleCellID = @"timercelltitlepickerid";
        cell = [tableView dequeueReusableCellWithIdentifier:kTimerPickerTitleCellID];
        if (!cell) {
            cell = [[TMTimeLabelCell alloc] initWithReuseIdentifier:kTimerPickerTitleCellID];
        }
        NSString *titleText = @"Bzz time";
        [cell.textLabel setText:titleText];
    } else if (indexPath.section == 1) {
        static NSString *kTimePickerCellID = @"addintervaltimepickercellid";
        cell = [tableView dequeueReusableCellWithIdentifier:kTimePickerCellID];
        if (!cell) {
            cell = [[TMTimePickerCell alloc] initWithReuseIdentifier:kTimePickerCellID];
            ((TMTimePickerCell *)cell).delegate = self;
        }
    }
    [cell configureForTimeInterval:_selectedTimeInterval];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? 60 : 120;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];
    
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64,
                                                                CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))
                                              style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [_tableView setBackgroundColor:styleManager.backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setScrollEnabled:NO];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_tableView];
    
    UIImage *image = [UIImage imageNamed:@"NoColor"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:imageView];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:imageView
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1
                                                           constant:0]];
    
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.
                                                           constant:0]];
    
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(_cancelButtonPressed)];
    [self.navigationItem setLeftBarButtonItem:cancelButton];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_doneButtonPressed)];
    [self.navigationItem setRightBarButtonItem:doneButton];
}

@end
