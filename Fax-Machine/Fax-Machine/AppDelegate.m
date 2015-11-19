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
    
    PFUser *user = [PFUser user];
    user.username = @"test@test.com";
    user.password = @"123456";
    user.email = @"test@test.com";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Registration succeeded!");
            
            PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:40.2155 longitude:-69.2351];
            Location *location = [[Location alloc] initWithCity:@"New York" country:@"United States" geoPoint:point dateTaken:[NSDate date]];
            
            PFObject *parseLocation = [PFObject objectWithClassName:@"Location"];
            parseLocation[@"city"] = location.city;
            parseLocation[@"country"] = location.country;
            parseLocation[@"geoPoint"] = location.geoPoint;
            parseLocation[@"dateTaken"] = location.dateTaken;
            [parseLocation saveInBackground];
            
            ImageObject *image = [[ImageObject alloc] initWithOwner:user title:@"Some Photo" imageID:@"124124" likes:@0 mood:@"😊" location:parseLocation comments:nil];
            
            PFObject *parseImage = [PFObject objectWithClassName:@"Image"];
            parseImage[@"owner"] = image.owner;
            parseImage[@"title"] = image.title;
            parseImage[@"photoID"] = image.imageID;
            parseImage[@"likes"] = image.likes;
            parseImage[@"mood"] = image.mood;
            parseImage[@"location"] = image.location;
            [parseImage saveInBackground];

            
            
        
            ImageObject *image2 = [[ImageObject alloc] initWithOwner:user title:@"Some Photo1" imageID:@"124123fsf4" likes:@0 mood:@"😊" location:parseLocation comments:nil];
            
            PFObject *parseImage2 = [PFObject objectWithClassName:@"Image"];
            parseImage2[@"owner"] = image2.owner;
            parseImage2[@"title"] = image2.title;
            parseImage2[@"photoID"] = image2.imageID;
            parseImage2[@"likes"] = image2.likes;
            parseImage2[@"mood"] = image2.mood;
            parseImage2[@"location"] = image2.location;
            
            [parseImage2 saveInBackground];
            
            PFObject *currentUser = [PFUser currentUser];
            NSLog(@"Current User: %@", currentUser);
            currentUser[@"myImages"] = @[parseImage, parseImage2];
            [currentUser saveInBackground];
            NSLog(@"/n/nDone!!!!!!!!");
            
        }else{
            NSLog(@"Error on registration: %@", error.localizedDescription);
        }
    }];
    
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
