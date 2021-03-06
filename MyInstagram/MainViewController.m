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
#import "CommentTableView.h"
#import "CommentButton.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    NSMutableArray *photos;
    IBOutlet UICollectionView *myCollectionView;
    UITapGestureRecognizer *doubleTapGestureRecognizer;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    photos = [NSMutableArray new];
    
    //assign an automated user
    [PFUser enableAutomaticUser];
    
    //[self queryParseForUserPhotos];
    
    [self getLikedPhotos];
    
    
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

/*
 * Get the photos which are not related to the current user. This needs to be changed to users we are
 * actually following
 */
- (void)queryParseForUserPhotos
{
    //set the object class to look for
    PFQuery *query = [PFQuery queryWithClassName:@"Photo"];
    
    //set the field to search and the value of the field
    [query whereKey:@"user" notEqualTo:[PFUser currentUser]]; //replace with current user or !current user for search
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error)
        {
            // The find succeeded.
            //NSLog(@"Successfully retrieved %d photos.", objects.count);
            
            //assign result array of photos to our array
            photos = [NSMutableArray arrayWithArray:objects];
            [myCollectionView reloadData];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

/*
 * When a user double taps the photo create a Like activity for that
 * photo with the current user as the fromUser and the creator of the
 * photo being the toUser
 */
- (IBAction)onPhotoDoubleTapped:(UITapGestureRecognizer *)sender
{

    if (sender.state == UIGestureRecognizerStateEnded)
    {
        //find the point that was tapped
        CGPoint point = [sender locationInView:myCollectionView];
        
        //get the index path for the point
        NSIndexPath *indexPath = [myCollectionView indexPathForItemAtPoint:point];
        
        //get the photo object that was liked
        PFObject *photo = photos[indexPath.row];
        
        if (indexPath)
        {
            NSLog(@"Image was double tapped");
            PFObject* like = [PFObject objectWithClassName:@"Activity"];
            [like setObject:@"like" forKey:@"ActivityType"];
            [like setObject:[PFUser currentUser] forKey:@"fromUser"];
            [like setObject:photo[@"user"] forKey:@"toUser"];
            [like setObject:photo forKey:@"photo"];

            
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



//temp method to get photos liked by a user
-(void)getLikedPhotos
{
 
     //set the object class to look for activites
    PFQuery *activityQuery = [PFQuery queryWithClassName:@"Activity"];
    
    //set the field to search and the value of the field
    [activityQuery whereKey:@"ActivityType" equalTo:@"like"];
    [activityQuery whereKey:@"fromUser" equalTo:[PFUser currentUser]];
    
    // Include the photo data with each comment
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
                
                PFObject *photo = activity[@"photo"];
                [photos addObject:photo];
            }
            
            [myCollectionView reloadData];
        }
        else
        {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}


-(void)CreateRandomPhotosForUsers
{

//    // Resize image
//    UIImage* image = [UIImage imageNamed:@"armitagemorning.jpg"];
//    
//    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
//    [image drawInRect: CGRectMake(0, 0, 640, 960)];
//    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    NSData *fileData = UIImageJPEGRepresentation(smallImage, 1.0f);
//    
//    PFFile *file = [PFFile fileWithData:fileData];
//    
//    PFObject* object = [PFObject objectWithClassName:@"Photo"];
//    [object setObject:file forKey:@"image"];
//    [object setObject:[PFUser currentUser] forKey:@"user"];
    
    
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
//        PFObject* object = [PFObject objectWithClassName:@"Photo"];
//        PFFile* file = [PFFile fileWithData:data];
//        
//        [object setObject:file forKey:@"image"];
//        [object setObject:[PFUser currentUser] forKey:@"user"];
//        [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
//        {
//            if (error)
//            {
//                NSLog(@"%@", [error userInfo]);
//            }
//        }];
//    }

}

#pragma mark - UICollectionViewDelegate Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return photos.count;
}


-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    //create tap gesture recognizer
    doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onPhotoDoubleTapped:)];

    //set number of taps required
    doubleTapGestureRecognizer.numberOfTapsRequired = 2;

    //add tap gesture to view
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];

    
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellIdentifier" forIndexPath:indexPath];
    CommentButton* button = (CommentButton*)cell.commentButton;
    button.indexPath = indexPath;
    
    //add tap gesture to view
    [self.view addGestureRecognizer:doubleTapGestureRecognizer];
    
//    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellIdentifier" forIndexPath:indexPath];
    
    //retreive image from photo obejct
    PFObject *photo = photos[indexPath.row];
    PFFile* file = photo[@"image"];
    NSData* data = [file getData];
    cell.imageView.image = [UIImage imageWithData:data];
    return cell;
}

//-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
//{
//    NSLog(@"gesture state %d",doubleTapGestureRecognizer.state);
//    
//    if (doubleTapGestureRecognizer.state == UIGestureRecognizerStatePossible)
//    {
//        return;
//    }
//    CommentTableView* vc = segue.destinationViewController;
//    NSIndexPath* indexPath = [myCollectionView indexPathForCell:sender];
//    vc.photo = photos[indexPath.row];
    
    //button to view to ImageCollectionCell => sender.superview.superview
//    UIView* view = (UIView*)sender.superview;
//    ImageCollectionViewCell *collectionViewCell = (ImageCollectionViewCell*)view.superview;
//    ImageCollectionViewCell *collectionViewCell = (ImageCollectionViewCell*)sender.superview;
    
//    NSIndexPath *indexPath = [myCollectionView indexPathForCell:collectionViewCell];
//    vc.photo = photos[indexPath.row];
//}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(CommentButton*)sender
{
    CommentTableView *commentView = segue.destinationViewController;
    commentView.photo = photos[sender.indexPath.row];
    NSLog(@"button.indexPath is %@",commentView.photo);
}



@end
