//
//  AppDelegate.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/17/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "AppDelegate.h"
#import <AWSCore/AWSCore.h>
#import <Parse/Parse.h>
#import "APIConstants.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
  
  // AWS STUFF 

  AWSCognitoCredentialsProvider *credentialsProvider = [[AWSCognitoCredentialsProvider alloc] initWithRegionType:AWSRegionUSEast1
                                                                                                  identityPoolId:POOL_ID
                                                        ];
  AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion:AWSRegionUSEast1
                                                                       credentialsProvider:credentialsProvider];
  AWSServiceManager.defaultServiceManager.defaultServiceConfiguration = configuration;
  
  // PARSE STUFF

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

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

@end
