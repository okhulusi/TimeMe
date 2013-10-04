//
//  TMTimePickerCell.h
//  TimeMe
//
//  Created by Clark Barry on 10/4/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMTimePickerCell;

@protocol TMTimePickerDelegate <NSObject>
- (void)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval;
@end

@interface TMTimePickerCell : UITableViewCell<UIPickerViewDelegate,UIPickerViewDataSource>

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier;
@property (weak) id<TMTimePickerDelegate>delegate;
@property (readonly) UIPickerView *pickerView;

@end
