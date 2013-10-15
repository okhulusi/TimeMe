//
//  TMTimerView.h
//  TimeMe
//
//  Created by Clark Barry on 10/10/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMTimerView : UIView
- (void)beginUpdating;
- (void)endUpdating;
- (void)setHighlighted:(BOOL)highlighted;
@end
