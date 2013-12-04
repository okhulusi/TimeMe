//
//  TMPageViewController.h
//  Bzz
//
//  Created by Clark Barry on 11/24/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMConfigurationViewController.h"
#import "TMAlertManager.h"
@interface TMPageViewController : UIViewController<UIPageViewControllerDataSource,UIPageViewControllerDelegate,TMConfigurationViewControllerDelegate,TMAlertDelegate>

@end
