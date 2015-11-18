//
//  AppDelegate.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/17/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "APIConstants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    //Setting up initial connection with the Parse app.
    [Parse setApplicationId:PARSE_APPLICATION_KEY clientKey:PARSE_CLIENT_KEY];
 
    //Sample testing for Parse connection before registration function.
    
//    PFUser *user = [PFUser user];
//    user.username = @"user@user.com";
//    user.password = @"123456";
//    user.email = @"user@user.com";
    
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
//        if (succeeded) {
//            NSLog(@"Registration succeeded!");
//        }else{
//            NSLog(@"Error on registration: %@", error.localizedDescription);
//        }
//    }];
    
    return YES;
}

@end
