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

    NSArray* photos;
}

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
    [super viewDidLoad];
    
    [self getFollowingPhotos];
    
    
}


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFTableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath object:object];
    cell.imageView.file = [object objectForKey:@"photo"];
    [cell.imageView loadInBackground];
    return cell;
}


//temp method to get photos liked by a user
-(void)getFollowingPhotos
{
    
    //set the object class to look for activites
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    
    //set the field to search and the value of the field
    [activityQuery whereKey:@"ActivityType" equalTo:@"follow"];
    [activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
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
                 //[photos addObject:photo];
                 
                 NSLog(@"retrieved related photo: %@", photo);
             }
             
             //[myCollectionView reloadData];
         }
         else
         {
             // Log details of the failure
             NSLog(@"Error: %@ %@", error, [error userInfo]);
         }
     }];
    
}

- (void)createFollowingActivitesForUser:(PFObject*)photo
{
    PFObject *follow = [PFObject objectWithClassName:@"Activity"];
    [follow setObject:@"follow" forKey:@"ActivityType"];
    [follow setObject:[PFUser currentUser] forKey:@"fromUser"];
    [follow setObject:@"ip69EIBEtb" forKey:@"toUser"];
    [follow setObject:photo forKey:@"photo"];
    
    [follow saveEventually:^(BOOL succeeded, NSError *error) {
        if (!error)
        {
            
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
    
}

@end
