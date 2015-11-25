//
//  ImagesDetailsViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UsersCommentsViewController.h"

@interface ImagesDetailsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *likeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageDetails;
@property (nonatomic, strong) UIImage *img;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likesCounter;
@property (weak, nonatomic) IBOutlet UITableView *belowPictureTableView;
@property (nonatomic, strong) NSURL *url;

//- (IBAction)commentIcon:(UIBarButtonItem *)sender;
- (IBAction)likeButton:(UIBarButtonItem *)sender;
@end
