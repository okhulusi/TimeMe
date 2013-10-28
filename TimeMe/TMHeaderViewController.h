//
//  TMHeaderViewController.h
//  Bzz
//
//  Created by Clark Barry on 10/27/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMHeaderViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (readonly) UITableView *tableView;
@property (readonly) UIView *headerView;
@property (nonatomic) CGFloat minHeaderHeight;
@property (nonatomic) CGFloat maxHeaderHeight;
@end
