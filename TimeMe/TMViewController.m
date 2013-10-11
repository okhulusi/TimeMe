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

#import "TMTimerView.h"

#import "TMStyleManager.h"

#define TIMER_VIEW_TAG 0
#define INTERVAL_VIEW_TAG 1

@interface TMViewController () {
    TMIntervalTimer *_timer;
    UITableView *_tableView;
    TMTimerView *_timerView;
    
    UIButton *_timerToggleButton;

    BOOL _showingPicker[2];
}

- (NSString *)_stringForCountdownTime:(NSTimeInterval)countdownTime;
- (void)_toggleButtonPressed;
- (void)_fadeInView:(UIView *)inView outView:(UIView *)outView;
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
    NSMutableString *intervalString = nil;
    if([components hour] != 0){
            intervalString = [NSMutableString stringWithFormat:@"%02d hr", [components hour]];
    }
    if([components minute] != 0){
        if(intervalString == nil){
            intervalString = [NSMutableString stringWithFormat:@"%02d min", [components minute]];
        } else{
            [intervalString appendFormat:@", %02d min", [components minute]];
        }
    }
    if([components second] != 0){
        if(intervalString == nil){
            intervalString = [NSMutableString stringWithFormat:@"%02d sec", [components second]];
        } else{
            [intervalString appendFormat:@", %02d sec", [components second]];
        }
    }
         
    if([components hour] == 0 && [components minute] == 0 && [components second] == 0){
        intervalString = [NSMutableString stringWithFormat:@"%02d sec", [components second]];
    }
    return intervalString;
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
    [_tableView setScrollEnabled:NO];
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
            [tableView insertRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            NSIndexPath *removePath = nil;
            if (indexPath.section == TIMER_VIEW_TAG && _showingPicker[INTERVAL_VIEW_TAG]) {
                _showingPicker[INTERVAL_VIEW_TAG] = NO;
                removePath = [NSIndexPath indexPathForRow:1 inSection:INTERVAL_VIEW_TAG];
            } else if (indexPath.section == INTERVAL_VIEW_TAG && _showingPicker[TIMER_VIEW_TAG]) {
                _showingPicker[TIMER_VIEW_TAG] = NO;
                removePath = [NSIndexPath indexPathForRow:1 inSection:TIMER_VIEW_TAG];
            }
            if (removePath) {
                [tableView deleteRowsAtIndexPaths:@[removePath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
        } else {
            _showingPicker[indexPath.section] = NO;
            [tableView deleteRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationAutomatic];
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
        [_timerView endUpdating];
        [_timerToggleButton setTitle:@"Start" forState:UIControlStateNormal];
        [_timerToggleButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self _fadeInView:_tableView outView:_timerView];
    });
}

#pragma mark - TMTimePicker

- (NSTimeInterval)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    NSTimeInterval validTimeInterval = timeInterval;

    if (timePickerCell.tag == INTERVAL_VIEW_TAG) {
        if (timeInterval > _timer.timerLength) {
            validTimeInterval = _timer.timerLength;
        }
        [_timer setIntervalLength:validTimeInterval];
    } else if (timePickerCell.tag == TIMER_VIEW_TAG) {
        [_timer setTimerLength:validTimeInterval];
    }
    
    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:timePickerCell.tag]];
    NSString *intervalString = [self _stringForCountdownTime:validTimeInterval];
    [cell.detailTextLabel setText:intervalString];
    return validTimeInterval;
}

@end
