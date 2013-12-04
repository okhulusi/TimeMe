//
//  TMTimerConfiguration.h
//  Bzz
//
//  Created by Clark Barry on 11/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TMTimerConfiguration : NSObject<NSCoding>

@property (nonatomic) NSTimeInterval selectedTimeInterval;
@property (readonly) NSMutableArray *displayAlerts;
@property (readonly) NSMutableSet *selectedAlerts;
@property (readonly) NSMutableSet *addedAlerts;
@property (readonly) NSMutableSet *hiddenAlerts;

- (NSArray *)selectedAlertsForTimerInterval:(NSTimeInterval)timeInterval;

@end
