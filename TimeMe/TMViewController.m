//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMViewController.h"

#define TIMER_VIEW_TAG 0
#define INTERVAL_VIEW_TAG 1

@interface TMViewController () {
    TMIntervalTimer *_timer;
}


@end

@implementation TMViewController

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"TimeMe"];
        _timer = [[TMIntervalTimer alloc] init];

    }
    return self;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
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
            titleText = [titleText stringByAppendingString:@":"];
            [cell.textLabel setText:titleText];
            
            NSTimeInterval timeInterval = (indexPath.section == TIMER_VIEW_TAG) ? _timer.timerLength : _timer.intervalLength;
            [cell.detailTextLabel setText:[NSString stringWithFormat:@"%f",timeInterval]];
        } else { //display a pickerview for this one
        
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

#pragma mark - UIPickerView

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     //Handles the Selection
    if (pickerView.tag == TIMER_VIEW_TAG) {
        [_timer setTimerLength:row];
    } else if (pickerView.tag == INTERVAL_VIEW_TAG) {
        [_timer setIntervalLength:row];
    }
}

//Tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger numRows = 60;
    if (component == 0) { //60 is pretty unreasonable for an hour count
        numRows = 24;
    }
    return numRows;
}

//Tells picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//Tell the picker the title for the given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *timeModifier = (component == 0) ? @"h" : (component == 1) ? @"m" : @"s";
    NSString *title = [NSString stringWithFormat:@"%02d%@",row,timeModifier];
    
    if (component != 2) { //if not a second component
//        title = [title stringByAppendingString:@":"];
    }
    return title;
}

//Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int sectionWidth = 60;
    return sectionWidth;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
