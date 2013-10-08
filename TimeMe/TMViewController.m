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
        self.tableView.scrollEnabled = NO;  //Locks tableView
        
        _timer = [[TMIntervalTimer alloc] init];
        [_timer setDelegate:self];
    }
    return self;
}

<<<<<<< HEAD
- (void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    CGFloat width = self.view.frame.size.width;
 // CGFloat height = self.view.frame.size.height;
    
    //Second/Minute/Hour Labels (initalized to hidden)
    _secLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 + 85.0f, 140.0f, 200.0f, 30.0f)];
    [_secLabel setHidden:YES];
    [self.view addSubview:_secLabel];
    _minLabel= [[UILabel alloc] initWithFrame:CGRectMake(width/2, 140.0f, 200.0f, 30.0f)];
    [_minLabel setHidden:YES];
    [self.view addSubview:_minLabel];
    _hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 85.0f, 140.0f, 200.0f, 30.0f)];
    [_hourLabel setHidden:YES];
    [self.view addSubview:_hourLabel];
    
    //Total Time Label
    _totalTimePickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 85.0f, 140.0f, 200.0f, 30.0f)];
    _totalTimePickerLabel.font = [UIFont fontWithName:@"Courier" size:16.0f];
    [_totalTimePickerLabel setText:@"Total Time Length"];
    
    [self.view addSubview:_totalTimePickerLabel];
=======
- (NSString *)_stringForCountdownTime:(NSTimeInterval)countdownTime {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:countdownTime sinceDate:startDate];
>>>>>>> 3c48e9e6522dc7d7a97e405f98d5cbb586d0d4f8
    
    unsigned int conversionFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
<<<<<<< HEAD
    //Interval Time Label
    _pickerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 85.0f,290.0f, 200.0f, 30.0f)];
     _pickerViewLabel.font = [UIFont fontWithName:@"Courier" size:12.0f];
    [_pickerViewLabel setText:@"Enter a Vibrate Interval"];
    [self.view addSubview:_pickerViewLabel];
    
    //Interval Time Picker
    _intervalPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(width/2 - 100.0f, 250.0f, 200.0f, 30.0f)];
    _intervalPickerView.delegate = self;
    _intervalPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:_intervalPickerView];
    _intervalPickerView.tag = 2;
    
    //Start Button
    _timerToggleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_timerToggleButton addTarget:self action:@selector(timerToggleButtonPressed) forControlEvents:UIControlEventTouchDown];
    [_timerToggleButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    _timerToggleButton.frame = CGRectMake(width/2 - 100.0f, 400.0f, 200.0f, 30.0f);
    [self.view addSubview:_timerToggleButton];
=======
    NSDateComponents *components = [calender components:conversionFlags fromDate:startDate toDate:endDate options:0];
    NSString *intervalString = [NSString stringWithFormat:@"%02d:%02d:%02d",[components hour],[components minute],[components second]];
    return intervalString;
>>>>>>> 3c48e9e6522dc7d7a97e405f98d5cbb586d0d4f8
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
    } else { // get rid of this
        static NSString *kTimerToggleCellID = @"timertogglecellid";
        cell = [tableView dequeueReusableCellWithIdentifier:kTimerToggleCellID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:kTimerToggleCellID];
        }
        [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
        cell.textLabel.textColor = [UIColor greenColor];
        cell.contentView.backgroundColor = [UIColor colorWithRed:0.5f green:0.0f blue:0.5f alpha:0.15f];
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
            cell.textLabel.textColor = [UIColor redColor];
            [cell.textLabel setText:@"Stop Timer"];
        } else {
            [_timer stopTimer];
            cell.textLabel.textColor = [UIColor greenColor];
            [cell.textLabel setText:@"Start Timer"];
        }
    } else {
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

<<<<<<< HEAD
- (void) timerToggleButtonPressed
{
    if(!_timer.running){
        [_totalTimePickerLabel setHidden:YES];
        [_totalTimePickerView setHidden:YES];
        [_pickerViewLabel setHidden:YES];
        [_intervalPickerView setHidden:YES];
        
        [_timerToggleButton setTitle:@"Pause" forState:UIControlStateNormal];
        [_secLabel setText:[NSString stringWithFormat:@"%f", _timer.timerLength/60]];
        [_secLabel setHidden:NO];
        [_minLabel setText:[NSString stringWithFormat:@"%f", (_timer.timerLength - _timer.timerLength/60)/60]];
        [_minLabel setHidden:NO];
        [_hourLabel setText:[NSString stringWithFormat:@"%f", _timer.timerLength - (_timer.timerLength - _timer.timerLength/60)/60]];
        [_hourLabel setHidden:NO];
        
        [_timer startTimer];
    } else{
        
    }
    
=======
- (void)intervalTimerDidFinishTimer:(TMIntervalTimer *)intervalTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        UITableViewCell *toggleCell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
        toggleCell.textLabel.textColor = [UIColor greenColor];
        [toggleCell.textLabel setText:@"Start Timer"];
    });
>>>>>>> 3c48e9e6522dc7d7a97e405f98d5cbb586d0d4f8
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
