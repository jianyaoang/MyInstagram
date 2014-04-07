//
//  ViewController.m
//  MyInstagram
//
//  Created by Jian Yao Ang on 4/7/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "MainViewController.h"
#import "ImageCollectionViewCell.h"

@interface MainViewController () <UICollectionViewDataSource, UICollectionViewDelegate>
{
    
    IBOutlet UICollectionView *myCollectionView;
}

@end

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 0;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellIdentifier" forIndexPath:indexPath];
    return cell;
}



@end
