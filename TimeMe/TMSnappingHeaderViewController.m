//
//  TMSnappingHeaderTableViewViewController.m
//  Bzz
//
//  Created by Clark Barry on 10/29/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMSnappingHeaderViewController.h"
#import "UIScrollView+TMTargetScoll.h"

enum {
    TMSrollDirectionNone = 0,
    TMScrollDirectionUp = 1,
    TMScrollDirectionDown = 2,
} typedef TMScrollDirection;

@interface TMSnappingHeaderViewController () {
    TMScrollDirection _scrollDirection;
    CGPoint _firstPoint;
    CGPoint _lastPoint;
}

- (void)_snapHeader;

@end

@implementation TMSnappingHeaderViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _scrollDirection = TMSrollDirectionNone;
    }
    return self;
}

- (void)setHeaderView:(UIView *)headerView {
    [_headerView removeFromSuperview];
    _headerView = headerView;
    CGRect headerRect = {0, -CGRectGetHeight(headerView.frame),headerView.frame.size};
    [_headerView setFrame:headerRect];
}

- (void)_snapHeader {
    CGFloat headerHeight = CGRectGetHeight(_headerView.frame);
    CGPoint scrollTarget;
    switch (_scrollDirection) {
        case TMScrollDirectionUp:
            scrollTarget = CGPointMake(0, headerHeight);
            break;
        case TMScrollDirectionDown:
            scrollTarget = CGPointMake(0, 0);
            break;
        default:
            break;
    }
    [_tableView setContentOffset:scrollTarget animated:YES];
}

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}


#pragma mark - UIScrollView

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _firstPoint = scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging) {
        CGFloat headerHeight = CGRectGetHeight(_headerView.frame);
        CGFloat translation = scrollView.contentOffset.y - _firstPoint.y;
        CGRect headerRect =  { 0, -headerHeight + translation, _headerView.frame.size};
        if (translation > 0) {
            headerRect.origin.y = MIN(-headerHeight, headerRect.origin.y);
        } else {
            headerRect.origin.y = MAX(0, headerRect.origin.y);
        }
        NSLog(@"%@",NSStringFromCGRect(headerRect));
        [_headerView setFrame:headerRect];
    }
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
