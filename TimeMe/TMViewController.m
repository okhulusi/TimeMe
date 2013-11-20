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
    
    NSMutableArray *_displayAlerts;
    NSMutableSet *_selectedAlerts;
    NSMutableSet *_addedAlerts;
    NSMutableSet *_hiddenAlerts;
}

- (void)_toggleButtonPressed;
- (void)_addButtonPressed;

- (void)_setUpViews;
- (void)_saveViewState;

- (void)_showTimePicker:(BOOL)show;
- (void)_fadeInView:(UIView *)inView outView:(UIView *)outView;
- (void)_configureForGeneratingAlerts:(BOOL)generatingAlerts animated:(BOOL)animated;

@end

@implementation TMViewController

- (id)init {
    if (self = [super init]) {
        [self setTitle:@"Bzz"];
        
        _showingPicker = NO;
        
        _displayAlerts = [[NSMutableArray alloc] init];
        _selectedAlerts = [[NSMutableSet alloc] init];
        _addedAlerts = [[NSMutableSet alloc] init];
        _hiddenAlerts = [[NSMutableSet alloc] init];

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
        NSArray *selectedAlerts = [_selectedAlerts allObjects];
        [alertManager startAlerts:selectedAlerts];
    } else {
        [alertManager stopAlerts];
    }
    [self _configureForGeneratingAlerts:alertManager.generatingAlerts animated:YES];
}

static NSString *kShowingPickerKey = @"showingpicker";
static NSString *kDisplayAlertsKey = @"displayalerts";
static NSString *kSelectedAlertsKey = @"selectedalerts";
static NSString *kAddedAlertsKey = @"addedalerts";
static NSString *kHiddenAlertsKey = @"hiddenalerts";

- (void)_setUpViews {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _showingPicker = [defaults boolForKey:kShowingPickerKey];
    NSArray *displayAlerts = [defaults objectForKey:kDisplayAlertsKey];
    [_displayAlerts removeAllObjects];
    [_displayAlerts addObjectsFromArray:displayAlerts];
    NSArray *selectedAlerts = [defaults objectForKey:kSelectedAlertsKey];
    [_selectedAlerts removeAllObjects];
    [_selectedAlerts addObjectsFromArray:selectedAlerts];
    NSArray *addedAlerts = [defaults objectForKey:kAddedAlertsKey];
    [_addedAlerts removeAllObjects];
    [_addedAlerts addObjectsFromArray:addedAlerts];
    NSArray *hiddenAlerts = [defaults objectForKey:kHiddenAlertsKey];
    [_hiddenAlerts removeAllObjects];
    [_hiddenAlerts addObjectsFromArray:hiddenAlerts];
    TMAlertManager *alertManager = [TMAlertManager getInstance];
    if (!alertManager.generatingAlerts && !alertManager.timerLength) {
        _showingPicker = YES;
    }
    [self _configureForGeneratingAlerts:alertManager.generatingAlerts animated:NO];
}

- (void)_saveViewState {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:_showingPicker forKey:kShowingPickerKey];
    [defaults setObject:_displayAlerts forKey:kDisplayAlertsKey];
    [defaults setObject:[_selectedAlerts allObjects] forKey:kSelectedAlertsKey];
    [defaults setObject:[_addedAlerts allObjects] forKey:kAddedAlertsKey];
    [defaults setObject:[_hiddenAlerts allObjects] forKey:kHiddenAlertsKey];
    [defaults synchronize];
}

- (void)_configureForGeneratingAlerts:(BOOL)generatingAlerts animated:(BOOL)animated {
    NSString *buttonTitle = generatingAlerts ? @"Stop" : @"Start";
    UIColor *buttonColor = generatingAlerts ? [UIColor redColor] : [UIColor colorWithRed:0x1F/256. green:0xFF/256. blue:0x52/256. alpha:.7];
    UIView *inView = generatingAlerts ? _timerView : _tableView;
    UIView *outView = generatingAlerts ? _tableView : _timerView;
    
    NSString *title = @"Bzz";
    if (generatingAlerts) {
        TMAlertManager *alertManager = [TMAlertManager getInstance];
        title = [NSString stringForTimeInterval:alertManager.timerLength style:TMTimeIntervalStringDigital];
    }
    [self setTitle:title];
    
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
    [addVC configureForTimeInterval:[TMAlertManager getInstance].timerLength];
    addVC.delegate = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addVC];
    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

#pragma mark - TMAddInterval

- (void)addIntervalController:(TMAddIntervalViewController *)addIntervalController didSelectInterval:(NSTimeInterval)timeInterval {
    if (timeInterval) {
        [_hiddenAlerts removeObject:@(timeInterval)];
        if (![_addedAlerts containsObject:@(timeInterval)]) {
            [_addedAlerts addObject:@(timeInterval)];
            TMAlertManager *alertManager = [TMAlertManager getInstance];
            if (timeInterval < alertManager.timerLength) {
                [_selectedAlerts addObject:@(timeInterval)];
                [_displayAlerts addObject:@(timeInterval)];
                NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
                [_displayAlerts sortUsingDescriptors:@[sortDescriptor]];
            }
        }
    }
    [addIntervalController.parentViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)addIntervalControllerDidCancel:(TMAddIntervalViewController *)addIntervalController {
    [addIntervalController.parentViewController dismissViewControllerAnimated:YES completion:nil];
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
    if (section == 1) {
        height = __headerHeight;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = nil;
    if (section == 1) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        UIColor *headerColor = [styleManager.backgroundColor colorWithAlphaComponent:1];
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
        rowCount = [_displayAlerts count];
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
        NSNumber *alertInterval = [_displayAlerts objectAtIndex:indexPath.row];
        BOOL isChecked = [_selectedAlerts containsObject:alertInterval];
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
        NSNumber *alertInterval = [_displayAlerts objectAtIndex:indexPath.row];
        if ([_selectedAlerts containsObject:alertInterval]) {
            [_selectedAlerts removeObject:alertInterval];
        } else {
            [_selectedAlerts addObject:alertInterval];
        }
        TMIntervalLabelCell *cell = (TMIntervalLabelCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell setChecked:[_selectedAlerts containsObject:alertInterval] animated:YES];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 1 ? UITableViewCellEditingStyleDelete : UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete && indexPath.section == 1) {
        NSNumber *alertInterval = [_displayAlerts objectAtIndex:indexPath.row];
        [_addedAlerts removeObject:alertInterval];
        [_selectedAlerts removeObject:alertInterval];
        [_displayAlerts removeObjectAtIndex:indexPath.row];
        [_tableView beginUpdates];
        [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [_tableView endUpdates];
    }
}

#pragma mark - TMTimePicker

- (NSTimeInterval)timePickerCell:(TMTimePickerCell *)timePickerCell didSetTimeInterval:(NSTimeInterval)timeInterval {
    TMTableViewCell *cell = (TMTableViewCell *)[_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSTimeInterval validTimeInterval = timeInterval;
    
    [cell configureForTimeInterval:validTimeInterval];

    TMAlertManager *alertManager = [TMAlertManager getInstance];
    [alertManager setTimerLength:validTimeInterval];
    
    [_displayAlerts removeAllObjects];
    NSArray *availableAlerts = [TMAlertManager alertIntervalsForTimerLength:alertManager.timerLength];
    [_displayAlerts addObjectsFromArray:availableAlerts];
    
    for (NSNumber *alertInterval in _hiddenAlerts) {
        [_displayAlerts removeObject:alertInterval];
    }
    
    for (NSNumber *alertInterval in _addedAlerts) {
        if ([alertInterval doubleValue] < alertManager.timerLength) {
            if (![_displayAlerts containsObject:alertInterval]) {
                [_displayAlerts addObject:alertInterval];
            }
        }
    }

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    [_displayAlerts sortUsingDescriptors:@[sortDescriptor]];
    
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
