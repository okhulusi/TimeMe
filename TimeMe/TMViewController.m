//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMViewController.h"

#import "TMTimeLabelCell.h"
#import "TMTimePickerCell.h"
#import "TMTimerView.h"

#import "TMAlertManager.h"

#import "TMStyleManager.h"

#import "NSString+TMTimeIntervalString.h"

#define TIMER_VIEW_TAG 0

@interface TMViewController () {
    TMIntervalTimer *_timer;
    
    UITableView *_tableView;
    TMTimerView *_timerView;
    
    UIButton *_timerToggleButton;
    BOOL _showingPicker;
}

- (void)_toggleButtonPressed;
- (void)_fadeInView:(UIView *)inView outView:(UIView *)outView;
@end

@implementation TMViewController

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"TimeMe"];
        
        _showingPicker = NO;
        _timer = [[TMIntervalTimer alloc] init];
        [_timer setDelegate:self];
    }
    return self;
}

- (void)_toggleButtonPressed {
    NSString *buttonTitle = nil;
    UIColor *titleColor = nil;
    UIView *inView = nil;
    UIView *outView = nil;
    if (!_timer.running) {
        if (_timer.timerLength) {
            [_timer startTimer];
            buttonTitle = @"Stop";
            titleColor = [UIColor redColor];
            inView = _timerView;
            outView = _tableView;
            
            [_timerView beginUpdating];
        }
    } else {
        [_timer stopTimer];
        buttonTitle = @"Start";
        titleColor = [UIColor greenColor];
        inView = _tableView;
        outView = _timerView;
        
        [_timerView endUpdating];
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
    
    _timerView = [[TMTimerView alloc] initWithFrame:tableFrame intervalTimer:_timer];
    
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount;
    if (section == TIMER_VIEW_TAG) {
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
    UITableViewCell *cell = nil;
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    if (indexPath.section == 0) {
        NSTimeInterval timeInterval = alertManager.timerLength;
        if (indexPath.row == 0) { //we display info on the timer, not the timer picker itself
            static NSString *kTimerPickerTitleCellID = @"timercelltitlepickerid";
            cell = [tableView dequeueReusableCellWithIdentifier:kTimerPickerTitleCellID];
            if (!cell) {
                cell = [[TMTimeLabelCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                       reuseIdentifier:kTimerPickerTitleCellID];
            }
            NSString *titleText = @"Timer Length";
            [cell.textLabel setText:titleText];
            
            NSString *intervalString = [NSString stringForTimeInterval:timeInterval];
            [cell.detailTextLabel setText:intervalString];
        } else { //display a pickerview for this one
            static NSString *kPickerViewCellID = @"pickerviewcellid";
            cell = [tableView dequeueReusableCellWithIdentifier:kPickerViewCellID];
            if (!cell) {
                cell = [[TMTimePickerCell alloc] initWithReuseIdentifier:kPickerViewCellID];
                ((TMTimePickerCell *)cell).delegate = self;
                [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            }
            [((TMTimePickerCell *)cell) configureForTimeInterval:timeInterval];
            cell.tag = indexPath.section;
        }
    } else {
        static NSString *kAlertIntervalCellID = @"alertintervalcellid";
        cell = [tableView dequeueReusableCellWithIdentifier:kAlertIntervalCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kAlertIntervalCellID];
        }
        NSNumber *alertInterval = [alertManager.alertIntervals objectAtIndex:indexPath.row];
        NSString *intervalString = [NSString stringForTimeInterval:[alertInterval doubleValue]];
        [cell.textLabel setText:intervalString];
    }
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
    } else {
        //select this one for alerts
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 75;
    if (indexPath.row == 1) { //its a picker row
        height = 160;
    }
    return height;
}

#pragma mark - TMIntervalTimer

- (void)intervalTimerDidFinishInterval:(TMIntervalTimer *)intervalTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    });
}

- (void)intervalTimerDidFinishTimer:(TMIntervalTimer *)intervalTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timerView endUpdating];
        [_timerToggleButton setTitle:@"Start" forState:UIControlStateNormal];
        [_timerToggleButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self _fadeInView:_tableView outView:_timerView];
    });
}

#pragma mark - TMTimePicker

- (NSTimeInterval)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:timePickerCell.tag]];
    NSString *intervalString = [NSString stringForTimeInterval:timeInterval];
    [cell.detailTextLabel setText:intervalString];
    
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    [alertManager setTimerLength:timeInterval];
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation: UITableViewRowAnimationAutomatic];            
    
    return timeInterval;
}

@end
