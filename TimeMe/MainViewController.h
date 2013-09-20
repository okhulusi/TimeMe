//
//  ViewController.h
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController
{}

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *intervalField;
@property (nonatomic, strong) UITextField *timerLengthField;
@property (nonatomic, strong) UIButton *startButton;

@end
