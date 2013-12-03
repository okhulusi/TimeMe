//
//  TMSectionHeader.m
//  Bzz
//
//  Created by Clark Barry on 12/1/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMSectionHeader.h"
#import "TMStyleManager.h"

@interface TMSectionHeader () {
    UILabel *_label;
    UIButton *_addButton;
    UIButton *_editButton;
}

- (void)_addButtonPressed;
- (void)_editButtonPressed;

@end

@implementation TMSectionHeader

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        TMStyleManager *styleManager = [TMStyleManager getInstance];
        [self setBackgroundColor:styleManager.backgroundColor];
        
        _editButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_editButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_editButton setTitle:@"-" forState:UIControlStateNormal];
        [_editButton.titleLabel setFont:[styleManager.font fontWithSize:30]];
        [_editButton setTitleColor:styleManager.textColor forState:UIControlStateNormal];
        [_editButton setBackgroundColor:styleManager.backgroundColor];
        [_editButton addTarget:self action:@selector(_editButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_editButton];
        
        _label = [[UILabel alloc] init];
        [_label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_label setText:@"Bzz me at:"];
        [_label setTextAlignment:NSTextAlignmentCenter];
        [_label setBackgroundColor:styleManager.backgroundColor];
        [_label setTextColor:styleManager.textColor];
        [_label setFont:[styleManager.font fontWithSize:19]];
        [self addSubview:_label];
        
        _addButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_addButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_addButton setTitle:@"+" forState:UIControlStateNormal];
        [_addButton.titleLabel setFont:[styleManager.font fontWithSize:30]];
        [_addButton setTitleColor:styleManager.textColor forState:UIControlStateNormal];
        [_addButton setBackgroundColor:styleManager.backgroundColor];
        [_addButton addTarget:self action:@selector(_addButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addButton];
        
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_editButton
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_editButton
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_editButton
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_editButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                         attribute:NSLayoutAttributeLeading
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_editButton
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:_addButton
                                                         attribute:NSLayoutAttributeLeading
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
         [self addConstraint:[NSLayoutConstraint constraintWithItem:_label
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_addButton
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_addButton
                                                         attribute:NSLayoutAttributeHeight
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_addButton
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeHeight
                                                        multiplier:1.0
                                                          constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:_addButton
                                                         attribute:NSLayoutAttributeTrailing
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:self
                                                         attribute:NSLayoutAttributeTrailing
                                                        multiplier:1.0
                                                          constant:0]];
        [self setEditing:NO];
    }
    return self;
}

- (void)setEditing:(BOOL)editing {
    NSString *editTitle = editing ? @"x" : @"-";
    [_editButton setTitle:editTitle forState:UIControlStateNormal];
    [_addButton setHidden:editing];
}

- (void)_addButtonPressed {
    [self.delegate sectionHeaderAddButtonPressed];
}

- (void)_editButtonPressed {
    [self.delegate sectionHeaderEditButtonPressed];
}

@end
