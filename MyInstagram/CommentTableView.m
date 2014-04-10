//
//  CommentTableView.m
//  MyInstagram
//
//  Created by Jian Yao Ang on 4/9/14.
//  Copyright (c) 2014 Jian Yao Ang. All rights reserved.
//

#import "CommentTableView.h"

@interface CommentTableView ()
{
    
    IBOutlet UITableView *commentTableView;
    IBOutlet UITextView *commentTextView;
}

@end

@implementation CommentTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    self.parseClassName = @"Activity";
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [commentTableView reloadData];
}

-(PFTableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    PFTableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath object:object];
    cell.textLabel.text = commentTextView.text;
    [cell.imageView loadInBackground];
    return cell;
}

- (IBAction)onCommentButtonPressed:(id)sender
{
    [self enterComment];
    [commentTextView resignFirstResponder];
    [commentTableView reloadData];
}

-(void)enterComment
{
    PFObject *comment = [PFObject objectWithClassName:@"Activity"];
    comment[@"comment"] = commentTextView.text;
    [comment setObject:@"comment" forKey:@"ActivityType"];
    [comment setObject:[PFUser currentUser] forKey:@"fromUser"];
    
    //user (creator) of the original photo
    [comment setObject:self.photo[@"user"] forKey:@"toUser"];
    
    //the PFObject class Photo object
    [comment setObject:self.photo forKey:@"photo"];
 
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"%@",[error userInfo]);
        }
    }];
}


@end
