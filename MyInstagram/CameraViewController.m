//
//  CameraViewController.m
//  MyInstagram
//
//  Created by Jian Yao Ang on 4/7/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "CameraViewController.h"
#import "ShareViewController.h"
@interface CameraViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) IBOutlet UIImageView *myImageView;

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSData *fileData = UIImagePNGRepresentation([UIImage imageNamed:@"chicagosunset.jpg"]);
    self.myImageView.image = [UIImage imageWithData:fileData];
    
//    self.myImageView.image = [UIImage imageNamed:@"harrypotter"];
}

- (IBAction)onCameraBarButtonPressed:(UIBarButtonItem*)sender
{
    [self takePictures:sender];
}

-(void)takePictures:(id)sender
{

    UIImagePickerController *imagePicker = [UIImagePickerController new];
    [imagePicker setDelegate:self];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        imagePicker.modalPresentationStyle = UIModalPresentationCurrentContext;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        [self presentViewController:imagePicker animated:YES completion:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [self.myImageView setImage:image];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UIButton*)sender
{
    if ([segue.identifier isEqualToString:@"ToShowShareViewController"])
    {
        ShareViewController *vc = segue.destinationViewController;
//        UIImage *image = [UIImage imageNamed:@"harrypotter"];
//        vc.myImage.image = image;
        vc.imageFromCameraViewController = self.myImageView.image;
    }
}


@end
