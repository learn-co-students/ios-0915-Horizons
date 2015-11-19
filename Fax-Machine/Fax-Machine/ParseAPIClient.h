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

+(void)fetchImagesWithPredicate:(NSPredicate *)predicate
                 numberOfImages:(NSUInteger)numberOfImages
                     completion:(void (^)(NSArray *data))completionBlock
                        failure:(void(^)(NSError *error))failure ;

+(void)fetchAllCommentsWithRelatedImage:(PFObject *)imageObject
                             completion:(void (^)(NSArray *data))completionBlock
                                failure:(void(^)(NSError *error))failure;

@end
