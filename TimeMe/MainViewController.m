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

- (id)init
{
    if(self = [super init]){
        timer = [[TMIntervalTimer alloc] init];
        [self setTitle:@"TimeMe"];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    CGFloat width = self.view.frame.size.width;
 // CGFloat height = self.view.frame.size.height;
    
    //Total Time Label
    totalTimePickerLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 85.0f, 140.0f, 200.0f, 30.0f)];
    [totalTimePickerLabel setText:@"Enter Total Time Length"];
    [self.view addSubview:totalTimePickerLabel];
    
    //Total Time Picker
    totalTimePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(width/2 - 100.0f, 100.0f, 200.0f, 30.0f)];
    totalTimePickerView.delegate = self;
    totalTimePickerView.showsSelectionIndicator = YES;
    [self.view addSubview:totalTimePickerView];
    totalTimePickerView.tag = 1;
    
    //Interval Time Label
    pickerViewLabel = [[UILabel alloc] initWithFrame:CGRectMake(width/2 - 85.0f,290.0f, 200.0f, 30.0f)];
    [pickerViewLabel setText:@"Enter a Vibrate Interval"];
    [self.view addSubview:pickerViewLabel];
    
    //Interval Time Picker
    intervalPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(width/2 - 100.0f, 250.0f, 200.0f, 30.0f)];
    intervalPickerView.delegate = self;
    intervalPickerView.showsSelectionIndicator = YES;
    [self.view addSubview:intervalPickerView];
    intervalPickerView.tag = 2;
    
    //Start Button
    timerToggleButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [timerToggleButton addTarget:self action:@selector(timerToggleButtonPressed) forControlEvents:UIControlEventTouchDown];
    [timerToggleButton setTitle:@"Start Timer" forState:UIControlStateNormal];
    timerToggleButton.frame = CGRectMake(width/2 - 100.0f, 400.0f, 200.0f, 30.0f);
    [self.view addSubview:timerToggleButton];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
     //Handles the Selection
    if(pickerView.tag == 1){
        [timer setTimerLength:row];
    } else{
        [timer setIntervalLength:row];
    }
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
    return 3;
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
    int sectionWidth = 60;
    return sectionWidth;
}

- (void) timerToggleButtonPressed
{
    [timer startTimer];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
