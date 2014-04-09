//
//  FollowingViewController.m
//  MyInstagram
//
//  Created by Jian Yao Ang on 4/7/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "FollowingViewController.h"

@interface FollowingViewController () <UITableViewDataSource, UITableViewDelegate>

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
    [super viewDidLoad];
}


//query searches for Users by name
- (void)onViewLoadSearch
{
    //set the object class to look for
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSinceNow:-86400];
    
    //set the field to search and the value of the field
    [query whereKey:@"updatedAt" greaterThan:date];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             // The find succeeded.
             //NSLog(@"Successfully retrieved %uld photos.", objects.count);
             
             //assign result array of photos to our array
             users = objects;
             [searchCollectionView reloadData];
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
}

#pragma mark - UICollectionViewDelegate Methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"followingCellID"];
    return cell;
}

@end
