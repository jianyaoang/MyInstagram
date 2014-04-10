//
//  FollowingViewController.m
//  MyInstagram
//
//  Created by user on 4/8/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "FollowingViewController.h"
#import <Parse/Parse.h>
@interface FollowingViewController ()
{
    NSMutableArray* photos;
    NSMutableArray* tempPhotos;
    IBOutlet UITableView *followingTableView;
}

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
    self.parseClassName = @"Activity";

    [super viewDidLoad];
    
    //[self createFollowingActivitesForUser:nil];
    
    [self getFollowingPhotos];
    
    
}

- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFTableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath object:object];
    cell.imageView.file = photos[indexPath.row];
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return photos.count;
}


//temp method to get photos liked by a user
-(void)getFollowingPhotos
{
    NSLog(@"get following photos");
    
    //set the object class to look for activites
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    
    //set the field to search and the value of the field
    [activityQuery whereKey:@"ActivityType" equalTo:@"follow"];
    //[activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             // The find succeeded.
             NSLog(@"Successfully retrieved %d liked photos.", objects.count);
             
             //loop over all the activities and get the photo for each one,
             //then add it to the photo array
             for (PFObject *activity in objects)
             {
                 // This does not require a network access.
                 PFObject *photo = activity[@"photo"];
                 [photos addObject:photo];
                 
                 NSLog(@"retrieved related photo: %@", photo);
             }
             
             [followingTableView reloadData];
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
}


//temp method to get photos liked by a user
-(void)getPhotos
{
    
    //set the object class to look for activites
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Photo"];
    
    //set the field to search and the value of the field
    [activityQuery whereKey:@"user" equalTo:@"ip69EIBEtb"];
    
    // Include the post data with each comment
    [activityQuery includeKey:@"photo"];
    
    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             // The find succeeded.
             //NSLog(@"Successfully retrieved %d liked photos.", objects.count);
             
             //loop over all the activities and get the photo for each one,
             //then add it to the photo array
             for (PFObject *activity in objects)
             {
                 // This does not require a network access.
                 PFObject *photo = activity[@"photo"];
                 [photos addObject:photo];
                 
                 NSLog(@"retrieved related photo: %@", photo);
             }
             
             [followingTableView reloadData];
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
}

@end
