//
//  FollowingViewController.m
//  MyInstagram
//
//  Created by user on 4/8/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "FollowingViewController.h"
#import "FollowingTableViewCell.h"
#import <Parse/Parse.h>
@interface FollowingViewController ()
{

}

@end

@implementation FollowingViewController

- (void)viewDidLoad
{
    self.parseClassName = @"Photo";

    [super viewDidLoad];

}

//- (PFQuery *)queryForTable
//{
//    //set the object class to look for activites
//    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
//    
//    //set the field to search and the value of the field
//    [activityQuery whereKey:@"ActivityType" equalTo:@"follow"];
//    [activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
//    
//    //include the actual photo, not the link to allow the subquery to find the photos
//    [activityQuery includeKey:@"photo"];
//
//    return activityQuery;
//}


- (PFTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFTableViewCell* cell = [super tableView:tableView cellForRowAtIndexPath:indexPath object:object];
    NSLog(@"object %@",object);
    
    cell.imageView.file = object[@"image"];
    [cell.imageView loadInBackground:^(UIImage *image, NSError *error)
    {
    
    }];


    return cell;
}


//temp method to get photos liked by a user
//-(void)getFollowingPhotos
//{
//    NSLog(@"get following photos");
//    
//    //set the object class to look for activites
//    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
//    
//    //set the field to search and the value of the field
//    [activityQuery whereKey:@"ActivityType" equalTo:@"follow"];
//    //[activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
//    
//    [activityQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
//     {
//         if (!error)
//         {
//             // The find succeeded.
//             NSLog(@"Successfully retrieved %d liked photos.", objects.count);
//             
//             //loop over all the activities and get the photo for each one,
//             //then add it to the photo array
//             for (PFObject *activity in objects)
//             {
//                 // This does not require a network access.
//                 PFObject *photo = activity[@"photo"];
//                 [photos addObject:photo];
//                 
//                 NSLog(@"retrieved related photo: %@", photo);
//             }
//             
//             [followingTableView reloadData];
//         }
//         else
//         {
//             // Log details of the failure
//             NSLog(@"Error: %@ %@", error, [error userInfo]);
//         }
//     }];
//    
//}


@end
