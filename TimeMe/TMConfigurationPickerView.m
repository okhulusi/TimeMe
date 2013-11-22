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
    UIScrollView *_scrollView;
    TMConfigurationView *_leftView;
    TMConfigurationView *_middleView;
    TMConfigurationView *_rightView;
}

- (void)_buildScrollView;
- (void)_configureViews;
@end


@implementation TMConfigurationPickerView

@synthesize configurations = _configurations;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _configurations = [[NSMutableArray alloc] init];
        [self _buildScrollView];
    }
    return self;
}

static NSString *kCurrentIndexKey = @"currentindexpicker";
static NSString *kConfigurationsArrayKey = @"configurationsarray";

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [super encodeWithCoder:aCoder];
    [aCoder encodeInteger:_currentIndex forKey:kCurrentIndexKey];
    [aCoder encodeObject:[NSKeyedArchiver archivedDataWithRootObject:_configurations] forKey:kConfigurationsArrayKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _currentIndex = [aDecoder decodeIntegerForKey:kCurrentIndexKey];
        NSData *configurationsData = [aDecoder decodeObjectForKey:kConfigurationsArrayKey];
        if (configurationsData) {
            _configurations = [NSKeyedUnarchiver unarchiveObjectWithData:configurationsData];
        } else {
            _configurations = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)setCurrentIndex:(NSInteger)currentIndex {
    _currentIndex = currentIndex;
}
- (void)_buildScrollView {
    while ([_configurations count] < 3) {
        TMTimerConfiguration *configuration = [[TMTimerConfiguration alloc] init];
        [_configurations addObject:configuration];
    }
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame))];

    [_scrollView setDelegate:self];
    [_scrollView setPagingEnabled:YES];
    [self addSubview:_scrollView];

    
    CGRect viewRect = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    _leftView = [[TMConfigurationView alloc] initWithFrame:viewRect];
    [_scrollView addSubview:_leftView];
    
    viewRect.origin.x += CGRectGetWidth(self.frame);
    _middleView = [[TMConfigurationView alloc] initWithFrame:viewRect];
    [_scrollView addSubview:_middleView];
    
    viewRect.origin.x += CGRectGetWidth(self.frame);
    _rightView = [[TMConfigurationView alloc] initWithFrame:viewRect];
    [_scrollView addSubview:_rightView];
    
    [_scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.frame)*3, CGRectGetHeight(self.frame))];
    
    [self _configureViews];
}

- (void)_configureViews {
    [_leftView configureForTimerConfiguration:[_configurations objectAtIndex:0]];
    [_middleView configureForTimerConfiguration:[_configurations objectAtIndex:1]];
    [_rightView configureForTimerConfiguration:[_configurations objectAtIndex:2]];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if ((_scrollView.contentOffset.x <= 0 && _currentIndex > 0) || (_scrollView.contentOffset.x <= _scrollView.frame.size.width && _currentIndex == [_configurations count] && [_configurations count])) {
        _currentIndex -= 1;
        if (_currentIndex > 0) {
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        }
    } else if((_scrollView.contentOffset.x >= _scrollView.frame.size.width*2 && _currentIndex < [_configurations count]) || (_scrollView.contentOffset.x >= _scrollView.frame.size.width && _currentIndex == 0)){
        _currentIndex += 1;
        if(_currentIndex < [_configurations count]){
            [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width, 0)];
        }
    }
    [self _configureViews];
}

@end
