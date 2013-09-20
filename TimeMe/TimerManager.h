//
//  TimerManager.h
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerManager : NSObject
{}

@property int    intervalLength;
@property int    timerLength;

- (void) update: (NSInteger)dt;

@end
