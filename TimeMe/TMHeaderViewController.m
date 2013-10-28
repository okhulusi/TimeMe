//
//  TMHeaderViewController.m
//  Bzz
//
//  Created by Clark Barry on 10/27/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMHeaderViewController.h"

@interface TMHeaderViewController () {
    
    CGFloat _minHeaderHeight;
    CGFloat _maxHeaderHeight;
}

@end

@implementation TMHeaderViewController

#pragma mark - UIViewController

- (void)loadView {
    [super loadView];
    
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController setEdgesForExtendedLayout:UIRectEdgeNone];
    
    CGFloat headerHeight = 50;
    _minHeaderHeight = headerHeight;
    _maxHeaderHeight = headerHeight * 3;
    CGRect headerFrame = CGRectMake(0, CGRectGetMinY(self.view.frame),
                                    CGRectGetWidth(self.view.frame), headerHeight);
    _headerView = [[UIView alloc] initWithFrame:headerFrame];
    [_headerView setBackgroundColor:[UIColor redColor]];
    [self.view addSubview:_headerView];
    
    CGFloat buttonHeight = 60;
    CGRect tableFrame = self.view.frame;
    tableFrame.origin.y = CGRectGetMaxY(headerFrame);
    tableFrame.size.height -= buttonHeight;
    tableFrame.size.height -= headerHeight;
    tableFrame.size.height -= 64;
    
    _tableView = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [_tableView setDataSource:self];
    [_tableView setDelegate:self];
    [self.view addSubview:_tableView];
}

#pragma mark - UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat yOffset = scrollView.contentOffset.y;
    if (yOffset < 0 && yOffset > -(_maxHeaderHeight - _minHeaderHeight) ) {
        CGRect headerFrame = _headerView.frame;
        headerFrame.size.height = _minHeaderHeight - scrollView.contentOffset.y;
        [_headerView setFrame:headerFrame];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    CGFloat yOffset = scrollView.contentOffset.y;
    CGRect scrollFrame = scrollView.frame;
    if (yOffset < -(_maxHeaderHeight - _minHeaderHeight)/2.) {
        CGRect headerFrame = _headerView.frame;
        headerFrame.size.height = _maxHeaderHeight;
        [_headerView setFrame:headerFrame];
        [_headerView setBackgroundColor:[UIColor blueColor]];
        scrollFrame.origin.y = CGRectGetMaxY(_headerView.frame);
        scrollFrame.size.height = self.view.frame.size.height - _headerView.frame.size.height - 60;
    }
    [scrollView setFrame:scrollFrame];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath { // should be lightweight
    return nil;
}


@end
