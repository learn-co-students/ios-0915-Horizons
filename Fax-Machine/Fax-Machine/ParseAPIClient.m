//
//  ParseAPIClient.m
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import "ParseAPIClient.h"

@implementation ParseAPIClient

/**
 *  Fetch user profile data from Parse
 *
 *  @param user            PFObject form current user
 *  @param completionBlock Callback to pass returned user profile data from Parse
 */
+(void)fetchUserProfileDataWithUserObject:(PFObject *)user andCompletion:(void (^)(PFObject *data))completionBlock{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"parent = %@", user];
    PFQuery *query = [PFQuery queryWithClassName:@"IHPUser" predicate:predicate];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            completionBlock(object);
        }else{
            NSLog(@"Error on getting user object: %@", error.localizedDescription);
        }
    }];
}

@end
