//
//  TMTimerConfiguration.m
//  Bzz
//
//  Created by Clark Barry on 11/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMTimerConfiguration.h"

static NSString *kSelectedTimeIntervalKey = @"selectedtimeintervalkey";
static NSString *kDisplayAlertsKey = @"displayalertskey";
static NSString *kSelectedAlertsKey = @"selectedalertskey";
static NSString *kAddedAlertsKey = @"addedalertskey";
static NSString *kHiddenAlertsKey = @"hiddenalertskey";

@implementation TMTimerConfiguration

- (id)init {
    self = [super init];
    if (self) {
        _selectedTimeInterval = 0;
        _displayAlerts = [[NSMutableArray alloc] init];
        _selectedAlerts = [[NSMutableSet alloc] init];
        _addedAlerts = [[NSMutableSet alloc] init];
        _hiddenAlerts = [[NSMutableSet alloc] init];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        _selectedTimeInterval = [aDecoder decodeDoubleForKey:kSelectedTimeIntervalKey];
        _displayAlerts = [aDecoder decodeObjectForKey:kDisplayAlertsKey];
        _selectedAlerts = [aDecoder decodeObjectForKey:kSelectedAlertsKey];
        _addedAlerts = [aDecoder decodeObjectForKey:kAddedAlertsKey];
        _hiddenAlerts = [aDecoder decodeObjectForKey:kHiddenAlertsKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeDouble:_selectedTimeInterval forKey:kSelectedTimeIntervalKey];
    [aCoder encodeObject:_displayAlerts forKey:kDisplayAlertsKey];
    [aCoder encodeObject:_selectedAlerts forKey:kSelectedAlertsKey];
    [aCoder encodeObject:_addedAlerts forKey:kAddedAlertsKey];
    [aCoder encodeObject:_hiddenAlerts forKey:kHiddenAlertsKey];
}

@end
