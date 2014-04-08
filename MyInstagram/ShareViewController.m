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
    NSData *fileData = UIImagePNGRepresentation(self.myImage.image);
    PFFile *file = [PFFile fileWithName:@"sunset" data:fileData];
    [object setObject:file forKey:@"photo"];
    [object setObject:[PFUser currentUser] forKey:@"user"];
    
     NSLog(@"This is my fileData%@",fileData);
    [object saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error)
    {
        if (error)
        {
            NSLog(@"%@",[error userInfo]);
        }
    }];
    
   
    

}



@end
