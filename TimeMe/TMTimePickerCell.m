//
//  TMTimePickerCell.m
//  TimeMe
//
//  Created by Clark Barry on 10/4/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimePickerCell.h"
#import "TMStyleManager.h"

@interface TMTimePickerCell ()
- (NSTimeInterval)_timeInterval;
@end


@implementation TMTimePickerCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        TMStyleManager *styleManger = [TMStyleManager getInstance];
        [self setBackgroundColor:styleManger.backgroundColor];
        _pickerView = [[UIPickerView alloc] initWithFrame:self.contentView.frame];
        [_pickerView setBackgroundColor:styleManger.backgroundColor];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [self.contentView addSubview:_pickerView];
    }
    return self;
}

- (NSTimeInterval)_timeInterval {
    NSTimeInterval timeInterval = 0;
    for (int i = 0; i < _pickerView.numberOfComponents; i++) {
        NSInteger selectedRow = [_pickerView selectedRowInComponent:i];
        NSTimeInterval timeIntervalForComponent = pow(60,_pickerView.numberOfComponents - i - 1) * selectedRow;
        timeInterval += timeIntervalForComponent;
    }
    return timeInterval;
}

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:startDate];
    
    unsigned int conversionFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [calender components:conversionFlags fromDate:startDate toDate:endDate options:0];
    
    [_pickerView selectRow:[components hour] inComponent:0 animated:NO];
    [_pickerView selectRow:[components minute] inComponent:1 animated:NO];
    [_pickerView selectRow:[components second] inComponent:2 animated:NO];
}

#pragma mark - UIPickerView

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *rowLabel = (UILabel *)view;
    if (!rowLabel) {
        rowLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,[pickerView rowSizeForComponent:component]}];
        [rowLabel setTextAlignment:NSTextAlignmentCenter];
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [rowLabel setTextColor:styleManager.textColor];
        [rowLabel setFont:styleManager.font];
    }
    NSString *title = (component != 0) ? [NSString stringWithFormat:@"%02ld",(long)row] : [NSString stringWithFormat:@"%ld",(long)row];
    
    if (component != 2) { //if not a second component
        title = [title stringByAppendingString:@":"];
    }
    [rowLabel setText:title];
    return rowLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([self.delegate respondsToSelector:@selector(timePickerCell:didSetTimeInterval:)]) {
        NSTimeInterval timeInterval = [self _timeInterval];
        [self.delegate timePickerCell:self didSetTimeInterval:timeInterval];
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
    NSString *title = (component != 0) ? [NSString stringWithFormat:@"%02ld",(long)row] : [NSString stringWithFormat:@"%ld",(long)row];
    
    if (component != 2) { //if not a second component
        title = [title stringByAppendingString:@":"];
    }
    return title;
}

//Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int sectionWidth = 60;
    return sectionWidth;
}

@end
