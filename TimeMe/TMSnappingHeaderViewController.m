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
    _headerView = headerView;
    [_tableView setTableHeaderView:headerView];
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
    [_tableView setTableHeaderView:_headerView];
    [self.view addSubview:_tableView];
}


#pragma mark - UIScrollView

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"willEndDraggin");
    CGPoint target = [scrollView restingPointForVelocity:velocity];
    NSLog(@"target = %@",NSStringFromCGPoint(target));
    CGFloat headerHeight = CGRectGetHeight(_headerView.frame);
    if (target.y < headerHeight) {
        if (_scrollDirection == TMScrollDirectionUp) {
            NSLog(@"Targetting hidden");
            targetContentOffset->x = 0;
            targetContentOffset->y = headerHeight;
        } else {
            NSLog(@"Targetting show");
            targetContentOffset->x = 0;
            targetContentOffset->y = 0;
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat headerHeight = CGRectGetHeight(_headerView.frame);
    if (scrollView.isDragging) {
        if (scrollView.contentOffset.y < headerHeight) {
            if (scrollView.contentOffset.y > _lastPoint.y) {
                _scrollDirection = TMScrollDirectionUp;
            } else {
                _scrollDirection = TMScrollDirectionDown;
            }
            _lastPoint = scrollView.contentOffset;
        }
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
