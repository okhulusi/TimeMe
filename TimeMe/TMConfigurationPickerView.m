//
//  TMConfigurationPickerView.m
//  Bzz
//
//  Created by Clark Barry on 11/21/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMConfigurationPickerView.h"
#import "TMTimerConfiguration.h"
#import "TMConfigurationView.h"

@interface TMConfigurationPickerView () {
    NSMutableArray *_configurations;
    NSInteger _currentIndex;
    UIPageControl *_pageControl;
    UIScrollView *_scrollView;
    TMConfigurationView *_leftView;
    TMConfigurationView *_middleView;
    TMConfigurationView *_rightView;
}

- (void)_buildScrollView;
- (void)_configureViews;
@end


@implementation TMConfigurationPickerView

static NSString *kCurrentIndexKey = @"currentindexpicker";
static NSString *kConfigurationsArrayKey = @"configurationsarray";

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        _currentIndex = [defaults integerForKey:kCurrentIndexKey];
        NSData *configurationsData = [defaults objectForKey:kConfigurationsArrayKey];
        if (configurationsData) {
            _configurations = [[NSKeyedUnarchiver unarchiveObjectWithData:configurationsData] mutableCopy];
        } else {
            _configurations = [[NSMutableArray alloc] init];
        }
        [self _buildScrollView];
    }
    return self;
}

- (void)saveConfigurations {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:_currentIndex forKey:kCurrentIndexKey];
    [defaults setObject:[NSKeyedArchiver archivedDataWithRootObject:_configurations] forKey:kConfigurationsArrayKey];
    [defaults synchronize];
}

- (void)refreshViews {
    [self _configureViews];
}

- (TMTimerConfiguration *)currentConfiguration {
    return [_configurations objectAtIndex:_currentIndex];
}

- (void)_buildScrollView {
    while ([_configurations count] < 3) {
        TMTimerConfiguration *configuration = [[TMTimerConfiguration alloc] init];
        [_configurations addObject:configuration];
    }
    
    CGFloat pageControlHeight = 20;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, pageControlHeight
                                                                 , CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - pageControlHeight)];
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame) - pageControlHeight)];
    CGPoint offset = CGPointMake(0, 0);
    if (_currentIndex != 0) {
        offset.x = CGRectGetWidth(self.frame);
    }
    [_scrollView setContentOffset:offset];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setDelegate:self];
    [_scrollView setPagingEnabled:YES];
    [self addSubview:_scrollView];

    
    CGRect viewRect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - pageControlHeight);
    _leftView = [[TMConfigurationView alloc] initWithFrame:viewRect];
    [_scrollView addSubview:_leftView];
    
    viewRect.origin.x += CGRectGetWidth(self.frame);
    _middleView = [[TMConfigurationView alloc] initWithFrame:viewRect];
    [_scrollView addSubview:_middleView];
    
    viewRect.origin.x += CGRectGetWidth(self.frame);
    _rightView = [[TMConfigurationView alloc] initWithFrame:viewRect];
    [_scrollView addSubview:_rightView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0,
                                                                   CGRectGetWidth(self.frame), pageControlHeight)];
    [_pageControl setNumberOfPages:[_configurations count]];
    [_pageControl setDefersCurrentPageDisplay:YES];
    [self addSubview:_pageControl];
    
    [self _configureViews];
}

- (void)_configureViews {
    if (_currentIndex == 0) {
        [_leftView configureForTimerConfiguration:[_configurations objectAtIndex:0]];
        [_middleView configureForTimerConfiguration:[_configurations objectAtIndex:1]];
        [_rightView configureForTimerConfiguration:[_configurations objectAtIndex:2]];
    } else {
        [_leftView configureForTimerConfiguration:[_configurations objectAtIndex:_currentIndex - 1]];
        [_middleView configureForTimerConfiguration:[_configurations objectAtIndex:_currentIndex]];
        if (_currentIndex == [_configurations count] - 1) {
            TMTimerConfiguration *configuration = [[TMTimerConfiguration alloc] init];
            [_configurations addObject:configuration];
            [_pageControl setNumberOfPages:[_configurations count]];
        }
        [_rightView configureForTimerConfiguration:[_configurations objectAtIndex:_currentIndex + 1]];
    }
}

#pragma mark - UIScrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if ((_scrollView.contentOffset.x <= 0 && _currentIndex > 0) || (_scrollView.contentOffset.x <= _scrollView.frame.size.width && _currentIndex == [_configurations count])) {
        _currentIndex -= 1;
    } else if((_scrollView.contentOffset.x >= _scrollView.frame.size.width*2) || (_scrollView.contentOffset.x >= _scrollView.frame.size.width && _currentIndex == 0)){
        _currentIndex += 1;
        if (_currentIndex == [_configurations count]) {
            TMTimerConfiguration *configuration = [[TMTimerConfiguration alloc] init];
            [_configurations addObject:configuration];
            [_pageControl setNumberOfPages:[_configurations count]];
        }
    }
    if (_currentIndex > 0) {
        [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
    }
    [self _configureViews];
    [self.delegate configurationPicker:self didSelectConfiguration:self.currentConfiguration];
    [_pageControl setCurrentPage:_currentIndex];
}

@end
