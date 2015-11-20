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
- (IBAction)commentIcon:(UIBarButtonItem *)sender;

@property (weak, nonatomic) IBOutlet UILabel *likeLabel;


@property (weak, nonatomic) IBOutlet UIImageView *imageDetails;
@property (strong) UIImage *img;

@end
