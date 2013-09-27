//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "MainViewController.h"
#import "TMIntervalTimer.h"

@interface MainViewController ()


@end


@implementation MainViewController

@synthesize titleLabel = _titleLabel;
@synthesize startButton = _startButton;

@synthesize totalTimePickerLabel = _totalTimePickerLabel;
@synthesize totalTimePickerView = _totalTimePickerView;
@synthesize totalTime = _totalTime;

@synthesize intervalPickerView = _intervalPickerView;
@synthesize pickerViewLabel = _pickerViewLabel;
@synthesize interval = _interval;

- (void)loadView
{
    [super loadView];
    CGFloat width = self.view.frame.size.width;
 // CGFloat height = self.view.frame.size.height;
    
    //Title label
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 30.0f, 50.0f, 200.0f, 30.0f)];
    [_titleLabel setText:@"Time Me"];
    [self.view addSubview:_titleLabel];
    
    //Total Time Label
    _totalTimePickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 85.0f, 140.0f, 200.0f, 30.0f)];
    [_totalTimePickerLabel setText:@"Enter Total Time Length"];
    [self.view addSubview:_totalTimePickerLabel];
    
    //Total Time Picker
    _totalTimePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(width/2 - 100.0f, 100.0f, 200.0f, 30.0f)];
    _totalTimePickerView.delegate = self;
    _totalTimePickerView.showsSelectionIndicator = YES;
    [self.view addSubview:_totalTimePickerView];
    _totalTimePickerView.tag = 1;
    
    //Interval Time Label
    _pickerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 85.0f,290.0f, 200.0f, 30.0f)];
    [_pickerViewLabel setText:@"Enter a Vibrate Interval"];
    [self.view addSubview:_pickerViewLabel];
    
    //Interval Time Picker
    _intervalPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(width/2 - 100.0f, 250.0f, 200.0f, 30.0f)];
    _intervalPickerView.delegate = self;
    _intervalPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:_intervalPickerView];
    _intervalPickerView.tag = 2;
    
    //Start Button
    _startButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_startButton addTarget:self action:@selector(startButtonPressed) forControlEvents:UIControlEventTouchDown];
    [_startButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    _startButton.frame = CGRectMake(width/2 - 100.0f, 400.0f, 200.0f, 30.0f);
    [self.view addSubview:_startButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     //Handles the Selection
    if(pickerView.tag == 1){
        _totalTime = row;
    } else{
        _interval = row;
    }
    NSLog(@" Total Time: %d", _totalTime);
    NSLog(@" Interval: %d", _interval);
}

//Tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger numRows = 60;
    
    return numRows;
}

//Tells picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//Tell the picker the title for the given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *title;
    title = [@"" stringByAppendingFormat:@"%d", row];
    
    return title;
}

//Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int sectionWidth = 300;
    return sectionWidth;
}

- (void) startButtonPressed
{
    TMIntervalTimer *timer;
//    [timer initWithTimerLength: totalTimePicker.value andIntervalLength: intervalTimePicker.value];
    //Work with TimePlay Manager
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
