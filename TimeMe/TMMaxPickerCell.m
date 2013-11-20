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

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.secondResolution = 5;
    }
    return self;
}

- (void)setMaxTimeInterval:(NSTimeInterval)maxTimeInterval {
    _maxTimeInterval = maxTimeInterval;
    self.maxHours = floor(maxTimeInterval/3600);
    if (self.maxHours == 0) {
        if (maxTimeInterval <= 60) {
            self.maxMinutes = 0;
        } else {
            self.maxMinutes = (maxTimeInterval-self.maxHours*60)/60;
            if (_maxTimeInterval > self.maxMinutes*60) {
                self.maxMinutes += 1;
            }
        }
    } else {
        self.maxMinutes = 60;
    }
}

@end
