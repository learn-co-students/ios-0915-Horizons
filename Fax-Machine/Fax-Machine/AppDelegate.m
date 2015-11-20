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
#import "ParseAPIClient.h"
#import "Comment.h"
#import "ImageObject.h"
#import "DataStore.h"
#import <RESideMenu/RESideMenu.h>
#import "ProfileMenuRootViewController.h"

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
    
    return YES;
}

@end
