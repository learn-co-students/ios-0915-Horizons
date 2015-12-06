//
//  ParseAPIClient.h
//  Fax-Machine
//
//  Created by Kevin Lin on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseAPIClient : NSObject

+(void)fetchImageWithImageID:(NSString *)imageID
                  completion:(void (^)(PFObject *data))completionBlock
                     failure:(void(^)(NSError *error))failure;

+(void)fetchImagesWithPredicate:(NSPredicate *)predicate
                 numberOfImages:(NSUInteger)numberOfImages
                     completion:(void (^)(NSArray *data))completionBlock
                        failure:(void(^)(NSError *error))failure;

+(void)fetchImagesWithPredicate:(NSPredicate *)predicate
                 numberOfImages:(NSUInteger)numberOfImages
                           page:(NSUInteger)page
                     completion:(void (^)(NSArray *))completionBlock
                        failure:(void (^)(NSError *))failure;

+(void)fetchAllCommentsWithRelatedImage:(NSString *)imageID
                             completion:(void (^)(NSArray *data))completionBlock
                                failure:(void(^)(NSError *error))failure;

+(void)saveImageWithImageObject:(PFObject *)parseImageObject
                        success:(void (^)(BOOL success))success
                        failure:(void(^)(NSError *error))failure;

+(void)saveCommentWithWithComment:(PFObject *)comment
                      imageObject:(PFObject *)imageObject
                        success:(void (^)(BOOL success))success
                        failure:(void(^)(NSError *error))failure;

+(void)saveLocationWithLocation:(PFObject *)location
                          success:(void (^)(BOOL success))success
                          failure:(void(^)(NSError *error))failure;

+(void)likeImageWithImageObject:(PFObject *)likedImage
                        success:(void (^)(BOOL success))success
                        failure:(void(^)(NSError *error))failure;

+(void)getUserImagesWithCompletion: (void (^)(BOOL))complete;

+(void)getFavoriteImagesWithCompletion:(void (^)(NSArray *images))completionBlock;

+(void)followUserWithUser:(PFUser *)user
                  success:(void (^)(BOOL success))success
                  failure:(void(^)(NSError *error))failure;

+(void)getFolowingUsersWithCompletion:(void (^)(NSArray *owners))completionBlock;

@end
