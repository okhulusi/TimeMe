//
//  TMConfigurationManager.h
//  Bzz
//
//  Created by Clark Barry on 11/24/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TMTimerConfiguration;

@interface TMConfigurationManager : NSObject

@property (nonatomic) NSArray *configurations;

- (void)addTimerConfiguration:(TMTimerConfiguration *)configuration;
- (void)removeTimerConfigurationAtIndex:(NSInteger)index;

+ (instancetype)getInstance;

@end
