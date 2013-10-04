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
}
- (NSString *)_stringForCountdownTime:(NSTimeInterval)countdownTime;
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

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = 1;
    if ((section == TIMER_VIEW_TAG && _showingPicker[TIMER_VIEW_TAG]) || (section == INTERVAL_VIEW_TAG && _showingPicker[INTERVAL_VIEW_TAG])) {
        rowCount++;
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    if (indexPath.section != 2) { //we're a picker section
        if (indexPath.row == 0) { //we display info on the timer, not the timer picker itself
            static NSString *kTimerPickerTitleCellID = @"timercelltitlepickerid";
            cell = [tableView dequeueReusableCellWithIdentifier:kTimerPickerTitleCellID];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:kTimerPickerTitleCellID];
            }
            NSString *titleText = (indexPath.section == TIMER_VIEW_TAG) ? @"Timer Length" : @"Timer Interval";
            [cell.textLabel setText:titleText];
            
            NSTimeInterval timeInterval = (indexPath.section == TIMER_VIEW_TAG) ? _timer.timerLength : _timer.intervalLength;
            NSString *intervalString = [self _stringForCountdownTime:timeInterval];
            [cell.detailTextLabel setText:intervalString];
        } else { //display a pickerview for this one
            static NSString *kPickerViewCellID = @"pickerviewcellid";
            cell = [tableView dequeueReusableCellWithIdentifier:kPickerViewCellID];
            if (!cell) {
                cell = [[TMTimePickerCell alloc] initWithReuseIdentifier:kPickerViewCellID];
            }
            cell.tag = indexPath.section;
        }
    } else {
        static NSString *kTimerToggleCellID = @"timertogglecellid";
        cell = [tableView dequeueReusableCellWithIdentifier:kTimerToggleCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:kTimerToggleCellID];
        }
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        [cell.textLabel setText:@"Start Timer"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) { //if its the select button
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if (!_timer.running) {
            [_timer startTimer];
            [cell.textLabel setText:@"Stop Timer"];
        } else {
            [_timer stopTimer];
            [cell.textLabel setText:@"Start Timer"];
        }
    } else {
        if (indexPath.row == 0) {
            NSIndexPath *pickerPath = [NSIndexPath indexPathForRow:1 inSection:indexPath.section];
            if (!_showingPicker[indexPath.section]) { //if we're not showing a picker show one
                _showingPicker[indexPath.section] = YES;
                [tableView insertRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            } else {
                _showingPicker[indexPath.section] = NO;
                [tableView deleteRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            }
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
        [toggleCell.textLabel setText:@"Start Timer"];
    });
}

#pragma mark - TMTimePicker

- (void)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    if (timePickerCell.tag == INTERVAL_VIEW_TAG) {
        [_timer setIntervalLength:timeInterval];
    } else if (timePickerCell.tag == TIMER_VIEW_TAG) {
        [_timer setTimerLength:timeInterval];
    }
}

@end
