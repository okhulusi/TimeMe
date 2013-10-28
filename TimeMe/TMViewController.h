//
//  ViewController.h
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMHeaderViewController.h"
#import "TMTimePickerCell.h"
#import "TMAlertManager.h"

@interface TMViewController : TMHeaderViewController<TMTimePickerDelegate, TMAlertDelegate>
@end
