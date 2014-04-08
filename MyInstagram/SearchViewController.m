//
//  SearchViewController.m
//  MyInstagram
//
//  Created by Jian Yao Ang on 4/7/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "SearchViewController.h"
#import "ImageCollectionViewCell.h"
#import <Parse/Parse.h>

@interface SearchViewController () <UISearchBarDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
{
    
    IBOutlet UICollectionView *searchCollectionView;
    IBOutlet UISearchBar *mySearchBar;
    NSArray* users;
    NSString* lastSearch;
}
@end

@implementation SearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self onViewLoadSearch];
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    //remove white space characters
    if (searchBar.text.length !=0)
    {
        NSString* searchString = [searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        [self onViewLoadSearch:searchString];
        [searchBar resignFirstResponder];
        lastSearch = searchString;
    }
}

//query searches for Users by name
- (void)onViewLoadSearch:(NSString*)searchText
{
    //set the object class to look for
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    //set the field to search and the value of the field
    [query whereKey:@"username" equalTo:searchText];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        if (!error)
        {
            // The find succeeded.
            NSLog(@"Successfully retrieved %uld photos.", objects.count);
            
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


//query searches for Users by name
- (void)onViewLoadSearch
{
    //set the object class to look for
    PFQuery *query = [PFQuery queryWithClassName:@"User"];
    
    NSString* date = [NSString stringWithFormat:@"%@",[NSDate date]];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc]init];
    
    dateFormatter.dateStyle  = NSDateFormatterMediumStyle;
    
    //set the field to search and the value of the field
    [query whereKey:@"updatedAt" equalTo:[NSString stringWithFormat:@"%@",[dateFormatter dateFromString:date]]];
    
    NSLog(@"date: %@", [dateFormatter dateFromString:date]);
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         if (!error)
         {
             // The find succeeded.
             NSLog(@"Successfully retrieved %uld photos.", objects.count);
             
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



-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return users.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SearchCellIdentifier" forIndexPath:indexPath];
    
    PFObject* user = users[indexPath.row];
    PFFile* file = user[@"photo"];
    NSData* data = [file getData];
    cell.imageView.image = [UIImage imageWithData:data];
    
    return cell;
}


@end
