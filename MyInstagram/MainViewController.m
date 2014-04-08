//
//  ViewController.m
//  MyInstagram
//
//  Created by Jian Yao Ang on 4/7/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "MainViewController.h"
#import "ImageCollectionViewCell.h"
#import <Parse/Parse.h>

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSArray *users;
    IBOutlet UICollectionView *myCollectionView;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //assign an automated user
    [PFUser enableAutomaticUser];
    
    //[self CreateRandomPhotosForUsers];
    
    [self queryParseForUserPhotos];

}


- (void)queryParseForUserPhotos
{
    //set the object class to look for
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    //set the field to search and the value of the field
    [query whereKey:@"username" equalTo:@"jay"]; //replace with current user or !current user for search
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            //assign result array of photos to our array
            users = objects;
            [myCollectionView reloadData];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}


- (IBAction)onPhotoDoubleTapped:(UITapGestureRecognizer *)sender
{
    NSLog(@"tap gesture recognized");
    
    //create an activity and associate to user
    
    NSURL* url =[NSURL URLWithString:@"http://placekitten.com/320/320"];
    
    PFObject* like = [PFObject objectWithClassName:@"Activity"];
    like[@"fromUser"] = [PFUser currentUser];
    like[@"type"] = @"like";
    like[@"photo"] = [NSData dataWithContentsOfURL:url];
    like[@"content"]= [NSString stringWithFormat:@"%@ liked your photo",[PFUser currentUser]];
    like[@"fromUser"] = [PFUser currentUser];
    
    
}

-(void)CreateRandomPhotosForUsers
{

//    for (int i=0; i < 20; i++)
//    {
//        int width = 270 + arc4random()%100;
//        int height = 270 + arc4random()%100;
//        
//        NSString* urlString =[NSString stringWithFormat:@"http://placekitten.com/%d/%d",width,height];
//        
//        NSURL* url = [NSURL URLWithString:urlString];
//        
//        NSData* data = [NSData dataWithContentsOfURL:url];
//        
//        PFObject* object = [PFObject objectWithClassName:@"User"];
//        PFFile* file = [PFFile fileWithData:data];
//        
//        [object setObject:file forKey:@"photo"];
//        [object setObject:@"dennis" forKey:@"username"];
//        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//        {
//            if (error)
//            {
//                NSLog(@"%@", [error userInfo]);
//            }
//        }];
//    }

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return users.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //create tap gesture recognizer
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPhotoDoubleTapped:)];
    
    //set number of taps required
    gestureRecognizer.numberOfTapsRequired = 2;
    
    
    //add tap gesture to view
    [self.view addGestureRecognizer:gestureRecognizer];
   
    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellIdentifier" forIndexPath:indexPath];
    PFObject* user = users[indexPath.row];
    PFFile* file = user[@"photo"];
    NSData* data = [file getData];
    cell.imageView.image = [UIImage imageWithData:data];
    return cell;
}



@end
