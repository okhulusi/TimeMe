//
//  TMSectionHeader.h
//  Bzz
//
//  Created by Clark Barry on 12/1/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TMSectionHeaderDelegate <NSObject>
- (void)sectionHeaderEditButtonPressed;
- (void)sectionHeaderAddButtonPressed;
@end

@interface TMSectionHeader : UIView
- (void)setEditing:(BOOL)editing;
- (void)setEnabled:(BOOL)enabled;

@property (weak) id<TMSectionHeaderDelegate>delegate;
@end
