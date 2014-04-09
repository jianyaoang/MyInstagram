//
//  FollowingViewController.m
//  MyInstagram
//
//  Created by user on 4/8/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "FollowingViewController.h"

@interface FollowingViewController ()

@end

@implementation FollowingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.parseClassName = @"User";
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFTableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath object:object];
    cell.imageView.file = [object objectForKey:@"photo"];
    [cell.imageView loadInBackground];
    return cell;
}

@end
