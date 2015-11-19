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
 *  Fetch images info from Parse
 *
 *  @param predicate       Filter input
 *  @param numberOfImages  Number of images wanted to return
 *  @param completionBlock Call back to pass the returned array of image information
 *  @param failure         Call back with error incase of failure
 */
+(void)fetchImagesWithPredicate:(NSPredicate *)predicate
                 numberOfImages:(NSUInteger)numberOfImages
                     completion:(void (^)(NSArray *))completionBlock
                        failure:(void (^)(NSError *))failure{
    //Quering the Photo object from Parse with filter parameters.
    PFQuery *query = [PFQuery queryWithClassName:@"Photo" predicate:predicate];
    
    //Setting the maximum numbers of return objects.
    query.limit = numberOfImages;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            completionBlock(objects);
        }else{
            failure(error);
        }
    }];
}

/**
 *  Fetch all comments relating to an image from Parse.
 *  Only call this method if the photo object doesn't contain the comment array.
 *
 *  @param imageObject     Where comments corresponding to (image object).
 *  @param completionBlock Call back with all the comments objects (default limit to 100).
 *  @param failure         Call back with error incase of failure.
 */
+(void)fetchAllCommentsWithRelatedImage:(PFObject *)imageObject
                             completion:(void (^)(NSArray *))completionBlock
                                failure:(void (^)(NSError *))failure{
    PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
    
    //Querying the relatedImage column in Parse with content equal to the given imageObject.
    [query whereKey:@"relatedImage" equalTo:imageObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            completionBlock(objects);
        } else {
            failure(error);
        }
    }];
}



@end
