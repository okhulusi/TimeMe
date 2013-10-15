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
#import "TMTimerView.h"

#import "TMAlertManager.h"

#import "TMStyleManager.h"

#import "NSString+TMTimeIntervalString.h"

@interface TMViewController () {
    UITableView *_tableView;
    TMTimerView *_timerView;
    
    UIButton *_timerToggleButton;
    BOOL _showingPicker;
    
    NSMutableDictionary *_selectedAlerts;
}

- (void)_toggleButtonPressed;
- (void)_fadeInView:(UIView *)inView outView:(UIView *)outView;
- (NSArray *)_selectedAlerts;
@end

@implementation TMViewController

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"TimeMe"];
        
        _showingPicker = NO;
        
        _selectedAlerts = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)_toggleButtonPressed {
    NSString *buttonTitle = nil;
    UIColor *titleColor = nil;
    UIView *inView = nil;
    UIView *outView = nil;
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    if (!alertManager.generatingAlerts) {
        NSArray *selectedAlerts = [self _selectedAlerts];
        if ([selectedAlerts count]) {
            [alertManager startAlerts:selectedAlerts];
            buttonTitle = @"Stop";
            titleColor = [UIColor redColor];
            inView = _timerView;
            outView = _tableView;
        }
    } else {
        [alertManager stopAlerts];
        buttonTitle = @"Start";
        titleColor = [UIColor greenColor];
        inView = _tableView;
        outView = _timerView;
    }
    if (buttonTitle) {
        [_timerToggleButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    if (titleColor) {
        [_timerToggleButton setTitleColor:titleColor forState:UIControlStateNormal];
    }
    if (inView && outView) {
        [self _fadeInView:inView outView:outView];
    }
}

- (void)_fadeInView:(UIView *)inView outView:(UIView *)outView {
    [self.view addSubview:inView];
    [UIView animateWithDuration:.5
                     animations:^{
                         [inView setAlpha:1];
                         [outView setAlpha:0];
                     } completion:^(BOOL finished) {
                         [outView removeFromSuperview];
                     }];
}

- (NSArray *)_selectedAlerts {
    NSMutableArray *selectedAlerts = [[NSMutableArray alloc] init];
    for (NSNumber *alertInterval in _selectedAlerts) {
        NSNumber *isSelected = [_selectedAlerts objectForKey:alertInterval];
        if ([isSelected boolValue]) {
            [selectedAlerts addObject:alertInterval];
        }
    }
    return selectedAlerts;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    [self.navigationController.navigationBar setBarTintColor:styleManager.navigationBarTintColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : styleManager.navigationBarTitleColor}];
    
    CGFloat buttonHeight = 75;
    CGRect tableFrame = self.view.frame;
    tableFrame.size.height -= buttonHeight;
    
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    [_tableView setBackgroundColor:styleManager.backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    _timerToggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_timerToggleButton.titleLabel setFont:[styleManager.font fontWithSize:25]];
    [_timerToggleButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [_timerToggleButton setTitle:@"Start" forState:UIControlStateNormal];
    [_timerToggleButton setFrame:CGRectMake(0, CGRectGetMaxY(tableFrame),
                                           CGRectGetWidth(self.view.frame), buttonHeight)];
    [_timerToggleButton addTarget:self action:@selector(_toggleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timerToggleButton];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

static CGFloat __headerHeight = 50;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 1 && [[TMAlertManager getInstance].alertIntervals count]) {
        height = __headerHeight;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (section == 1 && [[TMAlertManager getInstance].alertIntervals count]) {
        CGFloat padding = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding, padding,
                                                                   CGRectGetWidth(self.view.frame)-(2*padding), __headerHeight - (2*padding))];
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [label setText:@"Alert me at"];
        [label setBackgroundColor:styleManager.backgroundColor];
        [label setTextColor:styleManager.textColor];
        [label setFont:[styleManager.font fontWithSize:20]];
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              CGRectGetWidth(self.view.frame), __headerHeight)];
        [headerView setBackgroundColor:styleManager.backgroundColor];
        [headerView addSubview:label];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount;
    if (section == 0) {
        rowCount = 1;
        if (_showingPicker) {
            rowCount++;
        }
    } else {
        rowCount = [[TMAlertManager getInstance].alertIntervals count];
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { // should be lightweight
    TMTableViewCell *cell = nil;
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    NSTimeInterval timeInterval = alertManager.timerLength;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //we display info on the timer, not the timer picker itself
            static NSString *kTimerPickerTitleCellID = @"timercelltitlepickerid";
            cell = [tableView dequeueReusableCellWithIdentifier:kTimerPickerTitleCellID];
            if (!cell) {
                cell = [[TMTimeLabelCell alloc] initWithReuseIdentifier:kTimerPickerTitleCellID];
            }
            NSString *titleText = @"Timer Length";
            [cell.textLabel setText:titleText];
        } else { //display a pickerview for this one
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
        NSNumber *alertInterval = [alertManager.alertIntervals objectAtIndex:indexPath.row];
        BOOL isChecked = [[_selectedAlerts objectForKey:alertInterval] boolValue];
        timeInterval = [alertInterval doubleValue];
        [(TMIntervalLabelCell *)cell setChecked:isChecked animated:NO];
    }
    [cell configureForTimeInterval:timeInterval];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        NSIndexPath *pickerPath = [NSIndexPath indexPathForRow:1 inSection:0];
        if (!_showingPicker) { //if we're not showing a picker show one
            _showingPicker = YES;
            [tableView insertRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        } else {
            _showingPicker = NO;
            [_tableView deleteRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationAutomatic];

        }
    } else if (indexPath.section == 1){
        TMAlertManager *alertManager = [TMAlertManager getInstance];
        NSNumber *alertInterval = [alertManager.alertIntervals objectAtIndex:indexPath.row];
        BOOL checked = ![[_selectedAlerts objectForKey:alertInterval] boolValue];
        [_selectedAlerts setObject:[NSNumber numberWithBool:checked] forKey:alertInterval];
        TMIntervalLabelCell *cell = (TMIntervalLabelCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setChecked:checked animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    if (indexPath.section == 0) {
        height = 75;
        if (indexPath.row == 1) { //its a picker row
            height = 160;
        }
    }
    return height;
}

#pragma mark - TMTimePicker

- (NSTimeInterval)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    TMTableViewCell *cell = (TMTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
    [cell configureForTimeInterval:timeInterval];
    
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    [alertManager setTimerLength:timeInterval];
    
    [_selectedAlerts removeAllObjects];
    NSArray *availableAlerts = alertManager.alertIntervals;
    for (NSNumber *alertInterval in availableAlerts) {
        [_selectedAlerts setObject:@YES forKey:alertInterval];
    }
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation: UITableViewRowAnimationAutomatic];            
    
    return timeInterval;
}

@end
