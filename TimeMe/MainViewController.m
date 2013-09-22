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
@synthesize startButton = _startButton;
@synthesize pickerView = _pickerView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height;
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 30.0f, 100.0f, 200.0f, 30.0f)];
    [_label setText:@"Time Me"];

    [self.view addSubview:_label];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(width/2 - 100.0f, 200.0f, 200.0f, 30.0f)];
    _pickerView.delegate = self;
    _pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:_pickerView];
    
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchDown];
    [_startButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    _startButton.frame = CGRectMake(width/2 - 100.0f, 400.0f, 200.0f, 30.0f);
    [self.view addSubview:_startButton];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    //Handle the selection
}

//Tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    NSUInteger numRows = 60;
    
    return numRows;
}

//Tells picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

//Tell the picker the title for the given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSString *title;
    title = [@"" stringByAppendingFormat:@"%d", row];
    
    return title;
}

//Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    int sectionWidth = 300;
    
    return sectionWidth;
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
