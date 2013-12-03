//
//  TMConfigurationViewController.h
//  Bzz
//
//  Created by Clark Barry on 11/29/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TMConfigurationViewController;
@protocol TMConfigurationViewControllerDelegate <NSObject>

- (void)configurationViewController:(TMConfigurationViewController *)configurationViewController didSelectIndex:(NSInteger)index;

@end

@interface TMConfigurationViewController : UITableViewController
@property (weak) id<TMConfigurationViewControllerDelegate>delegate;
@end
