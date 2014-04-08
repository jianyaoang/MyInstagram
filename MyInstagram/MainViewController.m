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
    
    PFObject *user1 = [PFObject objectWithClassName:@"User"];
    NSData *fileData = UIImagePNGRepresentation([UIImage imageNamed:@"chicagosunset.jpg"]);
    PFFile *file = [PFFile fileWithName:@"chicagosunset.png" data:fileData];
    NSLog(@"file %@",file);

    user1[@"username"] = @"Jay";
    user1[@"photo"] = file;

    
    PFObject *user2 = [PFObject objectWithClassName:@"User"];
    NSData *fileData2 = UIImagePNGRepresentation([UIImage imageNamed:@"armitagemorning.jpg"]);
    PFFile *file2 = [PFFile fileWithName:@"armitagemorning.png" data:fileData2];
    user2[@"username"] = @"Albus";
    user2[@"photo"] = file2;
    
    users = [[NSArray alloc]initWithObjects:user1,user2, nil];
    
    //[user1 saveInBackground];
    //[user2 saveInBackground];
    
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return users.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellIdentifier" forIndexPath:indexPath];
    PFObject* user = users[indexPath.row];
    //NSLog(@"user %@",user);
    PFFile* file = user[@"photo"];
    NSLog(@"file %@",file);
    
    NSData* data = [file getData];
    NSLog(@"data %@",data);
    
    cell.imageView.image = [UIImage imageWithData:data];
    
    //NSLog(@"This is an %@", cell.imageView.image);
    return cell;
}



@end
