//
//  TMSnappingHeaderTableViewViewController.h
//  Bzz
//
//  Created by Clark Barry on 10/29/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TMSnappingHeaderViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (readonly) UITableView *tableView;
@property (nonatomic) UIView *headerView;

@end
