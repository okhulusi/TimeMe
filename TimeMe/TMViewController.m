//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMViewController.h"

#import "TMTimePickerView.h"

#import "TMTableViewCell.h"
#import "TMTimeLabelCell.h"
#import "TMIntervalLabelCell.h"
#import "TMTimerView.h"

#import "TMAlertManager.h"

#import "TMStyleManager.h"

#import "NSString+TMTimeIntervalString.h"

#import <AudioToolbox/AudioToolbox.h>



@interface TMViewController () {
    TMTimerView *_timerView;
    
    UIButton *_timerToggleButton;
    
    NSMutableDictionary *_selectedAlerts;
}

- (void)_toggleButtonPressed;
- (void)_fadeInView:(UIView *)inView outView:(UIView *)outView;
- (NSArray *)_selectedAlerts;
- (void)_setUpViews;

- (void)_configureForGeneratingAlerts:(BOOL)generatingAlerts animated:(BOOL)animated;
@end

@implementation TMViewController

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Bzz"];
        
        _selectedAlerts = [[NSMutableDictionary alloc] init];
        TMAlertManager *alertManager = [TMAlertManager getInstance];
        [alertManager setDelegate:self];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_setUpViews)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_toggleButtonPressed {
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    if (!alertManager.generatingAlerts) {
        NSArray *selectedAlerts = [self _selectedAlerts];
        [alertManager startAlerts:selectedAlerts];
    } else {
        [alertManager stopAlerts];
    }
    [self _configureForGeneratingAlerts:alertManager.generatingAlerts animated:YES];
}

- (void)_setUpViews {
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    [self _configureForGeneratingAlerts:alertManager.generatingAlerts animated:NO];
}

- (void)_configureForGeneratingAlerts:(BOOL)generatingAlerts animated:(BOOL)animated {
    NSString *buttonTitle = generatingAlerts ? @"Stop" : @"Start";
    UIColor *titleColor = generatingAlerts ? [UIColor redColor] : [UIColor colorWithRed:0x31/256. green:.6 blue:0x02/256. alpha:1];
    UIView *inView = generatingAlerts ? _timerView : self.tableView;
    UIView *outView =generatingAlerts ? self.tableView : _timerView;
    
    if (generatingAlerts) {
        [_timerView beginUpdating];
    } else {
        [self.tableView reloadData];
        [_timerView endUpdating];
    }
    
    if (buttonTitle) {
        [_timerToggleButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    if (titleColor) {
        [_timerToggleButton setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    if (animated) {
        [self _fadeInView:inView outView:outView];
    } else {
        [inView setAlpha:1];
        [self.view addSubview:inView];
        [outView removeFromSuperview];
    }
}

- (void)_fadeInView:(UIView *)inView outView:(UIView *)outView {
    [self.view addSubview:inView];
    [UIView animateWithDuration:.5
                     animations:^{
                         [inView setAlpha:1];
                         [outView setAlpha:0];
                     } completion:^(BOOL finished) {
                         [outView removeFromSuperview];
                     }];
}

- (NSArray *)_selectedAlerts {
    NSMutableArray *selectedAlerts = [[NSMutableArray alloc] init];
    for (NSNumber *alertInterval in _selectedAlerts) {
        NSNumber *isSelected = [_selectedAlerts objectForKey:alertInterval];
        if ([isSelected boolValue]) {
            [selectedAlerts addObject:alertInterval];
        }
    }
    return selectedAlerts;
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];

    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setEdgesForExtendedLayout:UIRectEdgeNone];

    CGFloat headerHeight = 60;
    CGRect headerFrame = CGRectMake(0, 0,
                                    CGRectGetWidth(self.view.frame), headerHeight);
    UIButton *durationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [durationButton setFrame:headerFrame];
    
    UIView *topView = [[UIView alloc] initWithFrame:headerFrame];
    UILabel *durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 0, 0)];
    [durationLabel setText:@"Duration"];
    [durationLabel setBackgroundColor:styleManager.backgroundColor];
    [durationLabel setTextColor:styleManager.textColor];
    [durationLabel setFont:styleManager.font];
    [durationLabel sizeToFit];
    CGPoint center = durationLabel.center;
    center.y = durationButton.center.y;
    [durationLabel setCenter:center];
    
    
    [durationButton addSubview:durationLabel];
    
    [topView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:durationButton];
    
    CGFloat buttonHeight = 60;
    CGRect tableFrame = self.view.frame;
    tableFrame.origin.y = headerHeight;
    tableFrame.size.height -= buttonHeight;
    tableFrame.size.height -= headerHeight;
    tableFrame.size.height -= 64;
    

    TMTimePickerView *timePicker = [[TMTimePickerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 2*headerHeight)];
    [timePicker setDelegate:self];
    
    [self.tableView setFrame:tableFrame];
    [self.tableView setBackgroundColor:[UIColor clearColor]];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self setHeaderView:timePicker];

    
    _timerView = [[TMTimerView alloc] initWithFrame:tableFrame];
    
    _timerToggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_timerToggleButton setBackgroundColor:[UIColor colorWithRed:0xE9/256. green:0xE5/256. blue:0x8E/256. alpha:.9]];
    [_timerToggleButton.titleLabel setFont:[styleManager.font fontWithSize:25]];
    [_timerToggleButton setTitle:@"Start" forState:UIControlStateNormal];
    [_timerToggleButton setFrame:CGRectMake(0, CGRectGetMaxY(tableFrame),
                                           CGRectGetWidth(self.view.frame), buttonHeight)];
    [_timerToggleButton addTarget:self action:@selector(_toggleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timerToggleButton];
    
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    [alertManager setTimerLength:6000];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_selectedAlerts removeAllObjects];
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    NSArray *availableAlerts = alertManager.alertIntervals;
    for (NSNumber *alertInterval in availableAlerts) {
        [_selectedAlerts setObject:@NO forKey:alertInterval];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    [self _configureForGeneratingAlerts:alertManager.generatingAlerts animated:NO];
}


#pragma mark - UITableView

static CGFloat __headerHeight = 44;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if ([[TMAlertManager getInstance].alertIntervals count]) {
        height = __headerHeight;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if ([[TMAlertManager getInstance].alertIntervals count]) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        UIColor *headerColor = [styleManager.backgroundColor colorWithAlphaComponent:.95];
        CGFloat padding = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding + 5, padding,
                                                                   CGRectGetWidth(self.view.frame)-(2*padding), __headerHeight - (2*padding))];

        [label setText:@"Bzz me at:"];
        label.textAlignment = NSTextAlignmentLeft;
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:styleManager.textColor];
        [label setFont:[styleManager.font fontWithSize:19]];
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              CGRectGetWidth(self.view.frame), __headerHeight)];
        [headerView setBackgroundColor: headerColor];
        [headerView addSubview:label];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount = [[TMAlertManager getInstance].alertIntervals count];
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { // should be lightweight
    TMTableViewCell *cell = nil;
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    static NSString *kAlertIntervalCellID = @"alertintervalcellid";
    cell = [tableView dequeueReusableCellWithIdentifier:kAlertIntervalCellID];
    if (!cell) {
        cell = [[TMIntervalLabelCell alloc] initWithReuseIdentifier:kAlertIntervalCellID];
    }
    NSNumber *alertInterval = [alertManager.alertIntervals objectAtIndex:indexPath.row];
    BOOL isChecked = [[_selectedAlerts objectForKey:alertInterval] boolValue];
    NSTimeInterval timeInterval = [alertInterval doubleValue];
    [(TMIntervalLabelCell *)cell setChecked:isChecked animated:NO];
    [cell configureForTimeInterval:timeInterval];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    NSNumber *alertInterval = [alertManager.alertIntervals objectAtIndex:indexPath.row];
    BOOL checked = ![[_selectedAlerts objectForKey:alertInterval] boolValue];
    [_selectedAlerts setObject:[NSNumber numberWithBool:checked] forKey:alertInterval];
    TMIntervalLabelCell *cell = (TMIntervalLabelCell *)[tableView cellForRowAtIndexPath:indexPath];
    [cell setChecked:checked animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    return height;
}


#pragma mark - TMTimePicker

- (NSTimeInterval)timePickerCell:(TMTimePickerView *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    [alertManager setTimerLength:timeInterval];
    
    [_selectedAlerts removeAllObjects];
    NSArray *availableAlerts = alertManager.alertIntervals;
    for (NSNumber *alertInterval in availableAlerts) {
        [_selectedAlerts setObject:@NO forKey:alertInterval];
    }
    
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation: UITableViewRowAnimationAutomatic];
    
    return timeInterval;
}

#pragma mark - TMAlertManager

- (void)alertManager:(TMAlertManager *)alertManager didFireAlert:(NSNumber *)alert {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [_timerView setHighlighted:YES];
    double delayInSeconds = .3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [_timerView setHighlighted:NO];
    });
}

- (void)alertManager:(TMAlertManager *)alertManager didFinishAlerts:(NSNumber *)alert {
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    [self.tableView reloadData];
    
    [self _configureForGeneratingAlerts:NO animated:YES];
}

@end
