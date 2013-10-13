//
//  NSMutableArray+TMFrontLoading.m
//  TimeMe
//
//  Created by Clark Barry on 10/12/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "NSMutableArray+TMFrontLoading.h"

@implementation NSMutableArray (TMFrontLoading)
- (void)pushFront:(id)obj {
    [self insertObject:obj atIndex:0];
}
@end
