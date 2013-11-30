//
//  TMConfigurationViewController.m
//  Bzz
//
//  Created by Clark Barry on 11/29/13.
//  Copyright (c) 2013 KCBODK. All rights reserved.
//

#import "TMConfigurationViewController.h"
#import "TMConfigurationTableViewCell.h"
#import "TMConfigurationManager.h"
#import "TMStyleManager.h"
#import "TMTimerConfiguration.h"

@interface TMConfigurationViewController ()
- (void)_doneButtonPressed;
- (void)_addButtonPressed;
@end

@implementation TMConfigurationViewController

- (void)_addButtonPressed {
    TMTimerConfiguration *configuration = [[TMTimerConfiguration alloc] init];
    TMConfigurationManager *configurationManager = [TMConfigurationManager getInstance];
    [configurationManager addTimerConfiguration:configuration];
    NSInteger rowCount = [self.tableView numberOfRowsInSection:0];
    NSIndexPath *insertPath = [NSIndexPath indexPathForRow:rowCount inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[insertPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)_doneButtonPressed {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadView {
    [super loadView];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(_doneButtonPressed)];
    [self.navigationItem setLeftBarButtonItem:doneButton];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(_addButtonPressed)];
    [self.navigationItem setRightBarButtonItem:addButton];
    TMStyleManager *styleManager = [TMStyleManager getInstance];
    [self.view setBackgroundColor:styleManager.backgroundColor];
    [self.tableView setBackgroundColor:styleManager.backgroundColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TMConfigurationManager *configurationManager = [TMConfigurationManager getInstance];
    return [configurationManager.configurations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kConfigurationCellId = @"Configurationcellid";
    TMConfigurationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfigurationCellId];
    if (!cell) {
        cell = [[TMConfigurationTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:kConfigurationCellId];
    }
    TMConfigurationManager *configurationManager = [TMConfigurationManager getInstance];
    TMTimerConfiguration *configuration = [configurationManager.configurations objectAtIndex:indexPath.row];
    [cell configureForTimerConfiguration:configuration];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        TMConfigurationManager *configurationManager = [TMConfigurationManager getInstance];
        [configurationManager removeTimerConfigurationAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

@end
