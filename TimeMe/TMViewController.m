//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMViewController.h"

#import "TMTimeLabelTableViewCell.h"
#import "TMTimePickerCell.h"

#import "TMStyleManager.h"

#define TIMER_VIEW_TAG 0
#define INTERVAL_VIEW_TAG 1

@interface TMViewController () {
    TMIntervalTimer *_timer;
    
    UIButton *_timerToggleButton;
    
    BOOL _showingPicker[2];
}

@property UITableView *tableView;

- (NSString *)_stringForCountdownTime:(NSTimeInterval)countdownTime;
- (void)_toggleButtonPressed;
@end

@implementation TMViewController

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"TimeMe"];
        
        _timer = [[TMIntervalTimer alloc] init];
        [_timer setDelegate:self];
    }
    return self;
}
- (NSString *)_stringForCountdownTime:(NSTimeInterval)countdownTime {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:countdownTime sinceDate:startDate];

    
    unsigned int conversionFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;

    NSDateComponents *components = [calender components:conversionFlags fromDate:startDate toDate:endDate options:0];
    NSString *intervalString = [NSString stringWithFormat:@"%02d:%02d:%02d",[components hour],[components minute],[components second]];
    return intervalString;
}

- (void)_toggleButtonPressed {
    NSString *buttonTitle = nil;
    UIColor *titleColor = nil;
    if (!_timer.running) {
        [_timer startTimer];
        buttonTitle = @"Stop";
        titleColor = [UIColor redColor];
    } else {
        [_timer stopTimer];
        buttonTitle = @"Start";
        titleColor = [UIColor greenColor];
    }
    [_timerToggleButton setTitle:buttonTitle forState:UIControlStateNormal];
    [_timerToggleButton setTitleColor:titleColor forState:UIControlStateNormal];
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
    [_tableView setScrollEnabled:NO];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 1;
    if ((section == TIMER_VIEW_TAG && _showingPicker[TIMER_VIEW_TAG]) || (section == INTERVAL_VIEW_TAG && _showingPicker[INTERVAL_VIEW_TAG])) {
        rowCount++;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { // should be lightweight
    UITableViewCell *cell = nil;
    NSTimeInterval timeInterval = (indexPath.section == TIMER_VIEW_TAG) ? _timer.timerLength : _timer.intervalLength;
    if (indexPath.row == 0) { //we display info on the timer, not the timer picker itself
        static NSString *kTimerPickerTitleCellID = @"timercelltitlepickerid";
        cell = [tableView dequeueReusableCellWithIdentifier:kTimerPickerTitleCellID];
        if (!cell) {
            cell = [[TMTimeLabelTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                                   reuseIdentifier:kTimerPickerTitleCellID];
        }
        NSString *titleText = (indexPath.section == TIMER_VIEW_TAG) ? @"Timer Length" : @"Timer Interval";
        [cell.textLabel setText:titleText];
        
        NSString *intervalString = [self _stringForCountdownTime:timeInterval];
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        NSIndexPath *pickerPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
        if (!_showingPicker[indexPath.section]) { //if we're not showing a picker show one
            _showingPicker[indexPath.section] = YES;
            [tableView insertRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationTop];
            NSIndexPath *removePath = nil;
            if (indexPath.section == TIMER_VIEW_TAG && _showingPicker[INTERVAL_VIEW_TAG]) {
                _showingPicker[INTERVAL_VIEW_TAG] = NO;
                removePath = [NSIndexPath indexPathForRow:1 inSection:INTERVAL_VIEW_TAG];
            } else if (indexPath.section == INTERVAL_VIEW_TAG && _showingPicker[TIMER_VIEW_TAG]) {
                _showingPicker[TIMER_VIEW_TAG] = NO;
                removePath = [NSIndexPath indexPathForRow:1 inSection:TIMER_VIEW_TAG];
            }
            if (removePath) {
                [tableView deleteRowsAtIndexPaths:@[removePath] withRowAnimation:UITableViewRowAnimationTop];
            }
        } else {
            _showingPicker[indexPath.section] = NO;
            [tableView deleteRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 75;
    if (indexPath.row == 1) { //its a picker row
        height = 180;
    }
    return height;
}

#pragma mark - TMIntervalTimer

- (void)intervalTimerDidFinishInterval:(TMIntervalTimer *)intervalTimer {

}

- (void)intervalTimerDidFinishTimer:(TMIntervalTimer *)intervalTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        [_timerToggleButton setTitle:@"Start" forState:UIControlStateNormal];
        [_timerToggleButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    });
}

#pragma mark - TMTimePicker

- (void)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:timePickerCell.tag]];
    NSString *intervalString = [self _stringForCountdownTime:timeInterval];
    [cell.detailTextLabel setText:intervalString];
    
    if (timePickerCell.tag == INTERVAL_VIEW_TAG) {
        [_timer setIntervalLength:timeInterval];
    } else if (timePickerCell.tag == TIMER_VIEW_TAG) {
        [_timer setTimerLength:timeInterval];
    }
}

@end
