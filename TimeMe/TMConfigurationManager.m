//
//  TMConfigurationManager.m
//  Bzz
//
//  Created by Clark Barry on 11/24/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMConfigurationManager.h"

@interface TMConfigurationManager () {
    NSMutableArray *_configurations;
}

- (void)_saveConfigurations;

@end

@implementation TMConfigurationManager

@synthesize configurations = _configurations;

+ (instancetype)getInstance {
    static TMConfigurationManager *__instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [[TMConfigurationManager alloc] init];
    });
    return __instance;
}

static NSString *kConfigurationsArrayKey = @"configurationsarray";

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSData *configurationsData = [defaults objectForKey:kConfigurationsArrayKey];
        if (configurationsData) {
            _configurations = [[NSKeyedUnarchiver unarchiveObjectWithData:configurationsData] mutableCopy];
        } else {
            _configurations = [[NSMutableArray alloc] init];
        }
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_saveConfigurations)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
    }
    return self;
}

- (void)_saveConfigurations {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_configurations] forKey:kConfigurationsArrayKey];
    [defaults synchronize];
}

- (void)addTimerConfiguration:(TMTimerConfiguration *)configuration {
    [_configurations addObject:configuration];
}

- (void)removeTimerConfigurationAtIndex:(NSInteger)index {
    [_configurations removeObjectAtIndex:index];
}
@end
