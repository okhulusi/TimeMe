//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMViewController.h"

@interface TMViewController () {
    UILabel *_secLabel;
    UILabel *_minLabel;
    UILabel *_hourLabel;

    UILabel *_totalTimePickerLabel;
    UIPickerView *_totalTimePickerView;

    UILabel *_pickerViewLabel;
    UIPickerView *_intervalPickerView;

    TMIntervalTimer *_timer;

    UIButton *_timerToggleButton;
}


@end


@implementation TMViewController

- (id)init
{
    if(self = [super init]){
        _timer = [[TMIntervalTimer alloc] init];
        [self setTitle:@"TimeMe"];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    [self.view setBackgroundColor:[UIColor orangeColor]];
    CGFloat width = self.view.frame.size.width;
 // CGFloat height = self.view.frame.size.height;
    
    //Total Time Label
    _totalTimePickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 85.0f, 140.0f, 200.0f, 30.0f)];
    [_totalTimePickerLabel setText:@"Total Time Length"];
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
    _timerToggleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_timerToggleButton addTarget:self action:@selector(timerToggleButtonPressed) forControlEvents:UIControlEventTouchDown];
    [_timerToggleButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    _timerToggleButton.frame = CGRectMake(width/2 - 100.0f, 400.0f, 200.0f, 30.0f);
    [self.view addSubview:_timerToggleButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     //Handles the Selection
    if(pickerView.tag == 1){
        [_timer setTimerLength:row];
    } else{
        [_timer setIntervalLength:row];
    }
}

//Tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSUInteger numRows = 60;
    if (component == 0) { //60 is pretty unreasonable for an hour count
        numRows = 24;
    }
    return numRows;
}

//Tells picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

//Tell the picker the title for the given component
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *timeModifier = (component == 0) ? @"h" : (component == 1) ? @"m" : @"s";
    NSString *title = [NSString stringWithFormat:@"%02d%@",row,timeModifier];
    
    if (component != 2) { //if not a second component
//        title = [title stringByAppendingString:@":"];
    }
    return title;
}

//Tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    int sectionWidth = 60;
    return sectionWidth;
}

- (void) timerToggleButtonPressed
{
    [_timer startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
