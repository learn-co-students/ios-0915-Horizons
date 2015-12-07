//
//  DataStore.h
//  Fax-Machine
//
//  Created by Claire Davis on 11/18/15.
//  Copyright © 2015 Flatiron-School. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AWSS3/AWSS3.h>
#import "Location.h"
#import "ImageObject.h"
#import "Comment.h"
#import "ParseAPIClient.h"

@interface DataStore : NSObject

@property (nonatomic, strong)NSMutableArray *downloadedPictures;
@property (nonatomic, strong)NSMutableArray *comments;
@property (nonatomic, strong)NSMutableArray *userPictures;
@property (nonatomic, strong)NSMutableArray *controllers;
@property (nonatomic, strong)NSMutableDictionary *filterDictionary;
@property (nonatomic)BOOL isUserVC;
@property (nonatomic, strong) NSMutableArray *favoriteImages;
@property (nonatomic, strong) NSMutableArray *followingList;
@property (nonatomic, strong) NSMutableArray *followingOwnerImageList;
@property (nonatomic, strong) NSMutableArray *filteredImageList;

+ (instancetype)sharedDataStore;
+(void)uploadPictureToAWS:(AWSS3TransferManagerUploadRequest*)uploadRequest WithCompletion:(void(^)(BOOL complete))completionBlock;

-(void)downloadPicturesToDisplay:(NSUInteger)imagesToDownloadFromParseQuery
                  WithCompletion:(void(^)(BOOL complete))completionBlock;

-(void)uploadImageWithImageObject:(ImageObject*)imageObject
                   WithCompletion:(void(^)(BOOL complete))completionBlock;

-(void)inputCommentWithComment:(NSString *)comment
                       imageID:(NSString *)imageID
                withCompletion:(void(^)(PFObject *comment))completionBlock;

-(void)likeImageWithImageID:(NSString *)imageID
             withCompletion:(void(^)(BOOL complete))completionBlock;

-(void)logoutWithSuccess:(void(^)(BOOL success))success;

-(void)fetchUserImagesWithCompletion:(void(^)(BOOL complete))completionBlock;

-(void)getFavoriteImagesWithSuccess:(void (^)(BOOL success))success;

-(void)getOwnerWithObjectID:(NSString *)objectId
                    success:(void (^)(PFUser *owner))success;

-(void)getAllCommentsWithImageID:(NSString *)imageID
                  withCompletion:(void(^)(BOOL complete))completionBlock;

-(void)downloadPicturesToDisplayWithPredicate:(NSPredicate *)predicate
                                  andLocation:(Location *)location
                               numberOfImages:(NSUInteger)number
                               WithCompletion:(void(^)(BOOL complete))completionBlock;

-(void)downloadPicturesToDisplay:(NSUInteger)numberOfImages
                       predicate:(NSPredicate *)predicate
                  WithCompletion:(void(^)(BOOL complete))completionBlock;

-(void)followImageOwner:(PFUser *)owner
                completion:(void (^)(BOOL success))completion;

-(void)getFollowingUsersWithSuccess:(void (^)(BOOL success))success;

@end
