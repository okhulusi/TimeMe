//
//  TMTimePickerView.h
//  Bzz
//
//  Created by Clark Barry on 10/28/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTimePickerView;

@protocol TMTimePickerDelegate <NSObject>
//returns the timeinterval that the picker should set itself to, return the time interval sent to keep the changes
- (NSTimeInterval)timePickerCell:(TMTimePickerView *)timePickerView didSetTimeInterval:(NSTimeInterval)timeInterval;
@end

@interface TMTimePickerView : UIView<UIPickerViewDelegate,UIPickerViewDataSource>

@property (weak) id<TMTimePickerDelegate>delegate;
@property (readonly) UIPickerView *pickerView;

@end
