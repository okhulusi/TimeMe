//
//  UIScrollView+TMTargetScoll.m
//  Bzz
//
//  Created by Clark Barry on 10/31/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "UIScrollView+TMTargetScoll.h"

@implementation UIScrollView (TMTargetScoll)
- (CGPoint)restingPointForVelocity:(CGPoint)velocity {
    CGPoint start = self.contentOffset;
    CGFloat decelerationRate = self.decelerationRate;
    CGFloat dx = (velocity.x * velocity.x)/(2* decelerationRate);
    CGFloat dy = (velocity.y * velocity.y)/(2* decelerationRate);
    return CGPointMake(start.x + dx,start.y + dy);
}
@end
