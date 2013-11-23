//
//  TMConfigurationPickerView.h
//  Bzz
//
//  Created by Clark Barry on 11/21/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TMConfigurationPickerView;
@class TMTimerConfiguration;
@protocol TMConfigurationPickerDelegate <NSObject>
- (void)configurationPicker:(TMConfigurationPickerView *)pickerView didSelectConfiguration:(TMTimerConfiguration *)configuration;
@end

@interface TMConfigurationPickerView : UIView<NSCoding,UIScrollViewDelegate>

- (void)refreshViews;
- (void)saveConfigurations;

@property (readonly) TMTimerConfiguration *currentConfiguration;
@property (weak) id<TMConfigurationPickerDelegate>delegate;

@end
