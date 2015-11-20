//
//  ImagesDetailsViewController.h
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImagesDetailsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIToolbar *likeIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imageDetails;
@property (strong) UIImage *img;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *likesCounter;

- (IBAction)commentIcon:(UIBarButtonItem *)sender;
- (IBAction)likeButton:(UIBarButtonItem *)sender;
@end
