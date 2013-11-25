//
//  TMPageViewController.m
//  Bzz
//
//  Created by Clark Barry on 11/24/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMPageViewController.h"
#import "TMStyleManager.h"
#import "TMTimerView.h"
#import "TMConfigurationManager.h"
#import "TMViewController.h"
#import "NSString+TMTimeIntervalString.h"

@interface TMPageViewController () {
    UIPageViewController *_pageViewController;
    UIPageControl *_pageControl;
    TMTimerView *_timerView;
    UIButton *_timerToggleButton;
}

- (void)_listButtonPressed;
- (void)_toggleButtonPressed;


- (void)_setUpViews;
- (void)_fadeInView:(NSArray *)inViews outView:(NSArray *)outViews;
- (void)_configureForGeneratingAlerts:(BOOL)generatingAlerts animated:(BOOL)animated;

@end

@implementation TMPageViewController

- (id)init {
    self = [super init];
    if (self) {
        [self setTitle:@"Bzz"];
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

- (void)_fadeInView:(NSArray *)inViews outView:(NSArray *)outViews {
    for (UIView *view in inViews) {
        [view setHidden:NO];
    }
    [UIView animateWithDuration:.5
                     animations:^{
                         for (UIView *view in inViews) {
                             [view setAlpha:1];
                         }
                         for (UIView *view in outViews) {
                             [view setAlpha:0];
                         }
                     } completion:^(BOOL finished) {
                         for (UIView *view in outViews) {
                             [view setHidden:YES];
                         }
                     }];
}

- (void)_configureForGeneratingAlerts:(BOOL)generatingAlerts animated:(BOOL)animated {
    NSString *buttonTitle = generatingAlerts ? @"Stop" : @"Start";
    UIColor *buttonColor = generatingAlerts ? [UIColor redColor] : [UIColor colorWithRed:0x1F/256. green:0xFF/256. blue:0x52/256. alpha:.7];
    NSArray *inViews = generatingAlerts ? @[_timerView] : @[_pageViewController.view];
    NSArray *outViews = generatingAlerts ? @[_pageViewController.view] : @[_timerView];
    
    NSString *title = @"Bzz";
    if (generatingAlerts) {
        TMAlertManager *alertManager = [TMAlertManager getInstance];
        title = [NSString stringForTimeInterval:alertManager.timerLength style:TMTimeIntervalStringDigital];
    }
    [self setTitle:title];
    
    if (generatingAlerts) {
        [_timerView beginUpdating];
    } else {
        //TODO:push page controller
        [_timerView endUpdating];
    }
    
    if (buttonTitle) {
        [_timerToggleButton setTitle:buttonTitle forState:UIControlStateNormal];
    }
    if (buttonColor) {
        [_timerToggleButton setBackgroundColor:buttonColor];
    }
    
    if (animated) {
        [self _fadeInView:inViews outView:outViews];
    } else {
        for (UIView *inView in inViews) {
            [inView setHidden:NO];
            [inView setAlpha:1];
        }
        for (UIView *outView in outViews) {
            [outView setHidden:YES];
        }
    }

}

- (void)loadView {
    [super loadView];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    
    UIButton *listButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *listImage = [UIImage imageNamed:@"ListIcon"];
    [listButton setBackgroundImage:listImage forState:UIControlStateNormal];
    UIImage *highlightImage = [UIImage imageNamed:@"ListIconHighlighted"];
    [listButton setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    [listButton addTarget:self action:@selector(_listButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [listButton setFrame:CGRectMake(0, 0, 44, 44)];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithCustomView:listButton];
    [self.navigationItem setLeftBarButtonItem:barButton];
    
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    
    _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    [_pageViewController setDataSource:self];
    
    TMConfigurationManager *configurationManager = [TMConfigurationManager getInstance];
    
    NSArray *configurations = configurationManager.configurations;
    NSMutableArray *configurationViewControllers = [[NSMutableArray alloc] init];
    for (TMTimerConfiguration *configuration in configurations) {
        TMViewController *viewController = [[TMViewController alloc] initWithConfiguration:configuration];
        [configurationViewControllers addObject:viewController];
    }
    [_pageViewController setViewControllers:configurationViewControllers
                              direction:UIPageViewControllerNavigationDirectionForward
                               animated:NO
                             completion:nil];
    [self.view addSubview:_pageViewController.view];
    
    _timerToggleButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_timerToggleButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_timerToggleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_timerToggleButton.titleLabel setFont:[styleManager.font fontWithSize:25]];
    [_timerToggleButton setTitle:@"Start" forState:UIControlStateNormal];
    [_timerToggleButton addTarget:self action:@selector(_toggleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timerToggleButton];
    
    _timerView = [[TMTimerView alloc] initWithFrame:CGRectZero];
    [_timerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_timerView setAlpha:0];
    [self.view addSubview:_timerView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [_pageControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_pageControl setNumberOfPages:[configurationViewControllers count]];
    [self.view addSubview:_pageControl];
    //fix pageviewcontroller view to top of pagecontrol
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageViewController.view
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageViewController.view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageViewController.view
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageViewController.view
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_pageControl
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:20]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_pageControl
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_timerToggleButton
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerToggleButton
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerToggleButton
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerToggleButton
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:60]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerToggleButton
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    //fix timerview to button
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_timerView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_timerToggleButton
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
}

@end
