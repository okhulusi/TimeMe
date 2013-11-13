//
//  ViewController.m
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMViewController.h"

#import "TMTableViewCell.h"
#import "TMTimeLabelCell.h"
#import "TMIntervalLabelCell.h"
#import "TMTimePickerCell.h"
#import "TMTimerView.h"

#import "TMAlertManager.h"

#import "TMStyleManager.h"

#import "NSString+TMTimeIntervalString.h"
#import "TMAddIntervalViewController.h"
#import <AudioToolbox/AudioToolbox.h>

@interface TMViewController () {
    UITableView *_tableView;
    TMTimerView *_timerView;
    
    UIButton *_timerToggleButton;
    BOOL _showingPicker;
    
    NSArray *_sortedAlertIntervals;
    NSMutableDictionary *_selectedAlerts;
    NSMutableSet *_invisibleSelectedAlerts;
}

- (void)_toggleButtonPressed;
- (void)_addButtonPressed;
- (void)_fadeInView:(UIView *)inView outView:(UIView *)outView;
- (NSArray *)_selectedAlerts;

- (void)_setUpViews;
- (void)_saveViewState;


- (void)_showTimePicker:(BOOL)show;

- (void)_configureForGeneratingAlerts:(BOOL)generatingAlerts animated:(BOOL)animated;
@end

@implementation TMViewController

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Bzz"];
        
        _showingPicker = NO;
        _sortedAlertIntervals = [[NSMutableArray alloc] init];
        _selectedAlerts = [[NSMutableDictionary alloc] init];
        _invisibleSelectedAlerts = [[NSMutableSet alloc] init];
        TMAlertManager *alertManager = [TMAlertManager getInstance];
        [alertManager setDelegate:self];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_setUpViews)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(_saveViewState)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)_toggleButtonPressed {
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    if (!alertManager.generatingAlerts && alertManager.timerLength) {
        NSArray *selectedAlerts = [self _selectedAlerts];
        [alertManager startAlerts:selectedAlerts];
    } else {
        [alertManager stopAlerts];
    }
    [self _configureForGeneratingAlerts:alertManager.generatingAlerts animated:YES];
}

static NSString *kShowingPickerKey = @"showingpicker";
static NSString *kSelectedAlertsKey = @"selectedalerts";

- (void)_setUpViews {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    _showingPicker = [defaults boolForKey:kShowingPickerKey];
    NSDictionary *savedAlertIntervals = [[defaults dictionaryForKey:kSelectedAlertsKey] mutableCopy];
    if (savedAlertIntervals) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        for (NSString *stringKey in savedAlertIntervals) {
            NSNumber *numberKey = [formatter numberFromString:stringKey];
            NSNumber *valueForKey = [savedAlertIntervals objectForKey:stringKey];
            [_selectedAlerts setObject:valueForKey forKey:numberKey];
            if ([valueForKey boolValue]) {
                [_invisibleSelectedAlerts addObject:numberKey];
            }
        }
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
        _sortedAlertIntervals = [[_selectedAlerts allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]];
    } else {
        TMAlertManager *alertManager = [TMAlertManager getInstance];
        NSArray *availableAlerts = [TMAlertManager alertIntervalsForTimerLength:alertManager.timerLength];
        for (NSNumber *alertInterval in availableAlerts) {
            [_selectedAlerts setObject:@NO forKey:alertInterval];
        }
        
    }
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    if (!alertManager.generatingAlerts && !alertManager.timerLength) {
        _showingPicker = YES;
    }
    [self _configureForGeneratingAlerts:alertManager.generatingAlerts animated:NO];
}

- (void)_saveViewState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_showingPicker forKey:kShowingPickerKey];
    NSMutableDictionary *saveableSelectedAlerts = [[NSMutableDictionary alloc] init];
    for (NSNumber *alertInterval in _selectedAlerts) {
        NSNumber *valueForKey = [_selectedAlerts objectForKey:alertInterval];
        NSString *key = [alertInterval description];
        [saveableSelectedAlerts setObject:valueForKey forKey:key];
    }
    [defaults setObject:saveableSelectedAlerts forKey:kSelectedAlertsKey];
}

- (void)_configureForGeneratingAlerts:(BOOL)generatingAlerts animated:(BOOL)animated {
    NSString *buttonTitle = generatingAlerts ? @"Stop" : @"Start";
    UIColor *buttonColor = generatingAlerts ? [UIColor redColor] : [UIColor colorWithRed:0x1F/256. green:0xFF/256. blue:0x52/256. alpha:.7];
    UIView *inView = generatingAlerts ? _timerView : _tableView;
    UIView *outView =generatingAlerts ? _tableView : _timerView;
    
    if (generatingAlerts) {
        [_timerView beginUpdating];
    } else {
        [_tableView reloadData];
        [_timerView endUpdating];
    }
    
    if (buttonTitle) {
        [_timerToggleButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    if (buttonColor) {
        [_timerToggleButton setBackgroundColor:buttonColor];
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

- (void)_showTimePicker:(BOOL)show {
    NSIndexPath *pickerPath = [NSIndexPath indexPathForRow:1 inSection:0];
    if (show && !_showingPicker) {
        _showingPicker = YES;
        [_tableView insertRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (!show && _showingPicker) {
        UITableViewCell *cell = [_tableView cellForRowAtIndexPath:pickerPath];
        [cell.superview sendSubviewToBack:cell];
        _showingPicker = NO;
        [_tableView deleteRowsAtIndexPaths:@[pickerPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}

- (void)_addButtonPressed {
    TMAddIntervalViewController *addVC = [[TMAddIntervalViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];

}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    
    CGFloat buttonHeight = 60;
    CGRect tableFrame = self.view.frame;
    tableFrame.size.height -= buttonHeight;
    
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    [_tableView setBackgroundColor:styleManager.backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
    
    _timerView = [[TMTimerView alloc] initWithFrame:tableFrame];
    
    _timerToggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_timerToggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_timerToggleButton.titleLabel setFont:[styleManager.font fontWithSize:25]];
    [_timerToggleButton setTitle:@"Start" forState:UIControlStateNormal];
    [_timerToggleButton setFrame:CGRectMake(0, CGRectGetMaxY(tableFrame),
                                           CGRectGetWidth(self.view.frame), buttonHeight)];
    [_timerToggleButton addTarget:self action:@selector(_toggleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timerToggleButton];
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    [self _configureForGeneratingAlerts:alertManager.generatingAlerts animated:NO];
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

static CGFloat __headerHeight = 60;
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0;
    if (section == 1 && [_sortedAlertIntervals count]) {
        height = __headerHeight;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (section == 1 && [_sortedAlertIntervals count]) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        UIColor *headerColor = [styleManager.backgroundColor colorWithAlphaComponent:.95];
        CGFloat padding = 10;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(padding + 5, padding,
                                                                   CGRectGetWidth(self.view.frame)-(2*padding), __headerHeight - (2*padding))];

        [label setText:@"Bzz me at:"];
        label.textAlignment = NSTextAlignmentLeft;
        [label setBackgroundColor:styleManager.backgroundColor];
        [label setTextColor:styleManager.textColor];
        [label setFont:[styleManager.font fontWithSize:19]];
        headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,
                                                              CGRectGetWidth(self.view.frame), __headerHeight)];
        [headerView setBackgroundColor: headerColor];
        [headerView addSubview:label];
        
        UIButton *addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [addButton setTitle:@"+" forState:UIControlStateNormal];
        [addButton.titleLabel setFont:[styleManager.font fontWithSize:30]];
        [addButton setTitleColor:styleManager.textColor forState:UIControlStateNormal];
        [addButton setBackgroundColor:styleManager.backgroundColor];
        [addButton setFrame:CGRectMake(CGRectGetWidth(self.view.frame) - 70, 0, 70, __headerHeight)];
        [addButton addTarget:self action:@selector(_addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [headerView addSubview:addButton];
    }
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger rowCount;
    if (section == 0) {
        rowCount = 1;
        if (_showingPicker) {
            rowCount++;
        }
    } else {
        rowCount = [_sortedAlertIntervals count];
    }
    return rowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { // should be lightweight
    TMTableViewCell *cell = nil;
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    NSTimeInterval timeInterval = alertManager.timerLength;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) { //we display info on the timer, not the timer picker itself
            static NSString *kTimerPickerTitleCellID = @"timercelltitlepickerid";
            cell = [tableView dequeueReusableCellWithIdentifier:kTimerPickerTitleCellID];
            if (!cell) {
                cell = [[TMTimeLabelCell alloc] initWithReuseIdentifier:kTimerPickerTitleCellID];
            }
            
            NSString *titleText = @"Duration";
            [cell.textLabel setText:titleText];
        } else { //display a pickerview for this one
            static NSString *kPickerViewCellID = @"pickerviewcellid";
            cell = [tableView dequeueReusableCellWithIdentifier:kPickerViewCellID];
            if (!cell) {
                cell = [[TMTimePickerCell alloc] initWithReuseIdentifier:kPickerViewCellID];
                ((TMTimePickerCell *)cell).delegate = self;

            }
        }
    } else {
        static NSString *kAlertIntervalCellID = @"alertintervalcellid";
        cell = [tableView dequeueReusableCellWithIdentifier:kAlertIntervalCellID];
        if (!cell) {
            cell = [[TMIntervalLabelCell alloc] initWithReuseIdentifier:kAlertIntervalCellID];
        }
        NSNumber *alertInterval = [_sortedAlertIntervals objectAtIndex:indexPath.row];
        BOOL isChecked = [[_selectedAlerts objectForKey:alertInterval] boolValue];
        timeInterval = [alertInterval doubleValue];
        [(TMIntervalLabelCell *)cell setChecked:isChecked animated:NO];
    }
    [cell configureForTimeInterval:timeInterval];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0 && indexPath.row == 0) {
        [self _showTimePicker:!_showingPicker];
    } else if (indexPath.section == 1){
        NSNumber *alertInterval = [_sortedAlertIntervals objectAtIndex:indexPath.row];
        BOOL checked = ![[_selectedAlerts objectForKey:alertInterval] boolValue];
        SEL setAction = checked ? @selector(addObject:) : @selector(removeObject:);
        [_invisibleSelectedAlerts performSelector:setAction withObject:alertInterval];
        [_selectedAlerts setObject:[NSNumber numberWithBool:checked] forKey:alertInterval];
        TMIntervalLabelCell *cell = (TMIntervalLabelCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setChecked:checked animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    if (indexPath.section == 0) {
        height = 75;
        if (indexPath.row == 1) { //its a picker row
            height = 120;
        }
    }
    return height;
}

#pragma mark - TMTimePicker

- (NSTimeInterval)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    TMTableViewCell *cell = (TMTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSTimeInterval validTimeInterval = timeInterval;
    
    [cell configureForTimeInterval:validTimeInterval];

    TMAlertManager *alertManager = [TMAlertManager getInstance];
    
    NSArray *alertManagerAlertsForOldInterval = [TMAlertManager alertIntervalsForTimerLength:alertManager.timerLength];
    NSMutableSet *alertsToRemove = [[NSMutableSet alloc] initWithArray:alertManagerAlertsForOldInterval];
    [alertManager setTimerLength:validTimeInterval];
    NSArray *availableAlerts = [TMAlertManager alertIntervalsForTimerLength:alertManager.timerLength];
    
    NSSet *alertsToKeep = [[NSSet alloc] initWithArray:availableAlerts];
    [alertsToRemove minusSet:alertsToKeep];
    
    NSMutableDictionary *alertsForLatestTimeInterval = [_selectedAlerts mutableCopy];
    for (NSNumber *alertInterval in _selectedAlerts) {
        if ([alertInterval doubleValue] >= alertManager.timerLength) {
            [alertsForLatestTimeInterval removeObjectForKey:alertInterval];
        }
    }
    
    for (NSNumber *alertInterval in alertsToRemove) {
        [alertsForLatestTimeInterval removeObjectForKey:alertInterval];
    }


    for (NSNumber *alertInterval in availableAlerts) {
        if (![alertsForLatestTimeInterval objectForKey:alertInterval]) {
            NSNumber *isChecked = @NO;
            if ([_invisibleSelectedAlerts containsObject:alertInterval]) {
                isChecked = @YES;
            }
            [alertsForLatestTimeInterval setObject:isChecked forKey:alertInterval];
        }
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    _sortedAlertIntervals = [[alertsForLatestTimeInterval allKeys] sortedArrayUsingDescriptors:@[sortDescriptor]];
    _selectedAlerts = alertsForLatestTimeInterval;
    
    [_tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation: UITableViewRowAnimationAutomatic];            
    
    return validTimeInterval;
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
    _showingPicker = NO;
    [_tableView reloadData];
    
    [self _configureForGeneratingAlerts:NO animated:YES];
}

@end
