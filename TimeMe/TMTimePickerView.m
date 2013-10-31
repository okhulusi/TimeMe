//
//  TMTimePickerView.m
//  Bzz
//
//  Created by Clark Barry on 10/28/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimePickerView.h"
#import "TMStyleManager.h"

@interface TMTimePickerView () {
    CGFloat _componentWidth;
    BOOL _labelPositionedForComponent[2];
}

@end

@implementation TMTimePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _componentWidth = 60;
        
        TMStyleManager *styleManger = [TMStyleManager getInstance];
        [self setBackgroundColor:styleManger.backgroundColor];
        _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, -CGRectGetHeight(frame)/3.,
                                                                     CGRectGetWidth(frame), CGRectGetHeight(frame)/4.)];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        
        [self addSubview:_pickerView];
        
        [self setClipsToBounds:YES];
    }
    return self;
}

- (NSTimeInterval)_timeInterval {
    NSTimeInterval timeInterval = 0;
    for (int i = 0; i < _pickerView.numberOfComponents; i++) {
        NSInteger selectedRow = [_pickerView selectedRowInComponent:i];
        NSTimeInterval timeIntervalForComponent = pow(60,(_pickerView.numberOfComponents - i - 1)) * selectedRow;
        timeInterval += timeIntervalForComponent;
    }
    return timeInterval;
}

- (void)_configureForTimeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated {
    NSCalendar *calender = [NSCalendar currentCalendar];
    NSDate *startDate = [[NSDate alloc] init];
    NSDate *endDate = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:startDate];
    
    unsigned int conversionFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    NSDateComponents *components = [calender components:conversionFlags fromDate:startDate toDate:endDate options:0];
    
    [_pickerView selectRow:[components hour] inComponent:0 animated:animated];
    [_pickerView selectRow:[components minute] inComponent:1 animated:animated];
    [_pickerView selectRow:[components second] inComponent:2 animated:animated];
}

- (void)configureForTimeInterval:(NSTimeInterval)timeInterval {
    [self _configureForTimeInterval:timeInterval animated:NO];
}

- (void)_addLabelForComponent:(NSInteger)component {
    CGFloat labelWidth = 10;
    CGFloat labelHeight = 30;
    CGRect labelFrame = CGRectMake((component+2)*_componentWidth + 2, (160 - labelHeight)/2., labelWidth, labelHeight);
    if (component == 0) {
        labelFrame.origin.x += 6;
    }
    UILabel *label = [[UILabel alloc] initWithFrame:labelFrame];
    [label setBackgroundColor:[UIColor clearColor]];
    
    [label setText:@":"];
    [label setTextAlignment:NSTextAlignmentCenter];
    
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [label setTextColor:styleManager.textColor];
    [label setFont:[styleManager.font fontWithSize:35]];
    [self.pickerView addSubview:label];
}

#pragma mark - UIPickerView

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    if (component < 2 && !_labelPositionedForComponent[component]) {
        [self _addLabelForComponent:component];
        _labelPositionedForComponent[component] = YES;
    }
    
    UILabel *rowLabel = (UILabel *)view;
    if (!rowLabel) {
        rowLabel = [[UILabel alloc] initWithFrame:(CGRect){0,0,[pickerView rowSizeForComponent:component]}];
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [rowLabel setTextColor:styleManager.textColor];
        [rowLabel setFont:[styleManager.font fontWithSize:35]];
    }
    NSString *title = (component != 0) ? [NSString stringWithFormat:@"%02ld",(long)row] : [NSString stringWithFormat:@"%ld",(long)row];
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

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return CGRectGetHeight(self.frame)/2.;
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
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

//Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return _componentWidth;
}
@end
