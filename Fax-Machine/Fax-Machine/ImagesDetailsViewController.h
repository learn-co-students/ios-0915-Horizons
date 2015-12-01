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

@property (nonatomic, strong) ImageObject *image;

//- (IBAction)commentIcon:(UIBarButtonItem *)sender;
//merge properties, discuss with kevin
@property (weak, nonatomic) IBOutlet UIToolbar *likeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageDetails;
@property (strong) UIImage *img;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likesCounter;
@property (weak, nonatomic) IBOutlet UITableView *belowPictureTableView;


@end
