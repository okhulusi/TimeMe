//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMViewController.h"
#import "TMTimePickerCell.h"

#define TIMER_VIEW_TAG 0
#define INTERVAL_VIEW_TAG 1

@interface TMViewController () {
    TMIntervalTimer *_timer;
    BOOL _showingPicker[2];
    
    UIButton *toggleTimerButton;
}
- (NSString *)_stringForCountdownTime:(NSTimeInterval)countdownTime;
@end

@implementation TMViewController

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"TimeMe"];
        self.tableView.scrollEnabled = NO;  //Locks tableView in place
        
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

- (void) loadView {
    [super loadView];
    
    toggleTimerButton = [[UIButton alloc] init];
    toggleTimerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;
    toggleTimerButton.frame = CGRectMake(screenWidth/2, screenHeight/2 + 100.0f, 100.0f, 150.0f);
    [toggleTimerButton addTarget:self action:@selector(toggleTimerButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    toggleTimerButton.titleLabel.textColor = [UIColor greenColor];
    [toggleTimerButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    toggleTimerButton.backgroundColor = [UIColor colorWithRed:0.5f green:0.0f blue:0.5f alpha:0.15f];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { // should be lightweight
    UITableViewCell *cell = nil;
    if (indexPath.section != 2) { //we're a picker section
        NSTimeInterval timeInterval = (indexPath.section == TIMER_VIEW_TAG) ? _timer.timerLength : _timer.intervalLength;
        if (indexPath.row == 0) { //we display info on the timer, not the timer picker itself
            static NSString *kTimerPickerTitleCellID = @"timercelltitlepickerid";
            cell = [tableView dequeueReusableCellWithIdentifier:kTimerPickerTitleCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:kTimerPickerTitleCellID];
            }
            NSString *titleText = (indexPath.section == TIMER_VIEW_TAG) ? @"Timer Length" : @"Timer Interval";
            [cell.textLabel setText:titleText];
            
            NSString *intervalString = [self _stringForCountdownTime:timeInterval];
            [cell.detailTextLabel setText:intervalString];
            cell.contentView.backgroundColor = [UIColor colorWithRed:0.5f green:0.0f blue:0.5f alpha:0.15f];
            cell.textLabel.textColor = [UIColor purpleColor];
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
    }
    return cell;
}

- (void)toggleTimerButtonPressed {
    if (!_timer.running) {
        [_timer startTimer];
        toggleTimerButton.titleLabel.textColor = [UIColor redColor];
        [toggleTimerButton setTitle:@"Stop Timer" forState:UIControlStateNormal];
    } else {
        [_timer stopTimer];
        toggleTimerButton.titleLabel.textColor = [UIColor greenColor];
        [toggleTimerButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    }
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
    CGFloat height = 44;
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
        UITableViewCell *toggleCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        toggleCell.textLabel.textColor = [UIColor greenColor];
        [toggleCell.textLabel setText:@"Start Timer"];
    });
}

#pragma mark - TMTimePicker

- (void)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:timePickerCell.tag]];
    NSString *intervalString = [self _stringForCountdownTime:timeInterval];
    [cell.detailTextLabel setText:intervalString];
    cell.tintColor = [UIColor purpleColor];
    
    if (timePickerCell.tag == INTERVAL_VIEW_TAG) {
        [_timer setIntervalLength:timeInterval];
    } else if (timePickerCell.tag == TIMER_VIEW_TAG) {
        [_timer setTimerLength:timeInterval];
    }
}

@end
