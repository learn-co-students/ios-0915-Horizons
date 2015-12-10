//
//  ProfileMenuRootViewController.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/20/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ProfileMenuRootViewController.h"

@interface ProfileMenuRootViewController ()

@end

@implementation ProfileMenuRootViewController

-(void)awakeFromNib{
    
    self.menuPreferredStatusBarStyle = UIStatusBarStyleLightContent;
    self.contentViewShadowColor = [UIColor blackColor];
    self.contentViewShadowOffset = CGSizeMake(0, 0);
    self.contentViewShadowOpacity = 0.6;
    self.contentViewShadowRadius = 20;
    self.contentViewShadowEnabled = YES;
    
    self.contentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"contentViewController"];
    self.leftMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"leftMenuViewController"];
    self.rightMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"rightMenuViewController"];
    self.view.backgroundColor = [UIColor colorWithWhite:.15 alpha:.85];
  
    self.delegate = self;
    
}

#pragma mark -
#pragma mark RESideMenu Delegate


@end
