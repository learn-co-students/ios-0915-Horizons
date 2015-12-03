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
 *  Fetch a single image from Parse
 *
 *  @param imageID         The unique image id to point to specific image
 *  @param completionBlock Call back with returned image object
 *  @param failure         Call back with error incase of failure
 */
+(void)fetchImageWithImageID:(NSString *)imageID
                  completion:(void (^)(PFObject *))completionBlock
                     failure:(void (^)(NSError *))failure{
    PFQuery *query = [PFQuery queryWithClassName:@"Image"];
    [query whereKey:@"imageID" equalTo:imageID];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        if (!error) {
            completionBlock(object);
        }else{
            failure(error);
        }
    }];
}

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
    PFQuery *query = [PFQuery queryWithClassName:@"Image" predicate:predicate];
    //[query includeKey:@"comments"];
    [query includeKey:@"owner"];
    [query includeKey:@"location"];
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
 *  Fetch images info from Parse
 *
 *  @param predicate       Filter input
 *  @param numberOfImages  Number of images wanted to return
 *  @param completionBlock Call back to pass the returned array of image information
 *  @param failure         Call back with error incase of failure
 */
+(void)fetchImagesWithPredicate:(NSPredicate *)predicate
                 numberOfImages:(NSUInteger)numberOfImages
                           page:(NSUInteger)page
                     completion:(void (^)(NSArray *))completionBlock
                        failure:(void (^)(NSError *))failure{
    //Quering the Photo object from Parse with filter parameters.
    PFQuery *query = [PFQuery queryWithClassName:@"Image" predicate:predicate];
    //[query includeKey:@"comments"];
    [query includeKey:@"owner"];
    [query includeKey:@"location"];
    //Setting the maximum numbers of return objects.
    query.limit = numberOfImages;
    query.skip = page * numberOfImages;
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
+(void)fetchAllCommentsWithRelatedImage:(NSString *)imageID
                             completion:(void (^)(NSArray *))completionBlock
                                failure:(void (^)(NSError *))failure{
    [ParseAPIClient fetchImageWithImageID:imageID completion:^(PFObject *data) {
        PFQuery *query = [PFQuery queryWithClassName:@"Comment"];
        
        [query includeKey:@"owner"];
        [query orderByAscending:@"createdAt"];
        //Querying the relatedImage column in Parse with content equal to the given imageObject.
        [query whereKey:@"relatedImage" equalTo:data];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if (!error) {
                completionBlock(objects);
            } else {
                failure(error);
            }
        }];
    } failure:^(NSError *error) {
        NSLog(@"Fetch image error");
    }];
}

/**
 *  Upload an image object to Parse
 *
 *  @param parseImageObject The image object to upload
 *  @param success          Call back with status
 *  @param failure          Call back with error incase failure
 */
+(void)saveImageWithImageObject:(PFObject *)parseImageObject
                        success:(void (^)(BOOL))success
                        failure:(void (^)(NSError *))failure{
    [parseImageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            PFObject *user = [PFUser currentUser];
            [user addUniqueObject:parseImageObject forKey:@"myImages"];
            [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    success(succeeded);
                } else {
                    NSLog(@"User saving image error: %@", error.localizedDescription);
                }
            }];
        }else{
            failure(error);
        }
    }];
}

/**
 *  Save comment to Parse with comment object
 *
 *  @param comment     Comment object to save
 *  @param imageObject Image object where comment related to
 *  @param success     Call back with status
 *  @param failure     Call back with error incase of failure
 */
+(void)saveCommentWithWithComment:(PFObject *)comment
                      imageObject:(PFObject *)imageObject
                          success:(void (^)(BOOL))success
                          failure:(void (^)(NSError *))failure{
    [comment saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            [imageObject addObject:comment forKey:@"comments"];
            [imageObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (succeeded) {
                    success(YES);
                }else{
                    failure(error);
                }
            }];
        }else{
            failure(error);
        }
    }];
}

/**
 *  Save image location to Parse with location object
 *
 *  @param location Location object to upload
 *  @param success  Call back with status
 *  @param failure  Call back with error incase of failure
 */
+(void)saveLocationWithLocation:(PFObject *)location
                        success:(void (^)(BOOL))success
                        failure:(void (^)(NSError *))failure{
    [location saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            success(YES);
        } else {
            failure(error);
        }
    }];
}

/**
 *  Append an image to user's save image list
 *
 *  @param likedImage Image to append
 *  @param success    Call back with status
 *  @param failure    Call back with error incase of failure
 */
+(void)likeImageWithImageObject:(PFObject *)likedImage
                        success:(void (^)(BOOL))success
                        failure:(void (^)(NSError *))failure{
    PFObject *user = [PFUser currentUser];
    [user addObject:likedImage forKey:@"savedImages"];
    [user saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            success(YES);
        } else {
            failure(error);
        }
    }];
}

/**
 *  Retrieving a list of images 
 *
 *  @param complete
 */
+(void)getUserImagesWithCompletion: (void (^)(BOOL))complete
{

    PFUser *currentUser = [PFUser currentUser];
//    NSMutableArray *images = [[NSMutableArray alloc]init];
    PFQuery *photoQuery = [PFQuery queryWithClassName:@"Image"];
    [photoQuery whereKey:@"owner" equalTo:currentUser];
    [photoQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
      if (!error) {
        complete(YES);
        
      } else {
        NSLog(@"error: %@", error);
      }
    }];
  
}

/**
 *  Retriving all the images an user liked.
 *
 *  @param completionBlock Callback with returned images.
 */
+(void)getFavoriteImagesWithCompletion:(void (^)(NSArray *))completionBlock{
    PFQuery *userQuery = [PFUser query];
    [userQuery whereKey:@"objectId" equalTo:[PFUser currentUser].objectId];
    [userQuery includeKey:@"savedImages"];
    
    [userQuery getFirstObjectInBackgroundWithBlock:^(PFObject * _Nullable object, NSError * _Nullable error) {
        completionBlock(object[@"savedImages"]);
    }];
}

@end
