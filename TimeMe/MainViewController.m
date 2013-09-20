//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()


@end


@implementation MainViewController

@synthesize label = _label;
@synthesize intervalField = _intervalField;
@synthesize timerLengthField = _timerLengthField;
@synthesize startButton = _startButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 30.0f, 100.0f, 200.0f, 30.0f)];
    [_label setText:@"Time Me"];

    [self.view addSubview:_label];
    
    _intervalField = [[UITextField alloc] initWithFrame:CGRectMake(width/2 - 100.0f, 200.0f, 200.0f, 30.0f)];
    _intervalField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_intervalField];

    _timerLengthField =[ [UITextField alloc] initWithFrame:CGRectMake(width/2 - 100.0f, 300.0f, 200.0f, 30.0f)];
     _timerLengthField.borderStyle = UITextBorderStyleRoundedRect;
    [self.view addSubview:_timerLengthField];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchDown];
    [_startButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    _startButton.frame = CGRectMake(width/2 - 100.0f, 400.0f, 200.0f, 30.0f);
    [self.view addSubview:_startButton];
}

- (void) startButtonPressed{
    //Work with TimePlay Manager
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
