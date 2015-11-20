//
//  SideBarViewController.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/20/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "SideBarViewController.h"
#import "ProfileMenuRootViewController.h"
#import "LeftMenuViewController.h"

@interface SideBarViewController ()

@property (nonatomic, strong) RESideMenu *sideMenuViewController;

@end

@implementation SideBarViewController

- (RESideMenu *)sideMenuViewController
{
    UIViewController *iter = self.parentViewController;
    while (iter) {
        if ([iter isKindOfClass:[RESideMenu class]]) {
            return (RESideMenu *)iter;
        } else if (iter.parentViewController && iter.parentViewController != iter) {
            iter = iter.parentViewController;
        } else {
            iter = nil;
        }
    }
    return nil;
}


- (IBAction)presentLeftMenu:(id)sender {
    
    [self.sideMenuViewController presentLeftMenuViewController];
}

@end
