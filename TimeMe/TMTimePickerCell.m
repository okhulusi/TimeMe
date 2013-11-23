//
//  TMTimePickerCell.m
//  TimeMe
//
//  Created by Clark Barry on 10/4/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimePickerCell.h"
#import "TMTimePickerCell_Private.h"
#import "TMStyleManager.h"

#define NUM_ROWS 12000

@interface TMTimePickerCell () {
    BOOL _labelPosistionedForComponent[2];
    CGFloat _componentWidth;
}
- (NSTimeInterval)_timeInterval;
- (void)_configureForTimeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;
- (void)_addLabelForComponent:(NSInteger)compontent;
@end


@implementation TMTimePickerCell

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    if (self) {
        _componentWidth = 80;
        
        TMStyleManager *styleManger = [TMStyleManager getInstance];
        [self setBackgroundColor:styleManger.backgroundColor];
        CGRect pickerRect = {0, -CGRectGetHeight(self.contentView.frame)/2., self.contentView.frame.size};
        _pickerView = [[UIPickerView alloc] initWithFrame:pickerRect];
        [_pickerView setBackgroundColor:styleManger.backgroundColor];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [self.contentView addSubview:_pickerView];
        
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        _maxHours = 6;
        _maxMinutes = 60;
        _rowCenter = NUM_ROWS/2;
        _secondResolution = 15;
    }
    return self;
}

- (NSTimeInterval)_timeInterval {
    NSTimeInterval timeInterval = 0;
    for (int i = 0; i < _pickerView.numberOfComponents; i++) {
        NSInteger rowValue = [_pickerView selectedRowInComponent:i];
        if (i == 0) {
            rowValue = _maxHours ? rowValue % _maxHours : 0;
        } else if (i == 2) {
            NSInteger modValue = 60/_secondResolution;
            rowValue = (rowValue % modValue) * _secondResolution;
        } else {
            rowValue = _maxMinutes ? rowValue % _maxMinutes : 0;
        }
        NSTimeInterval timeIntervalForComponent = pow(60,(_pickerView.numberOfComponents - i - 1)) * rowValue;
        timeInterval += timeIntervalForComponent;
    }
    return timeInterval;
}

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated {
    [self _configureForTimeInterval:timeInterval animated:animated];
}

- (void)_configureForTimeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:startDate];
    
    unsigned int conversionFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [calender components:conversionFlags fromDate:startDate toDate:endDate options:0];
    
    NSInteger hourRow = [components hour] + _rowCenter;
    NSInteger minuteRow = [components minute] + _rowCenter;
    NSInteger secondRow = [components second]/_secondResolution + _rowCenter;
    if (animated) {
        hourRow = [_pickerView selectedRowInComponent:0];
        NSInteger selectedHour =  _maxHours ? hourRow % _maxHours : 0;
        hourRow = hourRow - (selectedHour - [components hour]);
        minuteRow = [_pickerView selectedRowInComponent:1];
        NSInteger selectedMinute = _maxMinutes ? minuteRow % _maxMinutes : 0;
        minuteRow = minuteRow - (selectedMinute - [components minute]);
        secondRow = [_pickerView selectedRowInComponent:2];
        NSInteger modValue = 60/_secondResolution;
        NSInteger selectedSecond = secondRow % modValue;
        secondRow = secondRow - (selectedSecond - [components second]/_secondResolution);
    }
    [_pickerView selectRow:hourRow inComponent:0 animated:animated];
    [_pickerView selectRow:minuteRow inComponent:1 animated:animated];
    [_pickerView selectRow:secondRow inComponent:2 animated:animated];
}

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval {
    [self _configureForTimeInterval:timeInterval animated:NO];
}

- (void)_addLabelForComponent:(NSInteger)component {
    CGFloat labelWidth = 10;
    CGFloat labelHeight = 30;
    CGRect labelFrame = CGRectMake((component + 1)*70 + 54, (160 - labelHeight)/2. - 1, labelWidth, labelHeight);
    if (component == 0) {
        labelFrame.origin.x += 2;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];

    
    [label setText:@":"];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [label setTextColor:styleManager.textColor];
    [label setFont:[styleManager.font fontWithSize:40]];
    [label setBackgroundColor:styleManager.backgroundColor];
    [self.pickerView addSubview:label];
}

#pragma mark - UIPickerView

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (component < 2 && !_labelPosistionedForComponent[component]) {
        [self _addLabelForComponent:component];
        _labelPosistionedForComponent[component] = YES;
    }
    
    UILabel *rowLabel = (UILabel *)view;
    if (!rowLabel) {
        rowLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,[pickerView rowSizeForComponent:component]}];
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [rowLabel setTextColor:styleManager.textColor];
        [rowLabel setFont:[styleManager.font fontWithSize:40]];
    }
    NSInteger rowValue = 0;
    if (component == 0) {
        rowValue = _maxHours ? row % _maxHours : 0;
    } else if (component == 2) {
        NSInteger modValue = 60/_secondResolution;
        rowValue = (row % modValue) * _secondResolution;
    } else {
        rowValue = _maxMinutes ? row % _maxMinutes : 0;
    }
    NSString *title = (component != 0) ? [NSString stringWithFormat:@"%02ld",(long)rowValue] : [NSString stringWithFormat:@"%ld",(long)rowValue];
    [rowLabel setText:title];
    NSTextAlignment alignment;
    switch (component) {
        case 0:
            alignment = NSTextAlignmentRight;
            break;
        case 1:
            alignment = NSTextAlignmentCenter;
            break;
        case 2:
            alignment = NSTextAlignmentLeft;
            break;
        default:
            alignment = NSTextAlignmentCenter;
            break;
    }
    [rowLabel setTextAlignment:alignment];
    return rowLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if ([self.delegate respondsToSelector:@selector(timePickerCell:didSetTimeInterval:)]) {
        NSTimeInterval timeInterval = [self _timeInterval];
        NSTimeInterval validTimeInvterval = [self.delegate timePickerCell:self didSetTimeInterval:timeInterval];
        if (timeInterval != validTimeInvterval) {
            [self _configureForTimeInterval:validTimeInvterval animated:YES];
        }
    }
}

//Tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return NUM_ROWS;
}

//Tells picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return CGRectGetHeight(pickerView.frame)/3.;
}

//Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    CGFloat componentWidth = _componentWidth;
    if (component != 1) {
        componentWidth = (CGRectGetWidth(pickerView.frame) - _componentWidth)/2.;
    }
    return componentWidth;
}

@end
