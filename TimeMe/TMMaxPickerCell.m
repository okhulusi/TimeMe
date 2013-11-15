//
//  TMMaxPickerCell.m
//  Bzz
//
//  Created by Clark Barry on 11/15/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMMaxPickerCell.h"
#import "TMTimePickerCell_Private.h"

@implementation TMMaxPickerCell

- (void)setMaxTimeInterval:(NSTimeInterval)maxTimeInterval {
    _maxTimeInterval = maxTimeInterval;
    self.maxHours = floor(maxTimeInterval/3600);
    if (self.maxHours == 0) {
        self.maxMinutes =  (maxTimeInterval-self.maxHours*60)/60;
    } else {
        self.maxMinutes = 60;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger numRows = [super pickerView:pickerView numberOfRowsInComponent:component];
    if (component == 0 && !self.maxHours) {
        numRows = 1;
    }
    return numRows;
}

@end
