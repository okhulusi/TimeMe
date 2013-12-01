//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMViewController.h"
#import "TMTableViewCell.h"
#import "TMTimeLabelCell.h"
#import "TMIntervalLabelCell.h"
#import "TMTimePickerCell.h"
#import "TMAlertManager.h"
#import "TMStyleManager.h"
#import "NSString+TMTimeIntervalString.h"
#import "TMAddIntervalViewController.h"
#import "TMTimerConfiguration.h"
#import "TMConfigurationPickerView.h"


@interface TMViewController () {
    UITableView *_tableView;
}

- (void)_addButtonPressed;
@end

@implementation TMViewController

- (void)setConfiguration:(TMTimerConfiguration *)configuration {
    _configuration = configuration;
    [_tableView reloadData];
}

- (void)_addButtonPressed {
    if (_configuration.selectedTimeInterval) {
        TMAddIntervalViewController *addVC = [[TMAddIntervalViewController alloc] init];
        [addVC configureForTimeInterval:_configuration.selectedTimeInterval];
        addVC.delegate = self;
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addVC];
        UIViewController *parent = self.parentViewController;
        UINavigationController *parentNavigationController = parent.navigationController;
        [parentNavigationController presentViewController:navigationController animated:YES completion:nil];
    }
}

#pragma mark - TMAddInterval

- (void)addIntervalController:(TMAddIntervalViewController *)addIntervalController didSelectInterval:(NSTimeInterval)timeInterval {
    if (timeInterval) {
        NSNumber *interval = @(timeInterval);
        [_configuration.hiddenAlerts addObject:interval];
        if (![_configuration.addedAlerts containsObject:interval] && ![_configuration.displayAlerts containsObject:interval]) {
            [_configuration.addedAlerts addObject:interval];
            if (timeInterval < _configuration.selectedTimeInterval) {
                [_configuration.selectedAlerts addObject:interval];
                [_configuration.displayAlerts addObject:interval];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
                [_configuration.displayAlerts sortUsingDescriptors:@[sortDescriptor]];
            }
        }
    }
    [addIntervalController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addIntervalControllerDidCancel:(TMAddIntervalViewController *)addIntervalController {
    [addIntervalController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [_tableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_tableView setBackgroundColor:styleManager.backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    //fix tableview to bottom on picker, make sure it doens't extent past button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
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
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_tableView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [_tableView reloadData];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

static CGFloat __headerHeight = 60;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 1) {
        height = __headerHeight;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (section == 1) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        UIColor *headerColor = [styleManager.backgroundColor colorWithAlphaComponent:1];
        CGFloat padding = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding + 5, padding,
                                                                   CGRectGetWidth(self.view.frame)-(2*padding), __headerHeight - (2*padding))];

        [label setText:@"Bzz me at:"];
        label.textAlignment = NSTextAlignmentLeft;
        [label setBackgroundColor:styleManager.backgroundColor];
        [label setTextColor:styleManager.textColor];
        [label setFont:[styleManager.font fontWithSize:19]];
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              CGRectGetWidth(self.view.frame), __headerHeight)];
        [headerView setBackgroundColor: headerColor];
        [headerView addSubview:label];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [addButton setTitle:@"+" forState:UIControlStateNormal];
        [addButton.titleLabel setFont:[styleManager.font fontWithSize:30]];
        [addButton setTitleColor:styleManager.textColor forState:UIControlStateNormal];
        [addButton setBackgroundColor:styleManager.backgroundColor];
        [addButton setFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 70, 0, 70, __headerHeight)];
        [addButton addTarget:self action:@selector(_addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:addButton];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount;
    if (section == 0) {
        rowCount = 2;
    } else {
        rowCount = [_configuration.displayAlerts count];
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { // should be lightweight
    TMTableViewCell *cell = nil;
    NSTimeInterval timeInterval = _configuration.selectedTimeInterval;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //we display info on the timer, not the timer picker itself
            static NSString *kTimerPickerTitleCellID = @"timercelltitlepickerid";
            cell = [tableView dequeueReusableCellWithIdentifier:kTimerPickerTitleCellID];
            if (!cell) {
                cell = [[TMTimeLabelCell alloc] initWithReuseIdentifier:kTimerPickerTitleCellID];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            NSString *titleText = @"Duration";
            [cell.textLabel setText:titleText];
        } else {
            static NSString *kPickerViewCellID = @"pickerviewcellid";
            cell = [tableView dequeueReusableCellWithIdentifier:kPickerViewCellID];
            if (!cell) {
                cell = [[TMTimePickerCell alloc] initWithReuseIdentifier:kPickerViewCellID];
                ((TMTimePickerCell *)cell).delegate = self;
            }
        }
    } else {
        static NSString *kAlertIntervalCellID = @"alertintervalcellid";
        cell = [tableView dequeueReusableCellWithIdentifier:kAlertIntervalCellID];
        if (!cell) {
            cell = [[TMIntervalLabelCell alloc] initWithReuseIdentifier:kAlertIntervalCellID];
        }
        NSNumber *alertInterval = [_configuration.displayAlerts objectAtIndex:indexPath.row];
        BOOL isChecked = [_configuration.selectedAlerts containsObject:alertInterval];
        timeInterval = [alertInterval doubleValue];
        [(TMIntervalLabelCell *)cell setChecked:isChecked animated:NO];
    }
    [cell configureForTimeInterval:timeInterval];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1) {
        NSNumber *alertInterval = [_configuration.displayAlerts objectAtIndex:indexPath.row];
        NSMutableSet *selectedAlerts = _configuration.selectedAlerts;
        BOOL isSelected = [selectedAlerts containsObject:alertInterval];
        if (isSelected) {
            [selectedAlerts removeObject:alertInterval];
        } else {
            [selectedAlerts addObject:alertInterval];
        }
        TMIntervalLabelCell *cell = (TMIntervalLabelCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setChecked:!isSelected animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    if (indexPath.section == 0) {
        height = indexPath.row == 1 ? 120 : 75;
    }
    return height;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 1) {
        NSNumber *alertInterval = [_configuration.displayAlerts objectAtIndex:indexPath.row];
        [_configuration.addedAlerts removeObject:alertInterval];
        [_configuration.selectedAlerts removeObject:alertInterval];
        [_configuration.displayAlerts removeObjectAtIndex:indexPath.row];
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];
    }
}


#pragma mark - TMTimePicker

- (NSTimeInterval)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    //configure configuration selector
    
    [_configuration setSelectedTimeInterval:timeInterval];
    
    [_configuration.displayAlerts removeAllObjects];
    NSArray *availableAlerts = [TMAlertManager alertIntervalsForTimerLength:timeInterval];
    [_configuration.displayAlerts addObjectsFromArray:availableAlerts];
    
    for (NSNumber *alertInterval in _configuration.hiddenAlerts) {
        [_configuration.displayAlerts removeObject:alertInterval];
    }
    
    for (NSNumber *alertInterval in _configuration.addedAlerts) {
        if ([alertInterval doubleValue] < timeInterval) {
            if (![_configuration.displayAlerts containsObject:alertInterval]) {
                [_configuration.displayAlerts addObject:alertInterval];
            }
        }
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    [_configuration.displayAlerts sortUsingDescriptors:@[sortDescriptor]];
    
    TMTableViewCell *cell = (TMTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [cell configureForTimeInterval:timeInterval];
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation: UITableViewRowAnimationAutomatic];            
    
    return timeInterval;
}

@end
