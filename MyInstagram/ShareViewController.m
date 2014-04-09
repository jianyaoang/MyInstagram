//
//  ShareViewController.m
//  MyInstagram
//
//  Created by Jian Yao Ang on 4/7/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "ShareViewController.h"
#import <Parse/Parse.h>

@interface ShareViewController ()
{
    
    IBOutlet UITextView *captionTextView;
}

@end

@implementation ShareViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.myImage.image = self.imageFromCameraViewController;
    
}


- (IBAction)onShareButtonPressed:(UIButton*)sender
{
    PFObject *object = [PFObject objectWithClassName:@"Photo"];
    
    // Resize image
    UIGraphicsBeginImageContext(CGSizeMake(640, 960));
    [self.myImage.image drawInRect: CGRectMake(0, 0, 640, 960)];
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *fileData = UIImageJPEGRepresentation(smallImage, 1.0f);
    PFFile *file = [PFFile fileWithName:@"image" data:fileData];
    [object setObject:file forKey:@"image"];
    [object setObject:[PFUser currentUser] forKey:@"user"];

    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
    }];
}





@end
