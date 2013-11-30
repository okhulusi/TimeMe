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

@interface TMConfigurationViewController ()

@end

@implementation TMConfigurationViewController

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        [self setTitle:@"Bzz"];
    }
    return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    TMConfigurationManager *configurationManager = [TMConfigurationManager getInstance];
    return [configurationManager.configurations count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kConfigurationCellId = @"Configurationcellid";
    TMConfigurationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kConfigurationCellId forIndexPath:indexPath];
    TMConfigurationManager *configurationManager = [TMConfigurationManager getInstance];
    TMTimerConfiguration *configuration = [configurationManager.configurations objectAtIndex:indexPath.row];
    [cell configureForTimerConfiguration:configuration];
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
