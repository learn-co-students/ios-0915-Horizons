//
//  ImagesDetailsViewController.m
//  Fax-Machine
//
//  Created by Selma NB on 11/19/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ImagesDetailsViewController.h"

@interface ImagesDetailsViewController ()
@property (nonatomic) NSUInteger photoLikesCounter;
@end

@implementation ImagesDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageDetails.image = self.img;
    self.likesCounter.tintColor= [UIColor whiteColor];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithRed:0.66
                                                  green:0.66
                                                   blue:0.66
                                                  alpha:0.75]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)commentIcon:(UIBarButtonItem *)sender {
    
}

- (IBAction)likeButton:(UIBarButtonItem *)sender {
      
    self.photoLikesCounter += 1;
    self.likesCounter.tintColor= [UIColor whiteColor];
    self.likesCounter.title = [NSString stringWithFormat:@"❤️ %ld", self.photoLikesCounter];
    
    
    
    
}
@end
