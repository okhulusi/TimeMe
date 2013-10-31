//
//  TMSnappingHeaderTableViewViewController.m
//  Bzz
//
//  Created by Clark Barry on 10/29/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMSnappingHeaderViewController.h"

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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.isDragging && !scrollView.isDecelerating) {
        if (scrollView.contentOffset.y < _headerView.frame.size.height) {
            if (scrollView.contentOffset.y > _lastPoint.y) {
                _scrollDirection = TMScrollDirectionUp;
            } else {
                _scrollDirection = TMScrollDirectionDown;
            }
            _lastPoint = scrollView.contentOffset;
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat headerHeight = _headerView.frame.size.height;
    if ( (!decelerate && scrollView.contentOffset.y < headerHeight) || scrollView.contentSize.height < CGRectGetHeight(_tableView.frame)) {
        [self _snapHeader];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat headerHeight = _headerView.frame.size.height;
    if (scrollView.contentOffset.y < headerHeight || scrollView.contentSize.height < CGRectGetHeight(_tableView.frame)) {
        [self _snapHeader];
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
