//
//  ViewController.h
//  TimeMe
//
//  Created by Omar Khulusi on 9/20/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMSnappingHeaderViewController.h"
#import "TMTimePickerView.h"
#import "TMAlertManager.h"

@interface TMViewController : TMSnappingHeaderViewController<TMTimePickerDelegate, TMAlertDelegate>
@end
