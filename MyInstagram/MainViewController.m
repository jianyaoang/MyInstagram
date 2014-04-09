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
    
    
    UITabBar *tabBar = self.tabBarController.tabBar;
 
    UITabBarItem *main = [tabBar.items objectAtIndex:0];
    UITabBarItem *search = [tabBar.items objectAtIndex:1];
    UITabBarItem *followers = [tabBar.items objectAtIndex:2];
    UITabBarItem *profile = [tabBar.items objectAtIndex:3];
    UITabBarItem *camera = [tabBar.items objectAtIndex:4];
    
    main = [[[self.tabBarController.viewControllers objectAtIndex:0]tabBarItem]initWithTitle:nil image:[UIImage imageNamed:@"main"] selectedImage:[UIImage imageNamed:@"main"]];
    
    search = [[[self.tabBarController.viewControllers objectAtIndex:1]tabBarItem]initWithTitle:nil image:[UIImage imageNamed:@"search"] selectedImage:[UIImage imageNamed:@"search"]];
    
    followers = [[[self.tabBarController.viewControllers objectAtIndex:2]tabBarItem]initWithTitle:nil image:[UIImage imageNamed:@"followers"] selectedImage:[UIImage imageNamed:@"followers"]];
    
    profile = [[[self.tabBarController.viewControllers objectAtIndex:3]tabBarItem]initWithTitle:nil image:[UIImage imageNamed:@"profile"] selectedImage:[UIImage imageNamed:@"profile"]];

    camera = [[[self.tabBarController.viewControllers objectAtIndex:4]tabBarItem]initWithTitle:nil image:[UIImage imageNamed:@"camera"] selectedImage:[UIImage imageNamed:@"camera"]];
    
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

    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //find the point that was tapped
        CGPoint point = [sender locationInView:myCollectionView];
        
        //get the index path for the point
        NSIndexPath *indexPath = [myCollectionView indexPathForItemAtPoint:point];
        
        //get a reference to that cell
        ImageCollectionViewCell* cell = (ImageCollectionViewCell*)[myCollectionView cellForItemAtIndexPath:indexPath];
        
        //create an NSData object for the image
        NSData* data = UIImageJPEGRepresentation(cell.imageView.image, 0.5f);
        
        
        if (indexPath)
        {
            NSLog(@"Image was double tapped");
            PFObject* like = [PFObject objectWithClassName:@"Activity"];
            [like setObject:@"like" forKey:@"ActivityType"];
            [like setObject:[PFUser currentUser] forKey:@"fromUser"];
            [like setObject:[PFUser currentUser]  forKey:@"toUser"];
            [like setObject:data forKey:@"photo"];
            
            [like saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
             {
                if (error)
                {
                    NSLog(@"%@",[error userInfo]);
                }
            }];
        }
    }

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
